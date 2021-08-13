import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//This class provides data globally to all the screens
class Products with ChangeNotifier {
  List<Product> _items = [
    //   Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageUrl:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   ),
    //   Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   ),
    //   Product(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageUrl:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   ),
    //   Product(
    //     id: 'p4',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ),
  ];

  //var _showFavoritesOnly = false;

  final String authToken;
  final String userId;
  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((productItem) => productItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
  Future<void> fetchAndSetProducts([bool filter = false]) async {
    final filterByUser = filter ? "orderBy='creatorId'&equalTo='$userId'" : "";
    var url =
        "https://shop-app-5b73f-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterByUser";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      final favouriteResponse = await http.get(
          "https://shop-app-5b73f-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken");
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            title: prodData['title'],
            isFavorite:
                favouriteData == null ? false : favouriteData(prodId) ?? false,
          ),
        );
      });
      _items = loadedProducts;
      print(userId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProducts(Product p) async {
    final url =
        "https://shop-app-5b73f-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    //return http
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "title": p.title,
            "description": p.description,
            "imageUrl": p.imageUrl,
            "price": p.price,
            "creatorId": userId,
            //"isFavourite": p.isFavorite,
          },
        ),
      );
      final newProduct = Product(
        //id: DateTime.now().toString(),
        id: json.decode(response.body)['name'],
        description: p.description,
        price: p.price,
        imageUrl: p.imageUrl,
        title: p.title,
      );

      _items.add(newProduct);
      notifyListeners(); // This would notify every function that new data is available for use
    } catch (error) {
      throw error;
    }

    //.catchError((error) {
    //   print(error);
    //   throw error;
    // });
  }

  Future<void> updateProducts(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);

    if (prodIndex >= 0) {
      final url =
          "https://shop-app-5b73f-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";

      await http.patch(url,
          body: json.encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "price": newProduct.price,
            "imageUrl": newProduct.imageUrl,
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

//optimistic updating
  // void deleteProduct(String id) {
  //   final url =
  //       "https://shop-app-5b73f-default-rtdb.firebaseio.com/products/$id.json";
  //   final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
  //   var existingProduct = _items[existingProductIndex];
  //   _items.removeAt(existingProductIndex);

  //   http.delete(url).then((response) {
  //     if (response.statusCode >= 400) {
  //       throw HttpException("Could not delete");
  //     }
  //     existingProduct = null;
  //   }).catchError((_) {
  //     _items.insert(existingProductIndex, existingProduct);
  //   });
  //   _items.removeWhere((element) => element.id == id);
  //   notifyListeners();
  // }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-5b73f-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
