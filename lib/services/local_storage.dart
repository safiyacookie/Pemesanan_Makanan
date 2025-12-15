import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static const String _cartKey = 'cart_items';
  static const String _favoritesKey = 'favorite_menus';

  // Simpan item keranjang
  static Future<void> saveCartItems(
    List<Map<String, dynamic>> cartItems,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = cartItems
        .map((item) => json.encode(item))
        .toList()
        .cast<String>();
    await prefs.setStringList(_cartKey, cartJson);
  }

  // Load item keranjang
  static Future<List<Map<String, dynamic>>> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList(_cartKey) ?? [];

    return cartJson.map((item) {
      try {
        return json.decode(item) as Map<String, dynamic>;
      } catch (e) {
        return <String, dynamic>{};
      }
    }).toList();
  }

  // Clear keranjang
  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  // Simpan favorite menus (jika ada fitur favorite)
  static Future<void> saveFavoriteMenuIds(Set<String> menuIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, menuIds.toList());
  }

  // Load favorite menus
  static Future<Set<String>> loadFavoriteMenuIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return Set<String>.from(favorites);
  }
}

// Model untuk Cart Item Storage
class CartItemStorage {
  final String menuId;
  final int quantity;
  final DateTime addedTime;

  CartItemStorage({
    required this.menuId,
    required this.quantity,
    required this.addedTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'menuId': menuId,
      'quantity': quantity,
      'addedTime': addedTime.toIso8601String(),
    };
  }

  factory CartItemStorage.fromJson(Map<String, dynamic> json) {
    return CartItemStorage(
      menuId: json['menuId'],
      quantity: json['quantity'],
      addedTime: DateTime.parse(json['addedTime']),
    );
  }
}
