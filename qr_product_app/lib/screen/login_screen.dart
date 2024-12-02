// import 'package:flutter/material.dart';
// import 'authservics.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final AuthService _authService = AuthService();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String _errorMessage = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('تسجيل الدخول')),
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
//                   String token = await _authService.login(
//                       _emailController.text,
//                       _passwordController.text);
//                   // يمكنك إضافة كود لتخزين أو التحقق من رمز JWT هنا
//                   print('تم تسجيل الدخول بنجاح، الرمز المميز: $token');
//                   Navigator.pushReplacementNamed(context, '/home');
//                 } catch (e) {
//                   setState(() {
//                     _errorMessage = e.toString();
//                   });
//                 }
//               },
//               child: Text('تسجيل الدخول'),
//             ),
//             if (_errorMessage.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   _errorMessage,
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/register');
//               },
//               child: Text('ليس لديك حساب؟ سجل هنا'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
