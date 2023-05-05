import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';

class ShowImageScreen extends StatefulWidget {
  final String image;
  final String sender;
  const ShowImageScreen({super.key, required this.image, required this.sender});

  @override
  State<ShowImageScreen> createState() => _ShowImageScreenState();
}

class _ShowImageScreenState extends State<ShowImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sender),
        elevation: 0,
        backgroundColor: black.withOpacity(.5),
      ),
      backgroundColor: primaryColor,
      body: Hero(
        tag: widget.image,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              widget.image,
            )
          ],
        ),
      ),
    );
  }
}
