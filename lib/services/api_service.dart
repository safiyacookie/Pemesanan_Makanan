import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Simulasi API (menggunakan dummy data karena tidak ada API nyata)
  Future<List<Menu>> fetchMenus() async {
    try {
      // Simulasi delay network
      await Future.delayed(const Duration(seconds: 2));

      // Ambil data dummy
      List<Menu> menus = Menu.dummyMenus;

      // Pencegahan duplikasi berdasarkan ID
      return _removeDuplicates(menus);
    } catch (e) {
      throw Exception('Failed to load menus: $e');
    }
  }

  // Method untuk mencegah duplikasi menu
  List<Menu> _removeDuplicates(List<Menu> menus) {
    Map<String, Menu> uniqueMenus = {};

    for (var menu in menus) {
      if (!uniqueMenus.containsKey(menu.id)) {
        uniqueMenus[menu.id] = menu;
      }
    }

    return uniqueMenus.values.toList();
  }

  // Jika ada API nyata, gunakan ini:
  Future<List<Menu>> fetchMenusFromApi() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      // Konversi ke Menu (disesuaikan dengan struktur API)
      List<Menu> menus = jsonResponse.map((item) {
        return Menu(
          id: item['id'].toString(),
          name: item['title'] ?? 'Menu',
          image: 'https://via.placeholder.com/150',
          price: 20000 + (item['id'] as num).toDouble() * 5000,
          category: item['id'] % 2 == 0 ? 'Makanan' : 'Minuman',
          displayOrder: item['id'],
        );
      }).toList();

      return _removeDuplicates(menus);
    } else {
      throw Exception('Failed to load menus from API');
    }
  }
}
