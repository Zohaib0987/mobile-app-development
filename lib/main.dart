import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pizzahut/providers/auth_provider.dart';
import 'package:pizzahut/providers/cart_provider.dart';
import 'package:pizzahut/providers/pizza_provider.dart';
import 'package:pizzahut/services/local_storage_service.dart';
import 'package:pizzahut/screens/auth/login_screen.dart';
import 'package:pizzahut/screens/home/home_screen.dart';
import 'package:pizzahut/screens/checkout/checkout_screen.dart';
import 'package:pizzahut/screens/cart/cart_screen.dart';
import 'package:pizzahut/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final localStorageService = LocalStorageService(prefs);

  // Initialize default pizzas if not already initialized
  final pizzas = await localStorageService.getPizzas();
  if (pizzas == null) {
    await localStorageService.savePizzas(Constants.defaultPizzas);
  }

  runApp(
    MultiProvider(
      providers: [
        Provider<LocalStorageService>.value(value: localStorageService),
        ChangeNotifierProvider(
            create: (_) => AuthProvider(localStorageService)),
        ChangeNotifierProvider(
            create: (_) => PizzaProvider(localStorageService)),
        ChangeNotifierProvider(
            create: (_) => CartProvider(localStorageService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Hut',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE31837), // Pizza Hut Red
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE31837),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => const CheckoutScreen(),
      },
    );
  }
}
