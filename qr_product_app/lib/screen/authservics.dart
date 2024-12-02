// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthService {
//   static const String baseUrl = 'http://192.168.43.181:3000/api'; // تحديث IP الخاص بك
//
//   Future<void> register(String email, String password) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/register'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'email': email,
//         'password': password,
//       }),
//     );
//
//     if (response.statusCode != 201) {
//       throw Exception('فشل في التسجيل');
//     }
//   }
//
//   Future<String> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'email': email,
//         'password': password,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       String token = jsonDecode(response.body)['token'];
//       // تخزين الرمز باستخدام SharedPreferences
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', token);
//       return token;
//     } else {
//       throw Exception('فشل في تسجيل الدخول');
//     }
//   }
// }
