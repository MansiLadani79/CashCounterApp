import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../component/common_text_field.dart';
import 'product/product_model.dart';
import 'package:cash_counter_app/theme/color/colors.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              // Table with perfectly aligned header and data columns
              Expanded(
                child: Obx(() {
                  if (controller.products.isEmpty) {
                    return Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('No products available.....'),
                          SizedBox(width: 4),
                          Text('Add products to get started.'),
                          GestureDetector(
                            onTap: () => Get.toNamed('/product'),
                            child: Icon(
                              Icons.edit,
                              size: 14,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 9,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(3), // Product Name
                            1: FlexColumnWidth(2), // Price
                            2: FlexColumnWidth(2), // Quantity
                            3: FlexColumnWidth(2), // Total
                          },
                          children: [
                            // Header row
                            TableRow(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                color: primaryColor.withOpacity(0.1),
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Product Name',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: primaryColor,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () => Get.toNamed('/product'),
                                          child: Icon(
                                            Icons.edit,
                                            size: 14,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      'Price',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      'Quantity',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      'Total',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Data rows with dividers
                            ...List.generate(controller.products.length, (i) {
                              final product = controller.products[i];
                              controller.productQuantityControllers.putIfAbsent(
                                product.pid,
                                () => TextEditingController(),
                              );
                              controller.productTotals.putIfAbsent(
                                product.pid,
                                () => 0.0.obs,
                              );
                              final quantityController = controller
                                  .productQuantityControllers[product.pid]!;
                              final total =
                                  controller.productTotals[product.pid]!;
                              quantityController.removeListener(() {});
                              quantityController.addListener(() {
                                final qty =
                                    int.tryParse(quantityController.text) ?? 0;
                                total.value = product.price * qty;
                                controller.updateTotals();
                              });
                              return [
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        product.productName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: 4,
                                      ),
                                      child: Text(
                                        '₹${product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 4,
                                      ),
                                      child: SizedBox(
                                        width: 50,
                                        child: TextField(
                                          controller: quantityController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: '0',
                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade400,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: 4,
                                      ),
                                      child: Obx(
                                        () => Text(
                                          '₹${total.value.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Divider row except after last data row
                                if (i != controller.products.length - 1)
                                  TableRow(
                                    children: [
                                      for (int j = 0; j < 4; j++)
                                        Container(
                                          height: 1,
                                          color: Colors.grey[300],
                                        ),
                                    ],
                                  ),
                              ];
                            }).expand((rows) => rows).toList(),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),

              Column(
                children: [
                  Obx(() => Text(
                      'Total Amount (RS) : ₹${controller.totalAmount.value}')),
                  Obx(() =>
                      Text('Total items : ${controller.totalNotes.value}')),
                  Obx(() => Text(controller.amountInWords.value)),
                ],
              ),

              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Validate minimum quantity
                        bool hasQuantity = false;
                        for (var product in controller.products) {
                          final quantity = int.tryParse(controller
                                      .productQuantityControllers[product.pid]
                                      ?.text ??
                                  '0') ??
                              0;
                          if (quantity > 0) {
                            hasQuantity = true;
                            break;
                          }
                        }
                        if (!hasQuantity) {
                          Get.snackbar('Error',
                              'Please add at least one item with quantity');
                          return;
                        }

                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SafeArea(
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.picture_as_pdf),
                                    title: const Text('Export as PDF'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      controller.saveAsPdf();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.grid_on),
                                    title: const Text('Export as Excel'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      controller.saveAsExcel();
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.save,
                            size: 16,
                            color: primaryColor,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Save',
                            style: TextStyle(fontSize: 14, color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Validate minimum quantity
                        bool hasQuantity = false;
                        for (var product in controller.products) {
                          final quantity = int.tryParse(controller
                                      .productQuantityControllers[product.pid]
                                      ?.text ??
                                  '0') ??
                              0;
                          if (quantity > 0) {
                            hasQuantity = true;
                            break;
                          }
                        }
                        if (!hasQuantity) {
                          Get.snackbar('Error',
                              'Please add at least one item with quantity');
                          return;
                        }

                        final success = true;
                        if (success) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                child: Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.picture_as_pdf),
                                      title: const Text('Export as PDF'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        controller.shareAsPdf();
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.grid_on),
                                      title: const Text('Export as Excel'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        controller.exportAsExcel();
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Wraps content tightly
                        children: const [
                          Icon(
                            Icons.share,
                            size: 16,
                            color: primaryColor,
                          ), // Icon on the left
                          SizedBox(width: 6), // Spacing between icon and text
                          Text(
                            'Share',
                            style: TextStyle(fontSize: 14, color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: controller.clearAll,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                          100,
                          40,
                        ), // Square shape (width x height)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // Optional: rounded corners
                        ),
                        padding: EdgeInsets.zero, // Remove default padding
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Wraps content tightly
                        children: const [
                          Icon(
                            Icons.clear,
                            size: 16,
                            color: primaryColor,
                          ), // Icon on the left
                          SizedBox(width: 6), // Spacing between icon and text
                          Text(
                            'Clear',
                            style: TextStyle(fontSize: 14, color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController controller,
    String hint, {
    double width = 100,
    Function(String)? onChanged,
    TextInputType keyboardType = TextInputType.number,
  }) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          // Remove this line as it's causing the error
          // controller.updateQuantity(product, value);
        },
        decoration: InputDecoration(
          hintText: '0',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13),
      ),
    );
  }
}
