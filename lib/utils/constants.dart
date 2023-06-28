import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Color primaryColor = const Color(0xFFDDFE52);
Color transparentColor = Colors.transparent;
Color backgroundColor = const Color(0xFF1A1919);
Color nColor = const Color(0xFF313030);
Color bottomBarColor = black.withOpacity(.8);
Color fillColor = const Color(0xFFE1E1E1);
Color white = Colors.white.withOpacity(.83);
Color white2 = Colors.white;
Color tabColor = const Color(0xFFBCBCBC);
Color black = const Color(0XFF000000);
Color grey = black.withOpacity(.5);
String profileIcon =
    "https://firebasestorage.googleapis.com/v0/b/littleleagues.appspot.com/o/appIcons%2FprofileIcon.png?alt=media&token=46f7cd4d-af66-42e3-a03a-ea0c54c98d7c";

String adminUID = "1rM4qLcVEhCARipS0Ivfa3d4Wt0=debraj_nasker";

TextStyle text25Bold(Color color) {
  return TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: color);
}

TextStyle text20Bold(Color color) {
  return TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color);
}

TextStyle text20w500(Color color) {
  return TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: color);
}

TextStyle text20w800(Color color) {
  return TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color);
}

TextStyle text18w500(Color color) {
  return TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: color);
}

TextStyle text16w500(Color color) {
  return TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color);
}

TextStyle text16w600(Color color) {
  return TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color);
}

TextStyle text15w500(Color color) {
  return TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color);
}

TextStyle text15w400(Color color) {
  return TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: color);
}

TextStyle text14w500(Color color, {TextOverflow? overflow}) {
  return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
      overflow: overflow);
}

TextStyle text14w800(Color color, {TextOverflow? overflow}) {
  return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w800,
      color: color,
      overflow: overflow);
}

TextStyle text12w800(Color color, {TextOverflow? overflow}) {
  return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      color: color,
      overflow: overflow);
}

TextStyle text10w800(Color color, {TextOverflow? overflow}) {
  return TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w800,
      color: color,
      overflow: overflow);
}

TextStyle text8w800(Color color, {TextOverflow? overflow}) {
  return TextStyle(
      fontSize: 8,
      fontWeight: FontWeight.w800,
      color: color,
      overflow: overflow);
}

TextStyle text14w400(Color color, {FontStyle? fontStyle}) {
  return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color,
      fontStyle: fontStyle);
}

TextStyle text14w700(Color color) {
  return TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color);
}

TextStyle text10w400(Color color) {
  return TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: color);
}

TextStyle text8w400(Color color) {
  return TextStyle(fontSize: 8, fontWeight: FontWeight.w400, color: color);
}

TextStyle text12w400(Color color,
    {TextOverflow? overflow, FontStyle? fontStyle}) {
  return TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: fontStyle,
    color: color,
    overflow: overflow ?? TextOverflow.clip,
  );
}

TextStyle text12w600(Color color) {
  return TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color);
}

TextStyle text20w600(Color color) {
  return TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color);
}

TextStyle text12w500(Color color) {
  return TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color);
}

TextStyle text10w500(Color color, {TextDecoration? decoration}) {
  return TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: color,
      decoration: decoration);
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

void NextScreen(BuildContext context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void popBack(BuildContext context) {
  Navigator.pop(context);
}

void nextScreenReplace(BuildContext context, page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

@override
DateTime fromJson(Timestamp timestamp) {
  return timestamp.toDate();
}
