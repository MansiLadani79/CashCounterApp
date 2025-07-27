class FirebaseCollections {
  static const String products = 'products';
  static const String customers = 'customers';
}

class ProductKeys {
  static const String pid = 'pid';
  static const String productName = 'productName';
  static const String price = 'price';
}

class FirebaseServices {
  static String getProductCollection() => FirebaseCollections.products;

  static Map<String, dynamic> createProductMap({
    required String pid,
    required String productName,
    required double price,
  }) {
    return {
      ProductKeys.pid: pid,
      ProductKeys.productName: productName,
      ProductKeys.price: price,
    };
  }
}
