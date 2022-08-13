
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/product.dart';
import 'package:shopapp/provider/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/editProductScreen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '0',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    
  };
  var _isInit = true;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;

        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl' : '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _form.currentState!.save();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    // ignore: unnecessary_null_comparison
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Product",
        ),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValue['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please provide a value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: value!,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValue['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
             
                onSaved: (value) {
                  _editedProduct = Product(
                    id: '',
                    title: _editedProduct.title,
                    price: double.parse(value!),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValue['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,
               
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value!,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? Text("Enter a url")
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                 
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value!,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
