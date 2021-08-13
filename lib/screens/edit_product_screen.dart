// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_app/providers/product.dart';
// import 'package:shop_app/providers/products.dart';

// class EditProductScreen extends StatefulWidget {
//   static const routeName = '/edit-product';
//   @override
//   _EditProductScreenState createState() => _EditProductScreenState();
// }

// class _EditProductScreenState extends State<EditProductScreen> {
//   final _priceFocusNode = FocusNode();
//   final _descriptionFocusNode = FocusNode();
//   final _imageUrlController = TextEditingController();
//   final _imageUrlFocusNode = FocusNode();
//   final _form = GlobalKey<FormState>();
//   var _editedProduct = Product(
//     id: null,
//     description: "",
//     price: 0.0,
//     imageUrl: "",
//     title: "",
//   );
//   var _isInit = true;
//   var _isLoading = false;
//   var _initValue = {
//     'description': "",
//     'price': "",
//     'imageUrl': "",
//     'title': "",
//   };
//   void initState() {
//     _imageUrlFocusNode.addListener(_updateImage);
//     super.initState();
//   }

//   //this function is used when we want to already existing data
//   //Instead of making new screen we are loading the data onto this old screen and then editing it
//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       final productId = ModalRoute.of(context).settings.arguments as String;
//       if (productId != null) {
//         _editedProduct =
//             Provider.of<Products>(context, listen: false).findById(productId);
//         _initValue = {
//           'description': _editedProduct.description,
//           'price': _editedProduct.price.toString(),
//           //'imageUrl': _editedProduct.imageUrl,
//           'title': _editedProduct.title,
//           'imageUrl': "",
//         };
//         _imageUrlController.text = _editedProduct.imageUrl;
//       }
//     }

//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   void dispose() {
//     _imageUrlFocusNode.removeListener(_updateImage);
//     _priceFocusNode.dispose();
//     _descriptionFocusNode.dispose();
//     _imageUrlController.dispose();
//     _imageUrlFocusNode.dispose();
//     super.dispose();
//   }

//   void _updateImage() {
//     if (!_imageUrlFocusNode.hasFocus) {
//       setState(() {});
//     }
//   }

