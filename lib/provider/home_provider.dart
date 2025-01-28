import 'dart:convert';
import 'dart:developer';
import 'package:e_commerce/modals/home_screen_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommerceProvider with ChangeNotifier {
  List<Commerce> _products = [];

  List<Commerce> get products => _products;

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://fakestoreapi.com/products');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Assuming `_products` is a list of `Commerce` objects
        _products = data.map((item) => Commerce.fromJson(item)).toList();
        log('Products fetched successfully. Total products: ${_products.length}');
        notifyListeners(); // Update UI
      } else {
        log('Failed to load products. Status code: ${response.statusCode}');
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      log('Error fetching products: $error',
          error: error, stackTrace: stackTrace);
      throw Exception('Error fetching products: $error');
    }
  }
}
