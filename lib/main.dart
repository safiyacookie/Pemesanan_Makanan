import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/menu_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/menu_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Pemesanan Makanan V.O.1',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MenuListScreen(), // <- INI PENTING!
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
