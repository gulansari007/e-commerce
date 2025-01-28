import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modals/home_screen_modal.dart'; 

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  CartProvider() {
    _loadCartFromPrefs();
  }

  // Add item to cart
  void addToCart(Commerce product, int quantity) {
    var existingItem = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    if (existingItem.quantity > 0) {
      existingItem.quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  // Update quantity
  void updateQuantity(CartItem item, int quantity) {
    item.quantity = quantity;
    _saveCartToPrefs();
    notifyListeners();
  }

  // Remove item from cart
  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    _saveCartToPrefs();
    notifyListeners();
  }

  // Save cart to SharedPreferences
  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartJson =
        _cartItems.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('cartItems', cartJson);
  }

  // Load cart from SharedPreferences
  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartJson = prefs.getStringList('cartItems');
    if (cartJson != null) {
      _cartItems = cartJson
          .map((itemJson) => CartItem.fromJson(jsonDecode(itemJson)))
          .toList();
    }
    notifyListeners();
  }

  // Clear cart
  Future<void> clearCart() async {
    _cartItems.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
    notifyListeners();
  }
}

class CartItem {
  Commerce product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Commerce.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}
