import 'package:flutter/material.dart';
import '../api_service.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'UnscannedProductsPage.dart';

class PositionPage extends StatefulWidget {
  @override
  _PositionPageState createState() => _PositionPageState();
}

class _PositionPageState extends State<PositionPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<Map<String, dynamic>>> categorizedProducts = {
    'Top': [],
    'Users': [],
    'Videos': [],
    'Sounds': [],
    'Top1': [],
    'Users1': [],
    'Videos1': [],
    'Sounds1': [],
  };

  List<String> scannedProducts = []; // قائمة لتتبع المنتجات الممسوحة

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    fetchProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void fetchProducts() async {
    List<Map<String, dynamic>> fetchedProducts = await ApiService.fetchProducts();
    for (var product in fetchedProducts) {
      if (categorizedProducts.containsKey(product['position'])) {
        categorizedProducts[product['position']]!.add(product);
      }
    }
    setState(() {});
  }

  void deleteProductFromPosition(String productId, String position) async {
    try {
      final success = await ApiService.deleteProduct(productId); // الاتصال بالخادم
      if (success) {
        setState(() {
          categorizedProducts[position]?.removeWhere((product) => product['_id'] == productId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حذف المنتج من $position بنجاح!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في حذف المنتج.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء الحذف: $error')),
      );
    }
  }

  void resetAllProducts() async {
    try {
      await ApiService.resetProductScanStatus();
      fetchProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إعادة تعيين جميع المنتجات إلى غير مسحوبة!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في إعادة تعيين حالة المنتجات.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Position'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.warning),
            onPressed: () async {
              // تنقل إلى صفحة UnscannedProductsPage
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => UnscannedProductsPage(
                    onProductDeleted: (productId) {
                      // لا تقم بإزالة المنتج من قائمة المنتجات الممسوحة هنا
                      // فقط قم بالتعامل مع المتغيرات المستخدمة في UnscannedProductsPage
                    }
                )),
              );
              // عند العودة، يمكنك إعادة تحميل المنتجات إذا كانت هناك حاجة
              fetchProducts();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.red,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelColor: Colors.white70,
          labelColor: Colors.red,
          tabs: const [
            Tab(text: 'Top'),
            Tab(text: 'Users'),
            Tab(text: 'Videos'),
            Tab(text: 'Sounds'),
            Tab(text: 'Top1'),
            Tab(text: 'Users1'),
            Tab(text: 'Videos1'),
            Tab(text: 'Sounds1'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: resetAllProducts,
              child: Text('Reset All Products to Unscanned'),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: ['Top', 'Users', 'Videos', 'Sounds', 'Top1', 'Users1', 'Videos1', 'Sounds1']
                    .map((category) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(2.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemCount: categorizedProducts[category]?.length ?? 0,
                          itemBuilder: (context, index) {
                            final product = categorizedProducts[category]![index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Card(
                                color: Colors.black,
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        product['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      BarcodeWidget(
                                        data: product['qr'],
                                        barcode: Barcode.qrCode(),
                                        color: Colors.white,
                                        height: 100,
                                        width: 100,
                                      ),
                                      Text(
                                        scannedProducts.contains(product['_id']) ? '✅ تم المسح بنجاح' : '❌ لم يتم المسح',
                                        style: TextStyle(
                                          color: scannedProducts.contains(product['_id']) ? Colors.green : Colors.red,
                                          fontSize: 13,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.delete, size: 10),
                                        label: const Text('حذف المنتج'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.redAccent,
                                          onPrimary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () => deleteProductFromPosition(product['_id'], category),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
