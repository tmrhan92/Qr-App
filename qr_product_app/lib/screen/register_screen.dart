// import 'package:flutter/material.dart';
// import 'authservics.dart';
//
// class RegistrationScreen extends StatefulWidget {
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }
//
// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final AuthService _authService = AuthService();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String _errorMessage = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('تسجيل مستخدم جديد')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'كلمة المرور'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await _authService.register(
//                       _emailController.text, _passwordController.text);
//                   Navigator.pop(context);  // العودة لشاشة تسجيل الدخول بعد التسجيل
//                 } catch (e) {
//                   setState(() {
//                     _errorMessage = e.toString();
//                   });
//                 }
//               },
//               child: Text('تسجيل'),
//             ),
//             if (_errorMessage.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   _errorMessage,
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
