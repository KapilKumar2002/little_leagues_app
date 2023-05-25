import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:intl/intl.dart';

class CustomDateSelector extends StatefulWidget {
  final TextEditingController controller;
  const CustomDateSelector({super.key, required this.controller});

  @override
  State<CustomDateSelector> createState() => _CustomDateSelectorState();
}

class _CustomDateSelectorState extends State<CustomDateSelector> {
  List newsPaper = ["Times of India", "Kesari", "Amar Ujala"];
  String? newspaper = "Select newspaper";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required!';
          }
          // Return null if the entered username is valid
          return null;
        },
        readOnly: true,
        controller: widget.controller,
        style: text18w500(white2),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                _showDatePicker(widget.controller);
              },
              icon: Icon(
                Icons.calendar_month,
                color: white,
              )),
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          hintText: "Enter your D.O.B.",
          hintStyle: text18w500(white2),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: white2),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: white2),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  void _showDatePicker(TextEditingController controller) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2050))
        .then((value) {
      setState(() {
        controller.text = DateFormat.yMd().format(value!);
      });
    });
  }
}
