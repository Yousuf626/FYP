import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:aap_dev_project/nodeBackend/jwtStorage.dart';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/api.dart' as crypto;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:web3dart/web3dart.dart';
import '../models/report.dart';
import 'dart:html' as html;
import 'dart:typed_data'; // Import the dart:typed_data library
import 'package:pointycastle/api.dart' as pc;

import 'aesKeyStorage.dart'; // Import the pointycastle library
// Future<void> uploadMedicalRecord(UserReport report) async {
//   try {
//     final testFile = report.image; // Assume you have the UserReport object
//     print(testFile);
//     // Prepare the request
//     final url = 'http://localhost:3000/api/medical-records/upload';
//     final request = http.MultipartRequest('POST', Uri.parse(url));

//     // Retrieve the JWT token
//     final token = await retrieveJwtToken();

//     // Add the token to the request headers
//     request.headers['Authorization'] = 'Bearer $token';

//     // Read the file as a blob
//     final blob = testFile; // No need to wrap it in html.Blob constructor

//     // Convert Blob to bytes
//     final reader = FileReader();
//     reader.readAsArrayBuffer(blob);
//     await reader.onLoad.first;
//     final byteData = Uint8List.fromList(reader.result as List<int>);

//     // Create a stream from bytes
//     final stream = http.ByteStream.fromBytes(byteData);

//     // Add the stream to the multipart request
//     request.files.add(http.MultipartFile(
//       'file',
//       stream,
//       byteData.length,
//       filename: testFile.name,
//       contentType: MediaType.parse(testFile.type), // Assuming testFile.type gives mime type
//     ));

//     // Send the request
//     final response = await http.Response.fromStream(await request.send());
//     if (response.statusCode == 201) {
//       print('Medical record uploaded successfully');
//     } else {
//       print('Error uploading medical record: ${response.body}');
//     }
//   } catch (e) {
//     print('Error uploading medical record: $e');
//   }
// }

Future<void> uploadMedicalRecord(UserReport report) async {
  try {
    final testFile = report.image; // Assume you have the UserReport object

    var aesKey = await retrieveAESKey();
  
    // Encrypt the file data with the AES key
    final iv = encrypt.IV.fromLength(16); // Random initialization vector
    final encrypter = encrypt.Encrypter(encrypt.AES(aesKey!));
    Uint8List testFileBytes;
    if (testFile is html.File) {
      final reader = html.FileReader();
      reader.readAsDataUrl(testFile);
      await reader.onLoad.first;
      final dataUrl = reader.result as String;
      final byteString = html.window.atob(dataUrl.split(',')[1]);
      testFileBytes = Uint8List(byteString.length);
      for (var i = 0; i < byteString.length; i++) {
        testFileBytes[i] = byteString.codeUnitAt(i);
      }
    } else {
      throw Exception('Unsupported file type');
    }
    final encryptedData = encrypter.encryptBytes(testFileBytes, iv: iv);

    // // Encrypt the AES key with the RSA public key
    // final rsaEncrypter = Encrypter(RSA(publicKey: publicKey as RSAPublicKey));
    // final encryptedAesKey = rsaEncrypter.encrypt(aesKey.base64);

    // Prepare the request
    final url = 'http://localhost:3000/api/medical-records/upload';
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Retrieve the JWT token
    final token = await retrieveJwtToken();

    // Add the token to the request headers
    request.headers['Authorization'] = 'Bearer $token';

    // Create a stream from bytes
final streamData = utf8.encode(encryptedData.base64);

   // Add the stream to the multipart request
request.files.add(http.MultipartFile(
  'file',
  http.ByteStream.fromBytes(streamData),
  streamData.length,
  filename: testFile.name,
  contentType: MediaType.parse(testFile.type), // Assuming testFile.type gives mime type
));
    
    // Send the request
    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 201) {
      print('Medical record uploaded successfully');
    } else {
      print('Error uploading medical record: ${response.body}');
    }
  } catch (e) {
    print('Error uploading medical record: $e');
  }
  
}