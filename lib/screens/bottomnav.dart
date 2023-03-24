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
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
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
      drawer: Drawer(
        backgroundColor: Colors.grey.shade900,
      ),
      key: globalKey,
      appBar: AppBar(
        foregroundColor: white,
        automaticallyImplyLeading: false,
        backgroundColor: black,
        elevation: 0,
        title: Text(
          index == 0
              ? "Reports"
              : index == 1
                  ? "Calendar"
                  : index == 2
                      ? "Dashboard"
                      : index == 3
                          ? "Message"
                          : "Notification",
          style: text25Bold(white),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                globalKey.currentState!.openDrawer();
              },
              icon: Icon(Icons.menu)),
        ],
      ),
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
