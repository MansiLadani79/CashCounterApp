import '../../services/firebase_services.dart';

class Product {
  final String pid;
  final String productName;
  final double price;

  Product({required this.pid, required this.productName, required this.price});

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      pid: map[ProductKeys.pid] ?? '',
      productName: map[ProductKeys.productName] ?? '',
      price: (map[ProductKeys.price] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return FirebaseServices.createProductMap(
      pid: pid,
      productName: productName,
      price: price,
    );
  }
}
