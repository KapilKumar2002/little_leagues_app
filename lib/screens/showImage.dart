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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.sender),
            Text(
              widget.time,
              style: text10w400(black),
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
          height: height(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Hero(
                  tag: widget.image,
                  child: Container(
                    margin: EdgeInsets.all(25),
                    child: Image.network(
                      widget.image,
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
