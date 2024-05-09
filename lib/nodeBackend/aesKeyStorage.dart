import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:rsa_encrypt/rsa_encrypt.dart'; 
import 'package:pointycastle/export.dart';

import 'jwtStorage.dart';

Future<void> generateAndStoreAESKey(String password) async {
  // Create an instance of FlutterSecureStorage
  const storage = FlutterSecureStorage();

  // Generate a salt for PBKDF2
  final random = Random.secure();
  final salt = Uint8List.fromList(List<int>.generate(16, (_) => random.nextInt(256)));
  
  // Derive a 256-bit (32-byte) AES key from the password using PBKDF2
  final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
  pbkdf2.init(Pbkdf2Parameters(salt, 10000, 32));
  final aesKey = pbkdf2.process(utf8.encode(password));

  // Convert the key to a string format suitable for storage
  final keyString = base64Encode(aesKey);

  // Encrypt the file data with the AES key
    final iv = encrypt.IV.fromLength(16); // Random initialization vector
    // Convert the IV to a string
final ivString = base64.encode(iv.bytes);

// Store the IV string in secure storage
await storage.write(key: 'iv', value: ivString);
  // Store the key and salt in secure storage
  await storage.write(key: 'aesKey', value: keyString);
  await storage.write(key: 'salt', value: base64Encode(salt));
  print("iv stored: ");
  print(await storage.read(key: "iv"));
  print("aesKey stored: ");
  print(await storage.read(key: "aesKey"));
}

Future<encrypt.Key?> retrieveAESKey() async {
  // Create an instance of FlutterSecureStorage
  const storage = FlutterSecureStorage();

  // Retrieve the key string from secure storage
  final keyString = await storage.read(key: 'aesKey');

  // Convert the string back to an AES key
  if( keyString != null){
  final aesKey = encrypt.Key.fromBase64(keyString);
    return aesKey;
  }
  else{
    return null;
  }

}
Future<void> sendEncryptedAESKey() async {

  try {
    // Create an instance of FlutterSecureStorage
    const storage = FlutterSecureStorage();

    // Retrieve the RSA public key and AES key from secure storage
    final publicKeyString = await storage.read(key: 'rsaPublicKey');
    final aesKeyString = await storage.read(key: 'aesKey');

    if (publicKeyString == null || aesKeyString == null) {
      print('Keys not found in storage');
      return;
    }

    // Convert the keys from string to usable format
    final publicKey = RsaKeyHelper().parsePublicKeyFromPem(publicKeyString); // Use rsa_encrypt to parse the PEM string
    final aesKey = base64Decode(aesKeyString);

    // Encrypt the AES key with the RSA public key
    final encrypter = pc.RSAEngine()
      ..init(true, pc.PublicKeyParameter<pc.RSAPublicKey>(publicKey));
    final encryptedAesKey = encrypter.process(aesKey);

    // Convert the encrypted AES key to a base64 string for transmission
    final encryptedAesKeyString = base64Encode(encryptedAesKey);

    
    // Retrieve the JWT token
    final token = await retrieveJwtToken();

    final iv = await storage.read(key: 'iv');
    // Send the encrypted AES key to the Node.js server
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/patients/storeAESkey'), // Replace with your actual API endpoint
      headers: {
        'Content-Type': 'application/json',
         'Authorization': 'Bearer $token',
        // 'encryptedAesKey': encryptedAesKeyString,
        },
      body: jsonEncode({'encryptedAesKey': encryptedAesKeyString, 'IV': iv}),
    );

    if (response.statusCode == 200) {
      print('AES key sent successfully');
    } else {
      print('Failed to send AES key: ${response.statusCode} - ${response.body}');
    }
  } catch (error) {
    print('Error during key transmission: $error');
  }
}
