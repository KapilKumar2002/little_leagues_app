import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  // final CallbackAction func;
  const CustomTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required!';
        }
        if (value.trim().length < 10) {
          return 'Field must have at least 10 characters in length!';
        }
        // Return null if the entered username is valid
        return null;
      },
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: white2),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: white2),
              borderRadius: BorderRadius.circular(10))),
    );
  }
}
