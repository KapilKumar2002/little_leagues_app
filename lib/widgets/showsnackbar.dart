import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';

openSnackbar(context, snackMessage, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      action: SnackBarAction(
        label: "OK",
        textColor: Colors.black,
        onPressed: () {},
      ),
      content: Text(
        snackMessage,
        style: text14w500(black),
      )));
}
