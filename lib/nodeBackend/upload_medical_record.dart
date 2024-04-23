import 'dart:async';
import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Add this import

import '../models/report.dart';
import 'jwtStorage.dart';

Future<void> uploadMedicalRecord(UserReport report) async {
  try {
    html.File testFile = report.image;
    // Read the file as bytes
    final reader = html.FileReader();
    final completer = Completer<List<int>>();
    reader.onLoadEnd.listen((_) {
      completer.complete(reader.result as List<int>);
    });
    reader.readAsArrayBuffer(testFile);
    final List<int> fileBytes = await completer.future;

    // Prepare the request
    final url = 'http://localhost:3000/api/medical-records/upload';
    final request = http.MultipartRequest('POST', Uri.parse(url));
    
    // Retrieve the JWT token
    String? token = await retrieveJwtToken();

    // Add the token to the request headers
    request.headers.addAll(<String, String>{
      'Authorization': 'Bearer $token',
    });

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: testFile.name,
      contentType: MediaType.parse(testFile.type), // Change this line
    ));
    // Add any additional data if required, like patientId
    request.fields['originalname'] = testFile.name;
    request.fields['mimetype'] = testFile.type;
    request.fields['buffer'] = base64.encode(fileBytes);

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
