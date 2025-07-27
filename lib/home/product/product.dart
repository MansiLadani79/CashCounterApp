import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_controller.dart';

class ProductPage extends GetView<ProductController> {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Product'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => controller.showAddProductDialog(context),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Row
          Container(
            padding: EdgeInsets.only(left: 30, right: 52, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Product Name',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Price',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(width: 40), // Space for delete button
              ],
            ),
          ),
          // Product List
          Expanded(
            child: Obx(() {
              if (controller.products.isEmpty) {
                return Center(child: Text('No products available.'));
              }

              return ListView.builder(
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  final product = controller.products[index];
                  return InkWell(
                    onTap: () => controller.showAddProductDialog(
                      context,
                      product: product,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[100]!),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                product.productName,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '₹${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red[300],
                              ),
                              onPressed: () =>
                                  controller.showDeleteConfirmation(
                                context,
                                product,
                              ),
                              padding: EdgeInsets.only(left: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
