import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;

  const InputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      borderSide: BorderSide(
        color: Color.fromARGB(198, 19, 18, 16),
        width: 2.0,
        style: BorderStyle.solid,
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: "Please enter amount in rupees",
          hintStyle: TextStyle(color: Color.fromRGBO(250, 247, 247, 0.897)),
          prefixIcon: Icon(Icons.monetization_on),
          filled: true,
          fillColor: Color.fromARGB(222, 219, 223, 222),
          focusedBorder: border,
          enabledBorder: border,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }
}
