import 'package:flutter/material.dart';
import '../api_service.dart';
import 'package:barcode_widget/barcode_widget.dart';

class UnscannedProductsPage extends StatefulWidget {
  final Function(String) onProductDeleted;

  UnscannedProductsPage({required this.onProductDeleted});

  @override
  _UnscannedProductsPageState createState() => _UnscannedProductsPageState();
}

class _UnscannedProductsPageState extends State<UnscannedProductsPage> {
  List<Map<String, dynamic>> unscannedProducts = []; // قائمة المنتجات غير الممسوحة

  @override
  void initState() {
    super.initState();
    fetchUnscannedProducts();
  }

  void fetchUnscannedProducts() async {
    try {
      List<Map<String, dynamic>> fetchedProducts = await ApiService.fetchUnscannedProducts();
      setState(() {
        unscannedProducts = fetchedProducts; // تخزين البيانات المسترجعة
      });
    } catch (e) {
      print('فشل في جلب المنتجات غير الممسوحة: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تحميل المنتجات غير الممسوحة.')),
      );
    }
  }

  void deleteUnscannedProduct(String productId) async {
    try {
      final success = await ApiService.delete_unscannedProduct(productId);
      if (success) {
        setState(() {
          unscannedProducts.removeWhere((product) => product['_id'] == productId);
        });
        widget.onProductDeleted(productId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حذف المنتج غير الممسوح بنجاح!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في حذف المنتج غير الممسوح.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء حذف المنتج غير الممسوح: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المنتجات غير الممسوحة'),
        backgroundColor: Colors.black,
      ),
      body: unscannedProducts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: unscannedProducts.length,
          itemBuilder: (context, index) {
            final product = unscannedProducts[index];
            return Card(
              color: Colors.black,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'الموقع: ${product['position']}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    BarcodeWidget(
                      data: product['qr'],
                      barcode: Barcode.qrCode(),
                      color: Colors.white,
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => deleteUnscannedProduct(product['_id']),
                      child: const Text('حذف المنتج'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
