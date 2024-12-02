import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../api_service.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  var qrstr = '{"productName": "Add Data", "productPosition": "Unknown"}';
  String productName = '';
  String productPosition = '';

  final List<String> knownPositions = [
    'Top',
    'Users',
    'Videos',
    'Sounds',
    'Top1',
    'Users1',
    'Videos1',
    'Sounds1',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.red.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text('QR Code Generator', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            SizedBox(height: 50),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BarcodeWidget(
                      data: qrstr,
                      barcode: Barcode.qrCode(),
                      color: Colors.white,
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField('Enter Product Name', (val) {
                      setState(() {
                        productName = val.trim();
                        updateQrString();
                      });
                    }),
                    const SizedBox(height: 20),
                    _buildTextField('Enter Product Position', (val) {
                      setState(() {
                        productPosition = val.trim();
                        updateQrString();
                      });
                    }),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (!knownPositions.contains(productPosition)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("الموقع المدخل غير معروف!")),
                          );
                          return;
                        }

                        try {
                          // إرسال البيانات إلى products
                          await ApiService.sendProductData(productName, productPosition, qrstr, endpoint: 'products');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("تم حفظ المنتج بنجاح في المنتجات!")),
                          );

                          // إرسال البيانات إلى unscanned-products
                          await ApiService.sendProductData(productName, productPosition, qrstr, endpoint: 'unscanned-products');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("تم حفظ المنتج بنجاح في المنتجات غير الممسوحة!")),
                          );
                        } catch (e) {
                          String errorMessage = e.toString().contains('المنتج موجود بالفعل')
                              ? "هذا المنتج موجود بالفعل!"
                              : "حدث خطأ أثناء الحفظ.";
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage)),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Generate QR', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateQrString() {
    qrstr = jsonEncode({
      "productName": productName.isNotEmpty ? productName : "Unknown",
      "productPosition": productPosition.isNotEmpty ? productPosition : "Unknown",
    });
  }

  Widget _buildTextField(String hintText, Function(String) onChanged) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
