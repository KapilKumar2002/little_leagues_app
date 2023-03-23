import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/Dashboard.dart';
import 'package:little_leagues/screens/calendar.dart';
import 'package:little_leagues/screens/messages.dart';
import 'package:little_leagues/screens/notification.dart';
import 'package:little_leagues/screens/reports.dart';
import 'package:little_leagues/utils/constants.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List bodyWidgets = [
    ReportsPage(),
    CalendarPage(),
    DashboardPage(),
    MessagePage(),
    NotificationPage()
  ];
  int index = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: bodyWidgets[index],
      bottomNavigationBar: BottomAppBar(
        child: Container(
          // color: black,
          height: 70,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 70,
                  color: index == 0 ? black : bottomBarColor,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      icon: Icon(
                        CupertinoIcons.chart_bar_alt_fill,
                        color: white,
                      )),
                ),
              ),
              Expanded(
                child: Container(
                  height: 70,
                  color: index == 1 ? black : bottomBarColor,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          index = 1;
                        });
                      },
                      icon: Icon(
                        Icons.calendar_today,
                        color: white,
                      )),
                ),
              ),
              Expanded(
                child: Container(
                  height: 70,
                  color: index == 2 ? black : bottomBarColor,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          index = 2;
                        });
                      },
                      icon: Icon(
                        CupertinoIcons.home,
                        color: white,
                      )),
                ),
              ),
              Expanded(
                child: Container(
                  height: 70,
                  color: index == 3 ? black : bottomBarColor,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          index = 3;
                        });
                      },
                      icon: Icon(
                        Icons.chat_bubble_outline,
                        color: white,
                      )),
                ),
              ),
              Expanded(
                child: Container(
                  height: 70,
                  color: index == 4 ? black : bottomBarColor,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          index = 4;
                        });
                      },
                      icon: Icon(
                        CupertinoIcons.bell_fill,
                        color: white,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
