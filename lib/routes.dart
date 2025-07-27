import 'package:cash_counter_app/home/home_binding.dart';
import 'package:cash_counter_app/home/home_page.dart';
import 'package:get/get.dart';
import 'package:cash_counter_app/home/product/product.dart';
import 'package:cash_counter_app/home/product/product_binding.dart';

class AppRoutes {
  static const String initialRoutes = "/";
  static const String home = "/home";
  static const String product = "/product";

  static List<GetPage<dynamic>> get generatedRoutes => [
    GetPage(name: home, page: () => const HomePage(), binding: HomeBinding()),
    GetPage(
      name: product,
      page: () => const ProductPage(),
      binding: ProductBinding(),
    ),
  ];
}
