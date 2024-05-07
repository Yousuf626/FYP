import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:typed_data';
import 'dart:math';

Future<void> generateAndStoreAESKey() async {
  // Create an instance of FlutterSecureStorage
  const storage = FlutterSecureStorage();

  // Generate a random symmetric key for AES encryption
  final random = Random.secure();
  final randomKey = List<int>.generate(32, (_) => random.nextInt(256));
  final aesKey = encrypt.Key(Uint8List.fromList(randomKey));

  // Convert the key to a string format suitable for storage
  final keyString = aesKey.base64;

  // Store the key in secure storage
  await storage.write(key: 'aesKey', value: keyString);
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
