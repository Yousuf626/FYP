import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:math';
// import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/export.dart';
import 'jwtStorage.dart';

Future<void> generateAndStoreAESKey(String password) async {
  // Create an instance of FlutterSecureStorage
  const storage = FlutterSecureStorage();

  // Generate a salt for PBKDF2
  final random = Random.secure();
  final salt = Uint8List.fromList(List<int>.generate(16, (_) => random.nextInt(256)));
  // print("salt: ${base64Encode(salt)}");
  // Derive a 256-bit (32-byte) AES key from the password using PBKDF2
  final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
  pbkdf2.init(Pbkdf2Parameters(salt, 10, 32));
  final aesKey = pbkdf2.process(utf8.encode(password));

// print(aesKey);
  // Convert the key to a string format suitable for storage
  final keyString = base64Encode(aesKey);

  
    final iv = encrypt.IV.fromLength(16); // Random initialization vector
    // Convert the IV to a string
final ivString = base64.encode(iv.bytes);

// Store the IV string in secure storage
await storage.write(key: 'iv', value: ivString);
  // Store the key and salt in secure storage
  await storage.write(key: 'aesKey', value: keyString);
  await storage.write(key: 'salt', value: base64Encode(salt));
  // print("iv stored: ");
  // print(await storage.read(key: "iv"));
  print("aesKey stored: ");
  print(await storage.read(key: "aesKey"));

// Encrypt the text using AES
  final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromBase64(keyString), mode: encrypt.AESMode.cbc));
  final encryptedText = encrypter.encrypt("testing", iv: iv);
final encryptedBase64 = encryptedText.base64;
// print(encryptedBase64);
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
    print("sendEncryptedAESKey function called");
    // Create an instance of FlutterSecureStorage
    const storage = FlutterSecureStorage();

    // Retrieve the RSA public key and AES key from secure storage
    // final publicKeyString = await storage.read(key: 'rsa_publicKey');
    var publicKeyString = 'MIGeMA0GCSqGSIb3DQEBAQUAA4GMADCBiAKBgFKfEW2XqAMA0END2FN9tlNUxZXiWGdS5OeRhio/Tfw9d0L5d74bqGX8VWViapCJYm7UM5ZSY2UzqVFf/758fVVkutuQi3U79jCs3QwCfjVc4fmwX2BwicwTEySjahXyNA8aC92VUgLZz5cF9vdETkpgFVY64UVJ6inw3UB8oiLTAgMBAAE=';
     publicKeyString = splitStr(publicKeyString);
    final aesKeyString = await storage.read(key: 'aesKey');
     final ivString = await storage.read(key: 'iv');

    if (publicKeyString == null || aesKeyString == null) {  
      print('Keys not found in storage');
      return;
    }
     final aesKey = base64Decode(aesKeyString);

     RSAPublicKey publicKey = RSAKeyParser().parse(publicKeyString) as RSAPublicKey;

    // Convert the keys from string to usable format
      //  final publicKey = RSAKeyParser().parse(publicKeyString) as RSAPublicKey;

      //  final encrypted_key =  rsaEncrypt(publicKey,aesKey);
// Convert the keys from string to usable format
  // final publicKey = RsaKeyHelper().parsePublicKeyFromPem(publicKeyString);


    // final publicKey = RsaKeyHelper().parsePublicKeyFromPem(publicKeyString); // Use rsa_encrypt to parse the PEM string
    // Example usage (replace with placeholder values)
// final publicKey = pc.parsePublicKeyFromPem('-----BEGIN PUBLIC KEY-----...'); // Your public key

    //  final aesKey = base64Decode(aesKeyString);

     // Encrypt the AES key with the RSA public key
  //  final encrypter = pc.RSAEngine()
  //      ..init(true, pc.PublicKeyParameter<pc.RSAPublicKey>(publicKey));

    //     final encrypter = OAEPEncoding(RSAEngine())
    // ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

// final encrypter =pc.RSAEngine()
//   ..init(
//     true,
//     pc.PublicKeyParameter<pc.RSAPublicKey>(publicKey),
    
//   );

    //  final encryptedAesKey = encrypter.process(aesKey);
 
//  print(encryptedAesKey);
    // Convert the encrypted AES key to a base64 string for transmission
    //  final encryptedAesKeyString = base64Encode(encryptedAesKey);
// print(encryptedAesKeyString);


  // final encrypted = encrypter.encrypt();
// print(" encypted AES key:   ${base64.encode(encrypted_key)}");
    // // Retrieve the JWT token
    // final token = await retrieveJwtToken();

    // // Send the encrypted AES key to the Node.js server
    // final response = await http.post(
    //   Uri.parse('http://192.168.100.84:3001/api/patients/storeAESkey'), // Replace with your actual API endpoint
    //   headers: {
    //     'Content-Type': 'application/json',
    //      'Authorization': 'Bearer $token',
    //     // 'encryptedAesKey': aesKeyString,
    //     },
    //   body: jsonEncode({'encryptedAesKey': base64.encode(encrypted.bytes), 'IV': ivString}),
    // );

    // if (response.statusCode == 200) {
    //   print('AES key sent successfully');
    // } else {
    //   print('Failed to send AES key: ${response.statusCode} - ${response.body}');
    // }
  } catch (error) {
    print('Error during key transmission: $error');
  }
}

Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
  final encryptor = OAEPEncoding(RSAEngine())
    ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

  return _processInBlocks(encryptor, dataToEncrypt);
}
Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
  final numBlocks = input.length ~/ engine.inputBlockSize +
      ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

  final output = Uint8List(numBlocks * engine.outputBlockSize);

  var inputOffset = 0;
  var outputOffset = 0;
  while (inputOffset < input.length) {
    final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
        ? engine.inputBlockSize
        : input.length - inputOffset;

    outputOffset += engine.processBlock(
        input, inputOffset, chunkSize, output, outputOffset);

    inputOffset += chunkSize;
  }

  return (output.length == outputOffset)
      ? output
      : output.sublist(0, outputOffset);
}
String splitStr(String str) {
  var begin = '-----BEGIN PUBLIC KEY-----\\n';
  var end = '\\n-----END PUBLIC KEY-----';
  int splitCount = str.length ~/ 64;
  List<String> strList = [];
  for (int i = 0; i < splitCount; i++) {
    strList.add(str.substring(64 * i, 64 * (i + 1)));
  }
  if (str.length % 64 != 0) {
    strList.add(str.substring(64 * splitCount));
  }
  return begin + strList.join('\\n') + end;
}