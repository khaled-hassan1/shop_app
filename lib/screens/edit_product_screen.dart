import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const route = '/edit-products';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlContoller = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isInit = true;
  var _editProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  Map<String, String> _initualValue = {
    'title': '',
    'price': '',
    'imageUrl': '',
    'description': '',
  };
  bool _isLoading = false;

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initualValue = {
          'title': _editProduct.title,
          'price': _editProduct.price.toString(),
          // 'imageUrl': _editProduct.imageUrl,
          'imageUrl': '',
          'description': _editProduct.description,
        };
        _imageUrlContoller.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlContoller.dispose();
    _imageFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id!, _editProduct);
      // debugPrint("here id: ${_editProduct.id}");
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addItem(_editProduct);
      } catch (e) {
        // ignore: use_build_context_synchronously
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('An error accourd'),
            content: const Text('Something went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      }
      //finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    TextFormField(
                      initialValue: _initualValue['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onSaved: (newValue) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: newValue!,
                          description: _editProduct.description,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initualValue['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          description: _editProduct.description,
                          price: double.parse(newValue!),
                          imageUrl: _editProduct.imageUrl,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price';
                        }

                        double? parsedPrice = double.tryParse(value);

                        if (parsedPrice == null) {
                          return 'Please enter a valid price';
                        }

                        if (parsedPrice <= 0) {
                          return 'Please enter a price greater than zero';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initualValue['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (newValue) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          description: newValue!,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the description';
                        }
                        return null;
                      },
                    ),
                    Container(
                      height: 150,
                      width: 50,
                      margin:
                          const EdgeInsets.only(top: 15, right: 100, left: 100),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      child: _imageUrlContoller.text.isEmpty
                          ? const Center(child: Text('Waiting to enter url'))
                          : Image.network(
                              _imageUrlContoller.text,
                              fit: BoxFit.cover,
                            ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Image Url',
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      controller: _imageUrlContoller,
                      focusNode: _imageFocusNode,
                      onSaved: (newValue) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          description: _editProduct.description,
                          price: _editProduct.price,
                          imageUrl: newValue!,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Image Url';
                        }
                        if (!value.startsWith('http') ||
                            !value.startsWith('https')) {
                          return 'Please enter a valid Url';
                        }
                        if (!value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg') &&
                            !value.endsWith('.png')) {
                          return 'Please enter a valid image';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Submit'),
        icon: const Icon(Icons.save),
        onPressed: _saveForm,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
