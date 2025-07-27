import 'package:cash_counter_app/theme/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../component/common_text_field.dart';
import '../../services/firebase_services.dart';
import 'product_model.dart';

class ProductController extends GetxController {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Product> products = <Product>[].obs;
  RxString editingProductId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() {
    _firestore.collection(FirebaseCollections.products).snapshots().listen((
      snapshot,
    ) {
      products.value = snapshot.docs
          .map(
            (doc) => Product.fromMap({...doc.data(), ProductKeys.pid: doc.id}),
          )
          .toList();
    });
  }

  void showAddProductDialog(BuildContext context, {Product? product}) {
    // Clear controllers
    nameController.clear();
    priceController.clear();

    // If editing, populate the fields
    if (product != null) {
      nameController.text = product.productName;
      priceController.text = product.price.toString();
      editingProductId.value = product.pid;
    } else {
      editingProductId.value = '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                Center(
                  child: Text(
                    product != null ? 'Edit Product' : 'Add Product',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                CommonTextFieldWidget(
                  controller: nameController,
                  label: 'Product Name',
                  icon: Icons.shopping_bag,
                ),
                SizedBox(height: 8),
                CommonTextFieldWidget(
                  controller: priceController,
                  label: 'Price',
                  icon: Icons.currency_rupee,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        saveProduct();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        product != null ? 'Update' : 'Save',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void saveProduct() async {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.trim());

    if (name.isEmpty || price == null) {
      Get.snackbar('Error', 'Please enter valid product name and price');
      return;
    }

    try {
      if (editingProductId.value.isEmpty) {
        // Add new product
        final docRef =
            _firestore.collection(FirebaseCollections.products).doc();
        final product = Product(
          pid: docRef.id,
          productName: name,
          price: price,
        );
        await docRef.set(product.toMap());
        Get.snackbar('Success', 'Product added successfully');
      } else {
        // Update existing product
        final product = Product(
          pid: editingProductId.value,
          productName: name,
          price: price,
        );
        await _firestore
            .collection(FirebaseCollections.products)
            .doc(editingProductId.value)
            .update(product.toMap());
        Get.snackbar('Success', 'Product updated successfully');
      }

      // Clear fields after save
      nameController.clear();
      priceController.clear();
      editingProductId.value = '';
    } catch (e) {
      Get.snackbar('Error', 'Failed to save product: ${e.toString()}');
    }
  }

  void showDeleteConfirmation(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text(
            'Are you sure you want to delete "${product.productName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: primaryColor)),
            ),
            TextButton(
              onPressed: () {
                deleteProduct(product.pid);
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.products)
          .doc(productId)
          .delete();
      Get.snackbar('Success', 'Product deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
