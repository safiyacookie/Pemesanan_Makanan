import 'package:flutter/foundation.dart';
import '../models/menu_model.dart';
import '../services/local_storage.dart';

class CartItem {
  final Menu menu;
  int quantity;
  final DateTime addedTime;

  CartItem({
    required this.menu,
    this.quantity = 1,
    required this.addedTime,
  });

  double get totalPrice => menu.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'menu': menu.toJson(),
      'quantity': quantity,
      'addedTime': addedTime.toIso8601String(),
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menu: Menu.fromJson(json['menu']),
      quantity: json['quantity'],
      addedTime: DateTime.parse(json['addedTime']),
    );
  }
}

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  // Urutkan berdasarkan waktu ditambahkan (terbaru pertama)
  List<CartItem> get sortedCartItems {
    return List.from(_cartItems)
      ..sort((a, b) => b.addedTime.compareTo(a.addedTime));
  }

  // Add to cart dengan pencegahan duplikasi
  void addToCart(Menu menu) {
    final existingIndex =
        _cartItems.indexWhere((item) => item.menu.id == menu.id);

    if (existingIndex >= 0) {
      // Update quantity jika sudah ada
      _cartItems[existingIndex].quantity++;
    } else {
      // Tambah baru jika belum ada
      _cartItems.add(CartItem(
        menu: menu,
        addedTime: DateTime.now(),
      ));
    }
    notifyListeners();
    _saveToLocalStorage();
  }

  // Remove from cart
  void removeFromCart(String menuId) {
    _cartItems.removeWhere((item) => item.menu.id == menuId);
    notifyListeners();
    _saveToLocalStorage();
  }

  // Update quantity
  void updateQuantity(String menuId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(menuId);
      return;
    }

    final index = _cartItems.indexWhere((item) => item.menu.id == menuId);
    if (index >= 0) {
      _cartItems[index].quantity = newQuantity;
      notifyListeners();
      _saveToLocalStorage();
    }
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
    _saveToLocalStorage();
  }

  // Perhitungan total sesuai studi kasus
  double get subtotal {
    return _cartItems.fold(
        0, (sum, item) => sum + (item.menu.price * item.quantity));
  }

  double get serviceCharge {
    return subtotal * 0.015; // 1.5%
  }

  double get ppn {
    return (subtotal + serviceCharge) * 0.10; // 10% PPN
  }

  double get total {
    return subtotal + serviceCharge + ppn;
  }

  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Format currency untuk display
  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  // Local Storage methods
  Future<void> _saveToLocalStorage() async {
    try {
      final itemsToSave = _cartItems.map((item) => item.toJson()).toList();
      await LocalStorage.saveCartItems(itemsToSave);
    } catch (e) {
      if (kDebugMode) print('Error saving cart: $e');
    }
  }

  Future<void> loadFromLocalStorage() async {
    try {
      final savedItems = await LocalStorage.loadCartItems();
      _cartItems = savedItems.map((json) => CartItem.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Error loading cart: $e');
    }
  }
}
