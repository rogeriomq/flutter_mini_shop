import 'package:flutter/material.dart';
import 'package:mini_shop/exceptions/http_exception.dart';
import 'package:mini_shop/models/product.dart';
import 'package:mini_shop/models/product_list.dart';
import 'package:mini_shop/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMsg = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100,
        child: Row(children: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AppRoutes.PRODUCT_FORM, arguments: product);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (cxt) => AlertDialog(
                  title: Row(
                    children: const [
                      Icon(Icons.warning_amber),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Tem certeza?'),
                      ),
                    ],
                  ),
                  content: const Text('Quer remover o produto?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(cxt).pop(false),
                        child: const Text('Não')),
                    TextButton(
                        onPressed: () => Navigator.of(cxt).pop(true),
                        child: const Text('Sim')),
                  ],
                ),
              ).then((value) async {
                if (value ?? false) {
                  try {
                    Provider.of<ProductList>(context, listen: false)
                        .removeProduct(product);
                  } on HttpException catch (e) {
                    debugPrint(e.toString());
                    scaffoldMsg.showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                }
              });
            },
          )
        ]),
      ),
    );
  }
}
