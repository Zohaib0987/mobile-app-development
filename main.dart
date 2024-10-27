import 'package:flutter/material.dart';
import 'CurrencyConverter.dart'; // Ensure this path is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Currency Converter', // Adding a title for better context
      home: CurrencyConverter(),
    );
  }
}
