import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';

class CustomDropDownField extends StatefulWidget {
  final String hint;
  final List list;
  final GlobalKey<FormFieldState> fieldKey;
  const CustomDropDownField(
      {super.key,
      required this.list,
      required this.fieldKey,
      required this.hint});

  @override
  State<CustomDropDownField> createState() => _CustomDropDownFieldState();
}

class _CustomDropDownFieldState extends State<CustomDropDownField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: widget.fieldKey,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Field required!';
          }

          return null;
        },
        hint: Text("Chosse Class"),
        style: text15w500(black),
        dropdownColor: white,
        decoration: InputDecoration(
            filled: true, fillColor: white, border: InputBorder.none),
        isExpanded: true,
        items: widget.list.map((e) {
          return DropdownMenuItem(
              value: e.toString(), child: Text(e.toString()));
        }).toList(),
        onChanged: (value) {
          setState(() {});
        });
  }
}
