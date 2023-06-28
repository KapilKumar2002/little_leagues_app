import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';

openSnackbar(context, snackMessage, color,
    {VoidCallback? onTap, String? label}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      action: SnackBarAction(
        label: label ?? "OK",
        textColor: Colors.black,
        onPressed: onTap ?? () {},
      ),
      content: Text(
        snackMessage,
        style: text14w500(black),
      )));
}
