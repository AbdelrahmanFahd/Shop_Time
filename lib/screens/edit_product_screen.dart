import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Providers/product.dart';
import '../Providers/Products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = '/edit';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct =
      Product(id: null, title: '', description: '', imageURL: '', price: 0.0);
  var _initValues = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': '',
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId != '100') {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title.toString(),
          'description': _editedProduct.description.toString(),
          // 'imageUrl': _editedProduct.imageURL.toString(),
          'price': _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageURL.toString();
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https'))) return;
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) return;

    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id.toString(), _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred'),
            content: Text('Something went wrong'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okay'))
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const _accentColor = Colors.deepPurpleAccent;
    const _textColor = Colors.deepPurple;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurpleAccent,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 3.5,
                    ),
                    TextFormField(
                      initialValue: _initValues['title'],
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Please enter a title';
                        else
                          return null;
                      },
                      decoration: decorationStyle(
                        'Title',
                        _accentColor,
                        _textColor,
                        Icons.edit,
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: value,
                          description: _editedProduct.description,
                          imageURL: _editedProduct.imageURL,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      focusNode: _priceFocusNode,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null)
                          return 'Please Enter a valid number';
                        if (double.parse(value.toString()) <= 0.0)
                          return 'Please Enter a Number Greater than Zero.';
                        else
                          return null;
                      },
                      decoration: decorationStyle(
                        'Price',
                        _accentColor,
                        _textColor,
                        Icons.attach_money,
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imageURL: _editedProduct.imageURL,
                          isFavorite: _editedProduct.isFavorite,
                          price: double.parse(value.toString()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter a Description';
                        if (value.length < 10)
                          return 'Should at least 10 characters long.';
                        else
                          return null;
                      },
                      decoration: decorationStyle(
                        'Description',
                        _accentColor,
                        _textColor,
                        Icons.description_outlined,
                      ),
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value,
                          imageURL: _editedProduct.imageURL,
                          isFavorite: _editedProduct.isFavorite,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Center(
                                  child: Text(
                                    'Enter an Image URL',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _textColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: _initValues['imageUrl'],
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            decoration: decorationStyle('Image URL',
                                _accentColor, _textColor, Icons.image),
                            controller: _imageUrlController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please enter am Image URl.';
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https') &&
                                  !value.startsWith('data'))
                                return 'Please enter a valid URL.';
                              return null;
                            },
                            focusNode: _imageUrlFocusNode,
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                imageURL: value,
                                price: _editedProduct.price,
                                isFavorite: _editedProduct.isFavorite,
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

InputDecoration decorationStyle(
  String textField,
  Color _accentColor,
  Color _textColor,
  IconData icons,
) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      gapPadding: 1.0,
      borderSide: BorderSide(color: _accentColor),
      borderRadius: BorderRadius.circular(10),
    ),
    labelText: textField,
    labelStyle: TextStyle(fontSize: 18.0, color: _textColor),
    icon: Icon(
      icons,
      color: _accentColor,
    ),
    border: OutlineInputBorder(
      gapPadding: 1.0,
      borderRadius: BorderRadius.circular(25),
    ),
  );
}
