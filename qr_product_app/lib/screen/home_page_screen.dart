import 'package:flutter/material.dart';
import 'package:tsec/screen/scanqr.dart';
import 'UnscannedProductsPage.dart';
import 'qr_scanner_page.dart';
import 'positions_page.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> scannedProducts = []; // قائمة لتتبع المنتجات الممسوحة

  void updateProductStatus(String productId) {
    print('Product with ID $productId has been scanned and updated.');

    setState(() {
      scannedProducts.add(productId);
    });
  }

  void resetProductStatus(String productId) {
    setState(() {
      scannedProducts.remove(productId);
    });
  }

  void deleteUnscannedProduct(String productId) {
    setState(() {
      scannedProducts.remove(productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.red.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.qr_code_scanner,
                size: 100,
                color: Colors.amber,
              ),
              const SizedBox(height: 20),
              const Text(
                'الترك للسلامة العامة والاستشارات',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.qr_code, size: 20, color: Colors.red),
                label: const Text('Create QR Code'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => CreateScreen()));
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt, size: 20, color: Colors.red),
                label: const Text('Read QR Code'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => QRScannerPage(
                    onProductScanned: updateProductStatus,
                    onProductDeleted: deleteUnscannedProduct, // Pass the delete function
                  )));
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.location_on, size: 20, color: Colors.red),
                label: const Text('Position Screen'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => PositionPage()));
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.list, size: 20, color: Colors.red),
                label: const Text('Unscanned Products'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => UnscannedProductsPage(
                    onProductDeleted: deleteUnscannedProduct,
                  )));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
