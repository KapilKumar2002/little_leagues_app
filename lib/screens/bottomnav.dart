import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/Dashboard.dart';
import 'package:little_leagues/screens/calendar.dart';
import 'package:little_leagues/screens/messages.dart';
import 'package:little_leagues/screens/notification.dart';
import 'package:little_leagues/screens/reports.dart';
import 'package:little_leagues/screens/shop.dart';
import 'package:little_leagues/services/database_service.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:little_leagues/widgets/customdrawer.dart';

class BottomNav extends StatefulWidget {
  final int? ind;
  const BottomNav({super.key, this.ind});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int index = 0;

  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  final user = FirebaseAuth.instance.currentUser;

  String groupId = "";
  String fullName = "";

  giveId() async {
    // print(user!.uid);
    if (user != null) {
      final userCollection = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();
      final data = userCollection.data() as Map<String, dynamic>;

      setState(() {
        fullName = data['fullName'];
      });

      setState(() {
        groupId = data['groupId'];
      });

      // print(groupId);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      index = widget.ind ?? 0;
    });
    giveId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List bodyWidgets = [
      DashboardPage(fullName),
      ShopPage(),
      CalendarPage(),
      MessagePage(
          groupId: groupId,
          groupName:
              FirebaseAuth.instance.currentUser!.uid.toString() + fullName,
          userName: fullName),
      ReportsPage()
    ];
    return Scaffold(
      drawer: CustomDrawer(),
      key: globalKey,
      appBar: AppBar(
        foregroundColor: white,
        automaticallyImplyLeading: false,
        backgroundColor: black,
        elevation: 0,
        title: Text(
          index == 0
              ? "Dashboard"
              : index == 1
                  ? "Calendar"
                  : index == 2
                      ? "Calendar"
                      : index == 3
                          ? "Message"
                          : "Notification",
          style: text25Bold(white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                index == 0 ? NextScreen(context, NotificationPage()) : null;
              },
              child: Image.asset(
                index == 0 ? "assets/bell.png" : "assets/search.png",
                width: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                globalKey.currentState!.openDrawer();
              },
              child: Image.asset(
                "assets/menu.png",
                width: 28,
              ),
            ),
          )
        ],
      ),
      backgroundColor: black,
      body: bodyWidgets[index],
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 70,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      index = 0;
                    });
                  },
                  child: Container(
                    color: index == 0 ? black : bottomBarColor,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/home.png",
                          height: 26,
                          width: 26,
                          color: index == 0 ? primaryColor : white2,
                        ),
                        verticalSpace(2),
                        Text(
                          "Home",
                          style: text10w500(
                              index == 0 ? primaryColor : Color(0xFFBCBCBC)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      index = 1;
                    });
                  },
                  child: Container(
                    color: index == 1 ? black : bottomBarColor,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/shop.png",
                          height: 26,
                          width: 26,
                          color: index == 1 ? primaryColor : white2,
                        ),
                        verticalSpace(2),
                        Text(
                          "Shop",
                          style: text10w500(
                              index == 1 ? primaryColor : Color(0xFFBCBCBC)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      index = 2;
                    });
                  },
                  child: Container(
                    color: index == 2 ? black : bottomBarColor,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/cal.png",
                          height: 26,
                          width: 26,
                          color: index == 2 ? primaryColor : white2,
                        ),
                        verticalSpace(2),
                        Text(
                          "Calendar",
                          style: text10w500(
                              index == 2 ? primaryColor : Color(0xFFBCBCBC)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      index = 3;
                    });
                  },
                  child: Container(
                    color: index == 3 ? black : bottomBarColor,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/message.png",
                          height: 26,
                          width: 26,
                          color: index == 3 ? primaryColor : white2,
                        ),
                        verticalSpace(2),
                        Text(
                          "Messages",
                          style: text10w500(
                              index == 3 ? primaryColor : Color(0xFFBCBCBC)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      index = 4;
                    });
                  },
                  child: Container(
                    color: index == 4 ? black : bottomBarColor,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/report.png",
                          height: 26,
                          width: 26,
                          color: index == 4 ? primaryColor : white2,
                        ),
                        verticalSpace(2),
                        Text(
                          "Reports",
                          style: text10w500(
                            index == 4 ? primaryColor : Color(0xFFBCBCBC),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
