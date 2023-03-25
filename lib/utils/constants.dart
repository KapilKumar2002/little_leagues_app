import 'package:flutter/material.dart';

Color primaryColor = Color.fromARGB(255, 194, 235, 83);
Color transparentColor = Colors.transparent;
Color backgroundColor = Colors.grey.shade900;
Color bottomBarColor = black.withOpacity(.8);
Color white = Color(0XFFFFFFFFF);
Color black = Color(0XFF000000);
Color grey = black.withOpacity(.5);

TextStyle text25Bold(Color color) {
  return TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: color);
}

TextStyle text20Bold(Color color) {
  return TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color);
}

TextStyle text18w500(Color color) {
  return TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: color);
}

TextStyle text16w500(Color color) {
  return TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color);
}

TextStyle text15w500(Color color) {
  return TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color);
}

TextStyle text14w500(Color color) {
  return TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color);
}

TextStyle text14w400(Color color) {
  return TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: color);
}

TextStyle text10w400(Color color) {
  return TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: color);
}

TextStyle text12w400(Color color) {
  return TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color,
    overflow: TextOverflow.clip,
  );
}

TextStyle text12w500(Color color) {
  return TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color);
}

TextStyle text10w500(Color color) {
  return TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: color);
}

verticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

horizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
