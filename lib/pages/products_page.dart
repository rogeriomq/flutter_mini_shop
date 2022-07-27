import 'package:flutter/material.dart';
import 'package:mini_shop/components/app_drawer.dart';
import 'package:mini_shop/components/product_item.dart';
import 'package:mini_shop/models/product_list.dart';
import 'package:mini_shop/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_FORM,
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.itemsCount,
          itemBuilder: (context, index) => Column(
            children: [
              ProductItem(
                products.items[index],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