//   Future<void> _saveForm() async {
//     final isValid = _form.currentState.validate();
//     if (!isValid) {
//       return;
//     }
//     _form.currentState.save();
//     setState(() {
//       _isLoading = true;
//     });
//     if (_editedProduct.id != null) {
//       await Provider.of<Products>(context, listen: false)
//           .updateProducts(_editedProduct.id, _editedProduct);
//     } else {
//       try {
//         await Provider.of<Products>(context, listen: false)
//             .addProducts(_editedProduct);
//       } catch (error) {
//         await showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: Text('An error occurred!'),
//             content: Text('Something went wrong.'),
//             actions: <Widget>[
//               ElevatedButton(
//                 child: Text('Okay'),
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//               )
//             ],
//           ),
//         );
//       }
//       // } finally {
//       //   setState(() {
//       //     _isLoading = false;
//       //   });
//       //   Navigator.of(context).pop();
//       // }
//     }
//     setState(() {
//       _isLoading = false;
//     });
//     Navigator.of(context).pop();
//     // Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Product"),
//       ),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _form,
//                 child: ListView(
//                   children: <Widget>[
//                     TextFormField(
//                       initialValue: _initValue['title'],
//                       decoration: InputDecoration(labelText: "Title"),
//                       textInputAction: TextInputAction.next,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context).requestFocus(_priceFocusNode);
//                       },
//                       onSaved: (newValue) {
//                         _editedProduct = Product(
//                           id: _editedProduct.id,
//                           isFavorite: _editedProduct.isFavorite,
//                           description: _editedProduct.description,
//                           price: _editedProduct.price,
//                           imageUrl: _editedProduct.imageUrl,
//                           title: newValue,
//                         );
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return "Please Enter a title";
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       initialValue: _initValue['price'],
//                       decoration: InputDecoration(labelText: "Price"),
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.number,
//                       focusNode: _priceFocusNode,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context)
//                             .requestFocus(_descriptionFocusNode);
//                       },
//                       onSaved: (newValue) {
//                         _editedProduct = Product(
//                           id: _editedProduct.id,
//                           isFavorite: _editedProduct.isFavorite,
//                           description: _editedProduct.description,
//                           price: double.parse(newValue),
//                           imageUrl: _editedProduct.imageUrl,
//                           title: _editedProduct.title,
//                         );
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return "Please Enter a price";
//                         }
//                         if (double.tryParse(value) == null) {
//                           return "Please enter a valid number";
//                         }
//                         if (double.parse(value) <= 0) {
//                           return "Please enter price greater than 0";
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       initialValue: _initValue['description'],
//                       decoration: InputDecoration(labelText: "Description"),
//                       maxLines: 3,
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.multiline,
//                       focusNode: _descriptionFocusNode,
//                       onSaved: (newValue) {
//                         _editedProduct = Product(
//                           id: _editedProduct.id,
//                           isFavorite: _editedProduct.isFavorite,
//                           description: newValue,
//                           price: _editedProduct.price,
//                           imageUrl: _editedProduct.imageUrl,
//                           title: _editedProduct.title,
//                         );
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return "Please Enter a Description";
//                         }
//                         if (value.length < 10) {
//                           return "Description too short";
//                         }
//                         return null;
//                       },
//                     ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: <Widget>[
//                         Container(
//                           width: 100,
//                           height: 100,
//                           margin: EdgeInsets.only(
//                             top: 8,
//                             right: 10,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               width: 1,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           child: _imageUrlController.text.isEmpty
//                               ? Icon(Icons.image)
//                               : FittedBox(
//                                   child: Image.network(
//                                     _imageUrlController.text,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                         ),
//                         Expanded(
//                           child: TextFormField(
//                             //this line would through error because in this we have used a controller, hence we have to give the controller the initial value
//                             //initialValue: _initValue['imageUrl'],
//                             decoration: InputDecoration(labelText: "Image URL"),
//                             textInputAction: TextInputAction.done,
//                             keyboardType: TextInputType.url,
//                             controller: _imageUrlController,
//                             focusNode: _imageUrlFocusNode,
//                             onFieldSubmitted: (_) {
//                               _saveForm();
//                             },
//                             onSaved: (newValue) {
//                               _editedProduct = Product(
//                                 id: _editedProduct.id,
//                                 isFavorite: _editedProduct.isFavorite,
//                                 description: _editedProduct.description,
//                                 price: _editedProduct.price,
//                                 imageUrl: newValue,
//                                 title: _editedProduct.title,
//                               );
//                             },
//                             validator: (value) {
//                               if (value.isEmpty) {
//                                 return "Please Enter a Url";
//                               }
//                               // if (!value.startsWith("http") ||
//                               //     !value.startsWith("https")) {
//                               //   return "Enter Valid Url";
//                               // }
//                               // if (!value.endsWith(".png") ||
//                               //     !value.endsWith(".jpg") ||
//                               //     !value.endsWith(".jpeg")) {
//                               //   return "Enter Valid Url";
//                               // }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       margin: EdgeInsets.all(20),
//                       padding: EdgeInsets.all(20),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           _saveForm();
//                         },
//                         child: Text(
//                           "Save",
//                           style: TextStyle(fontSize: 20),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
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
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProducts(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: value,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: double.parse(value),
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
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
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              // if (!value.startsWith('http') &&
                              //     !value.startsWith('https')) {
                              //   return 'Please enter a valid URL.';
                              // }
                              // if (!value.endsWith('.png') &&
                              //     !value.endsWith('.jpg') &&
                              //     !value.endsWith('.jpeg')) {
                              //   return 'Please enter a valid image URL.';
                              // }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value,
                                id: _editedProduct.id,
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
