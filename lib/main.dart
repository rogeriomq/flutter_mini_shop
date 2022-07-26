import 'package:flutter/material.dart';
import 'package:mini_shop/models/cart.dart';
import 'package:mini_shop/models/order_list.dart';
import 'package:mini_shop/models/product_list.dart';
import 'package:mini_shop/pages/cart_page.dart';
import 'package:mini_shop/pages/orders_page.dart';
import 'package:mini_shop/pages/product_detail_page.dart';
import 'package:mini_shop/pages/products_overview_page.dart';
import 'package:mini_shop/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
        title: 'Mini Shop',
        theme: ThemeData(
          fontFamily: 'Lato',
          primaryColor: Colors.purple,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.purple,
          ).copyWith(
            secondary: Colors.deepOrange,
          ),
        ),
        // home: ProductsOverviewPage(),
        routes: {
          AppRoutes.HOME: (ctx) => const ProductsOverviewPage(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailPage(),
          AppRoutes.CART: (ctx) => const CartPage(),
          AppRoutes.ORDERS: (ctx) => const OrdersPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
