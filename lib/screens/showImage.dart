import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';

class ShowImageScreen extends StatefulWidget {
  final String image;
  final String sender;
  final String time;
  const ShowImageScreen(
      {super.key,
      required this.image,
      required this.sender,
      required this.time});

  @override
  State<ShowImageScreen> createState() => _ShowImageScreenState();
}

class _ShowImageScreenState extends State<ShowImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: white2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.sender,
              style: text15w500(white2),
            ),
            Text(
              widget.time,
              style: text10w400(white2),
            )
          ],
        ),
        elevation: 0,
        backgroundColor: black.withOpacity(.5),
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Container(
          color: black.withOpacity(.5),
          height: height(context) - 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Hero(
                  tag: widget.image,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
