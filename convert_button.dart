import 'package:flutter/material.dart';

class ConvertButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConvertButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color.fromARGB(222, 63, 76, 168),
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        fixedSize: MaterialStateProperty.all(const Size(288, 58)),
      ),
      child: const Text(
        'Convert',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
