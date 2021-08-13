import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.description,
    this.isFavorite = false,
    @required this.price,
    @required this.imageUrl,
    @required this.title,
  });

  void toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        "https://shop-app-5b73f-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token";

    try {
      await http.put(url,
          body: json.encode(
            isFavorite,
          ));
    } catch (e) {
      isFavorite = oldStatus;
    }
  }
}
