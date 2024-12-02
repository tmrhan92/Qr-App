// import 'package:flutter/material.dart';
// import '../api_service.dart';
//
// class ProductForm extends StatelessWidget {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Product'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Product Name'),
//             ),
//             TextField(
//               controller: priceController,
//               decoration: InputDecoration(labelText: 'Product Price'),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 final name = nameController.text;
//                 final price = priceController.text;
//                 ApiService.sendProductData(name, price);
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
