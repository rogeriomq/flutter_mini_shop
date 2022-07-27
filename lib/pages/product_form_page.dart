import 'package:flutter/material.dart';
import 'package:mini_shop/models/product.dart';
import 'package:mini_shop/models/product_list.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);
  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(_updateImage);
    _imageUrlFocus.dispose();
    _imageUrlController.dispose();
  }

  void _updateImage() {
    debugPrint('_updateImage called!');
    setState(() {});
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    _formKey.currentState?.save();

    Provider.of<ProductList>(
      context,
      listen: false,
    ).saveProductFromData(_formData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Product'),
        actions: [
          IconButton(
            onPressed: () => _submitForm(),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['name']?.toString(),
                decoration: const InputDecoration(labelText: 'Name:'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                validator: (value) {
                  final name = value ?? '';
                  if (name.trim().isEmpty) return 'Name is required!';
                  if (name.trim().length < 2) {
                    return 'Name needs at least 3 letters.';
                  }
                  return null;
                },
                onSaved: (newValue) => _formData['name'] = newValue ?? '',
              ),
              TextFormField(
                initialValue: _formData['price']?.toString(),
                decoration: const InputDecoration(labelText: 'Price:'),
                textInputAction: TextInputAction.next,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                focusNode: _priceFocus,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (newValue) {
                  _formData['price'] = double.parse(newValue ?? '0.0');
                },
                validator: (value) {
                  final priceString = value ?? '';
                  final price = double.tryParse(priceString) ?? -1;

                  if (price <= 0) return 'Please enter a valid price!';

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['description']?.toString(),
                decoration: const InputDecoration(labelText: 'Description:'),
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocus,
                maxLines: 3,
                textInputAction: TextInputAction.newline,
                onSaved: (newValue) =>
                    _formData['description'] = newValue ?? '',
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Image URL:'),
                      keyboardType: TextInputType.url,
                      focusNode: _imageUrlFocus,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onSaved: (newValue) =>
                          _formData['imageUrl'] = newValue ?? '',
                      onFieldSubmitted: (_) {
                        _submitForm();
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? const Text('Image Preview!')
                        : FittedBox(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            child: Image.network(_imageUrlController.text),
                          ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
