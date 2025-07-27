import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_services.dart';
import 'product/product_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cash_counter_app/theme/color/colors.dart';


class Item {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController countController = TextEditingController();
  RxInt total = 0.obs;
}

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Product> products = <Product>[].obs;
  static const List<String> _units = [
    '',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
    'fifteen',
    'sixteen',
    'seventeen',
    'eighteen',
    'nineteen',
  ];
  static const List<String> _tens = [
    '',
    '',
    'twenty',
    'thirty',
    'forty',
    'fifty',
    'sixty',
    'seventy',
    'eighty',
    'ninety',
  ];

  // For product list quantity and total
  Map<String, TextEditingController> productQuantityControllers = {};
  Map<String, RxDouble> productTotals = {};

  RxDouble totalAmount = 0.0.obs;
  RxInt totalNotes = 0.obs;
  RxString amountInWords = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void updateQuantity(Product product, String value) {
    final qty = int.tryParse(value) ?? 0;
    final total = (product.price * qty).toDouble();
    productTotals[product.pid]!.value = total;
    _calculateTotals();
  }

  void _calculateTotals() {
    totalAmount.value =
        productTotals.values.fold(0.0, (sum, total) => sum + total.value);
    totalNotes.value =
        productQuantityControllers.values.fold(0, (sum, controller) {
      final count = int.tryParse(controller.text) ?? 0;
      return sum + count;
    });
    amountInWords.value = _convert(totalAmount.value.round());
  }

  String _convert(int n) {
    if (n < 20) return _units[n];
    if (n < 100)
      return '${_tens[n ~/ 10]}${n % 10 == 0 ? '' : ' ${_units[n % 10]}'}';
    if (n < 1000)
      return '${_units[n ~/ 100]} hundred${n % 100 == 0 ? '' : ' and ${_convert(n % 100)}'}';
    if (n < 100000)
      return '${_convert(n ~/ 1000)} thousand${n % 1000 == 0 ? '' : ' ${_convert(n % 1000)}'}';
    return '${_convert(n ~/ 100000)} lakh${n % 100000 == 0 ? '' : ' ${_convert(n % 100000)}'}';
  }

  void clearAll() {
    // Clear all quantity controllers
    for (var controller in productQuantityControllers.values) {
      controller.clear();
    }

    // Reset all totals
    for (var total in productTotals.values) {
      total.value = 0.0;
    }

    // Reset main totals
    totalAmount.value = 0.0;
    totalNotes.value = 0;
    amountInWords.value = '';
  }

  void shareAsPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          // Get products with non-zero quantities
          List<Map<String, dynamic>> purchasedProducts = [];
          for (var product in products) {
            final quantity = int.tryParse(
                    productQuantityControllers[product.pid]?.text ?? '0') ??
                0;
            if (quantity > 0) {
              purchasedProducts.add({
                'productName': product.productName,
                'price': product.price,
                'quantity': quantity,
                'total': product.price * quantity,
              });
            }
          }

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Bill Details', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Product Name', 'Price', 'Quantity', 'Total'],
                data: purchasedProducts.map((product) {
                  return [
                    product['productName'],
                    'RS: ${product['price'].toStringAsFixed(2)}',
                    product['quantity'].toString(),
                    'RS: ${product['total'].toStringAsFixed(2)}',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 20),

              // Total Details
              pw.Text(
                  'Total Amount: RS: ${totalAmount.value.toStringAsFixed(2)}'),
              pw.Text('Total Items: ${totalNotes.value}'),
              pw.Text('Amount in Words: ${amountInWords.value}'),
              pw.SizedBox(height: 10),
            ],
          );
        },
      ),
    );

    final now = DateTime.now();
   String fileName = "CashCounter_${DateTime.now().toIso8601String().replaceAll(":", "-")}.pdf";
   await saveFileWithPicker(await pdf.save(), fileName);
  }

  void exportAsExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Add headers
    sheet.appendRow(['Product Name', 'Price', 'Quantity', 'Total']);

    // Get products with non-zero quantities
    List<Map<String, dynamic>> purchasedProducts = [];
    for (var product in products) {
      final quantity =
          int.tryParse(productQuantityControllers[product.pid]?.text ?? '0') ??
              0;
      if (quantity > 0) {
        purchasedProducts.add({
          'productName': product.productName,
          'price': product.price,
          'quantity': quantity,
          'total': product.price * quantity,
        });
      }
    }

    // Add data rows
    for (var product in purchasedProducts) {
      sheet.appendRow([
        product['productName'],
        '₹${product['price'].toStringAsFixed(2)}',
        product['quantity'].toString(),
        '₹${product['total'].toStringAsFixed(2)}',
      ]);
    }

    // Add totals
    sheet.appendRow(['', '', '', '']); // Ensures a visible blank row
    sheet.appendRow([]); // Additional spacing before product details
    sheet.appendRow(['Total Items', totalNotes.value.toString()]);
    sheet.appendRow(
        ['Total Amount', '₹${totalAmount.value.toStringAsFixed(2)}']);
    sheet.appendRow(['Amount in Words', amountInWords.value]);

    // Save and share
    final excelBytes = excel.encode();
    if (excelBytes != null) {
      final now = DateTime.now();
      String formattedDate =
          '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year.toString().substring(2)} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      await Printing.sharePdf(
        bytes: Uint8List.fromList(excelBytes),
        filename: '$formattedDate.xlsx',
      );
    }
  }

  Future<void> _requestManageExternalStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          Get.snackbar(
            'Permission Required',
            'Please grant "All files access" permission in app settings to save to Downloads folder.',
            snackPosition: SnackPosition.BOTTOM,
          );
          throw Exception('Storage permission not granted');
        }
      }
    }
  }

  // Helper to sanitize file and directory names
  String _sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '').trim();
  }

  Future<void> saveFileWithPicker(Uint8List fileBytes, String fileName) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      selectedDirectory = selectedDirectory.trim();
      final sanitizedFileName = _sanitizeFileName(fileName);
      final file = File('$selectedDirectory/$sanitizedFileName');
      try {
        await file.writeAsBytes(fileBytes);
        Get.snackbar('Success', 'File saved to $selectedDirectory', duration: Duration(seconds: 3));
      } catch (e) {
        Get.dialog(
          AlertDialog(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.folder_off, color: primaryColor, size: 28),
                SizedBox(width: 8),
                Text('Permission Denied', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 21)),
              ],
            ),
            content: RichText(
              text: TextSpan(
                style: TextStyle(color: textColor, fontSize: 16),
                children: [
                  TextSpan(text: 'please select or create new folder in '),
                  TextSpan(text: 'DOWNLOAD', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  TextSpan(text: ' folder'),
                ],
              ),
            ),
            actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.folder_open, color: buttonTextColor),
                  label: Text('Select another folder', style: TextStyle(color: buttonTextColor, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Get.back();
                    saveFileWithPicker(fileBytes, fileName);
                  },
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  child: Text("Don't save", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
    } else {
      Get.snackbar('Cancelled', 'No folder selected', duration: Duration(seconds: 3));
    }
  }

  Future<void> saveFileWithAppStorage(Uint8List fileBytes, String fileName) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/$fileName');
    await file.writeAsBytes(fileBytes);
    Get.snackbar('Success', 'File saved to ${file.path}');
  }

  Future<void> saveAsPdf() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            // Get products with non-zero quantities
            List<Map<String, dynamic>> purchasedProducts = [];
            for (var product in products) {
              final quantity = int.tryParse(
                      productQuantityControllers[product.pid]?.text ?? '0') ??
                  0;
              if (quantity > 0) {
                purchasedProducts.add({
                  'productName': product.productName,
                  'price': product.price,
                  'quantity': quantity,
                  'total': product.price * quantity,
                });
              }
            }

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Bill Details', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ['Product Name', 'Price', 'Quantity', 'Total'],
                  data: purchasedProducts.map((product) {
                    return [
                      product['productName'],
                      'RS: ${product['price'].toStringAsFixed(2)}',
                      product['quantity'].toString(),
                      'RS: ${product['total'].toStringAsFixed(2)}',
                    ];
                  }).toList(),
                ),
                pw.SizedBox(height: 20),

                // Total Details
                pw.Text(
                    'Total Amount: RS: ${totalAmount.value.toStringAsFixed(2)}'),
                pw.Text('Total Items: ${totalNotes.value}'),
                pw.Text('Amount in Words: ${amountInWords.value}'),
                pw.SizedBox(height: 10),
              ],
            );
          },
        ),
      );

      final now = DateTime.now();
      String formattedDate =
          '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year.toString().substring(2)} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      await saveFileWithPicker(await pdf.save(), '$formattedDate.pdf');
    } catch (e) {
      print('Error saving PDF: $e');
      Get.snackbar(
        'Error',
        'Failed to save PDF: ${e.toString()}',
        duration: Duration(seconds: 3),
      );
    }
  }

  // Update all usages to use saveFileWithPicker and sanitize file names
  Future<void> saveAsExcel() async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];
      // Add headers
      sheet.appendRow(['Product Name', 'Price', 'Quantity', 'Total']);
      // Get products with non-zero quantities
      List<Map<String, dynamic>> purchasedProducts = [];
      for (var product in products) {
        final quantity = int.tryParse(
                productQuantityControllers[product.pid]?.text ?? '0') ??
            0;
        if (quantity > 0) {
          purchasedProducts.add({
            'productName': product.productName,
            'price': product.price,
            'quantity': quantity,
            'total': product.price * quantity,
          });
        }
      }
      // Add data rows
      for (var product in purchasedProducts) {
        sheet.appendRow([
          product['productName'],
          '₹${product['price'].toStringAsFixed(2)}',
          product['quantity'].toString(),
          '₹${product['total'].toStringAsFixed(2)}',
        ]);
      }
      // Add totals
      sheet.appendRow(['', '', '', '']); // Ensures a visible blank row
      sheet.appendRow([]); // Additional spacing before product details
      sheet.appendRow(['Total Items', totalNotes.value.toString()]);
      sheet.appendRow(
          ['Total Amount', '₹${totalAmount.value.toStringAsFixed(2)}']);
      sheet.appendRow(['Amount in Words', amountInWords.value]);
      final now = DateTime.now();
      String formattedDate =
          '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year.toString().substring(2)}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}';
      await saveFileWithPicker(Uint8List.fromList(excel.encode()!), '$formattedDate.xlsx');
    } catch (e) {
      print('Error saving Excel: $e');
      Get.snackbar(
        'Error',
        'Failed to save Excel: ${e.toString()}',
        duration: Duration(seconds: 3),
      );
    }
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

  void updateTotals() {
    totalAmount.value =
        productTotals.values.fold(0.0, (sum, total) => sum + total.value);
    totalNotes.value =
        productQuantityControllers.values.fold(0, (sum, controller) {
      return sum + (int.tryParse(controller.text) ?? 0);
    });
    amountInWords.value = _convert(totalAmount.value.round());
  }

  bool validateAndSaveData() {
    if (totalNotes.value <= 0) {
      Get.snackbar('Error', 'Please add items');
      return false;
    }
    return true;
  }
}
