import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl =
    'http://localhost:3000/api/patients'; // Replace with your actual API endpoint

Future<http.Response> signup(
    {required String name,
    required String email,
    required String mobileNumber,
    required String password}) async {
  final Map<String, dynamic> body = {
    'name': name,
    'email': email,
    'mobileNumber': mobileNumber,
    'password': password,
  };

  final Uri url = Uri.parse(
      '$baseUrl/signup'); // Replace "/signup" with your actual endpoint

  return await http.post(url, body: jsonEncode(body), headers: {
    'Content-Type': 'application/json',
  });
}
