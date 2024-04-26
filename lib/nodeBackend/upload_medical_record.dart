import 'dart:async';
import 'dart:html';
import 'dart:typed_data'; // Import dart:typed_data for Uint8List
import 'package:aap_dev_project/nodeBackend/jwtStorage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/report.dart';

Future<void> uploadMedicalRecord(UserReport report) async {
  try {
    final testFile = report.image; // Assume you have the UserReport object
    print(testFile);
    // Prepare the request
    final url = 'http://localhost:3000/api/medical-records/upload';
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Retrieve the JWT token
    final token = await retrieveJwtToken();

    // Add the token to the request headers
    request.headers['Authorization'] = 'Bearer $token';

    // Read the file as a blob
    final blob = testFile; // No need to wrap it in html.Blob constructor

    // Convert Blob to bytes
    final reader = FileReader();
    reader.readAsArrayBuffer(blob);
    await reader.onLoad.first;
    final byteData = Uint8List.fromList(reader.result as List<int>);

    // Create a stream from bytes
    final stream = http.ByteStream.fromBytes(byteData);

    // Add the stream to the multipart request
    request.files.add(http.MultipartFile(
      'file',
      stream,
      byteData.length,
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
