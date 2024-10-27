import 'package:flutter/material.dart';
import 'title_text.dart';
import 'input_field.dart';
import 'convert_button.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController _controller = TextEditingController();

  void _convertCurrency() {
    debugPrint('Convert pressed: ${_controller.text}');
    // Add conversion logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(204, 0, 1, 5),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleText(),
              InputField(controller: _controller),
              ConvertButton(onPressed: _convertCurrency),
            ],
          ),
        ),
      ),
    );
  }
}
