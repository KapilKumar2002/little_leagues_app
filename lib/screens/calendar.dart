import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: black,
        elevation: 0,
        title: Text(
          "Calendar",
          style: text25Bold(white),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        ],
      ),
      body: Container(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
