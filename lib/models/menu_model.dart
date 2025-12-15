class Menu {
  final String id;
  final String name;
  final String image;
  final double price;
  final String category;
  final int displayOrder;

  Menu({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    required this.displayOrder,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'category': category,
      'displayOrder': displayOrder,
    };
  }

  // Data dummy untuk testing
  static List<Menu> get dummyMenus => [
        Menu(
          id: '1',
          name: 'Nasi Goreng Spesial',
          image:
              'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
          price: 35000,
          category: 'Makanan',
          displayOrder: 1,
        ),
        Menu(
          id: '2',
          name: 'Mie Ayam Bakso',
          image:
              'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=400',
          price: 28000,
          category: 'Makanan',
          displayOrder: 2,
        ),
        Menu(
          id: '3',
          name: 'Kwetiau Goreng',
          image:
              'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400',
          price: 32000,
          category: 'Makanan',
          displayOrder: 3,
        ),
        Menu(
          id: '4',
          name: 'Sate Ayam',
          image:
              'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400',
          price: 25000,
          category: 'Makanan',
          displayOrder: 4,
        ),
        Menu(
          id: '5',
          name: 'Es Teh Manis',
          image:
              'https://images.unsplash.com/photo-1561047029-3000c68339ca?w=400',
          price: 8000,
          category: 'Minuman',
          displayOrder: 1,
        ),
        Menu(
          id: '6',
          name: 'Jus Alpukat',
          image:
              'https://images.unsplash.com/photo-1628992682633-bf2d40cb595f?w=400',
          price: 15000,
          category: 'Minuman',
          displayOrder: 2,
        ),
        Menu(
          id: '7',
          name: 'Kopi Hitam',
          image:
              'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400',
          price: 12000,
          category: 'Minuman',
          displayOrder: 3,
        ),
        Menu(
          id: '8',
          name: 'Air Mineral',
          image:
              'https://images.unsplash.com/photo-1523362628745-0c100150b504?w=400',
          price: 5000,
          category: 'Minuman',
          displayOrder: 4,
        ),
      ];
}
