import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mini_shop/models/cart.dart';
import 'package:mini_shop/models/order.dart';

class OrderList with ChangeNotifier {
  final List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void addOrder(Cart cart) {
    if (cart.itemsCount == 0) return;

    _items.insert(
      0,
      Order(
        id: Random().nextDouble().toString(),
        total: cart.totalAmount,
        date: DateTime.now(),
        products: cart.items.values.toList(),
      ),
    );

    notifyListeners();
  }
}
