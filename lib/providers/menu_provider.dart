import 'package:flutter/foundation.dart';
import '../models/menu_model.dart';
import '../services/api_service.dart';

class MenuProvider with ChangeNotifier {
  List<Menu> _menus = [];
  List<Menu> get menus => _menus;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Get categories unik
  List<String> get categories {
    Set<String> categorySet = {};
    for (var menu in _menus) {
      categorySet.add(menu.category);
    }
    return categorySet.toList()..sort();
  }

  // Get menus by category
  List<Menu> getMenusByCategory(String category) {
    return _menus.where((menu) => menu.category == category).toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  // Fetch menus dari API
  Future<void> fetchMenus() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiService = ApiService();
      _menus = await apiService.fetchMenus();

      // Urutkan berdasarkan kategori dan displayOrder
      _menus.sort((a, b) {
        int categoryCompare = a.category.compareTo(b.category);
        if (categoryCompare != 0) return categoryCompare;
        return a.displayOrder.compareTo(b.displayOrder);
      });
    } catch (e) {
      _error = 'Failed to load menus: $e';
      if (kDebugMode) print('Error: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cari menu berdasarkan nama
  List<Menu> searchMenus(String query) {
    if (query.isEmpty) return _menus;

    return _menus
        .where((menu) =>
            menu.name.toLowerCase().contains(query.toLowerCase()) ||
            menu.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
