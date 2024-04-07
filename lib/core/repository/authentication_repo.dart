// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AuthenticationRepository {
//   final _baseUrl = 'mongodb://127.0.0.1:27017/MedQR'; // Replace with your base URL

//   Future<dynamic> signup(
//       String name, String email, String mobileNumber, String password) async {
//     final response = await http.post(Uri.parse('$_baseUrl/signup'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'name': name,
//           'email': email,
//           'mobileNumber': mobileNumber,
//           'password': password
//         }));

//     if (response.statusCode == 201) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to signup user');
//     }
//   }

//   Future<dynamic> login(String email, String password) async {
//     final response = await http.post(Uri.parse('$_baseUrl/signin'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': email,
//           'password': password
//         }));

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to signin user');
//     }
//   }

//   Future<void> forgotPassword(String email) async {
//     final response = await http.post(Uri.parse('$_baseUrl/forgotPassword'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': email,
//         }));

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to send forgot password request');
//     }
//   }

//   Future<void> verifyOTPAndChangePassword(
//       String email, String otp, String newPassword) async {
//     Future<void> verifyOTPAndChangePassword(
//           String email, String otp, String newPassword) async {
//         final response = await http.post(Uri.parse('$_baseUrl/verifyOTPAndChangePassword'),
//             headers: {'Content-Type': 'application/json'},
//             body: jsonEncode({
//               'email': email,
//               'otp': otp,
//               'newPassword': newPassword
//             }));

//         if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//         } else {
//           throw Exception('Failed to verify OTP and change password');
//         }
//       }
//   }
// }



import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticationRepository {
  final String baseUrl = 'http://localhost:3000/api/patients';

    Future<String> login(String email, String password) async {
      final response = await http.post(Uri.parse('$baseUrl/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password
          }));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        throw Exception('Failed to login user');
      }
    }
  

Future<String> signup(String name, String email, String mobileNumber, String password) async {
  final response = await http.post(Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'mobileNumber': mobileNumber,
        'password': password
      }));
print(response.body);
  if (response.statusCode == 200) {
    print('chal gya lol');
        final data = jsonDecode(response.body);
        return data['token'];
      }  else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to signup user');
  }
}
  Future<void> forgotPassword(String email) async {
    Future<void> forgotPassword(String email) async {
      final response = await http.post(Uri.parse('$baseUrl/forgotPassword'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
          }));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send forgot password request');
      }
    }
  }

  Future<void> verifyOTPAndChangePassword(String email, String otp, String newPassword) async {
    // Implement OTP verification and password change logic here
  }
}