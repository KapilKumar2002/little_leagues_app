import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/Dashboard.dart';
import 'package:little_leagues/screens/calendar.dart';
import 'package:little_leagues/screens/messages.dart';
import 'package:little_leagues/screens/notification.dart';
import 'package:little_leagues/screens/reports.dart';
import 'package:little_leagues/screens/shop/shop.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:little_leagues/widgets/customdrawer.dart';

class BottomNav extends StatefulWidget {
  final String? id;
  final int? ind;
  const BottomNav({super.key, this.ind, this.id});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int index = 0;
  String institution = "";
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  String groupId = "";
  String fullName = "";
  String profilePic = "";

  giveId() async {
    if (widget.id != null) {
      final userCollection = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.id)
          .get();
      final data = userCollection.data() as Map<String, dynamic>;

      fullName = data['fullName'];

      groupId = data['groupId'];
      institution = data['institution'];
      profilePic = data['profilePic'];

      setState(() {});
    }
  }

  @override
  void initState() {
    setState(() {
      index = widget.ind ?? 0;
    });
    giveId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List bodyWidgets = [
      DashboardPage(fullName, widget.id.toString(), profilePic),
      const ShopPage(),
      CalendarPage(
        id: widget.id.toString(),
        institution: institution,
      ),
      MessagePage(
          height: height(context) - 225,
          groupId: groupId,
          groupName:
              FirebaseAuth.instance.currentUser!.uid.toString() + fullName,
          userName: fullName),
      const ReportsPage()
    ];
    return Scaffold(
      drawer: CustomDrawer(
        id: widget.id.toString(),
        image: profilePic,
      ),
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
                  ? "Sports"
                  : index == 2
                      ? "Calendar"
                      : index == 3
                          ? "Message"
                          : "Report",
          style: text25Bold(white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                index == 0
                    ? NextScreen(context, const NotificationPage())
                    : null;
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
          margin: EdgeInsets.zero,
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
                          style:
                              text10w500(index == 0 ? primaryColor : tabColor),
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
                          style:
                              text10w500(index == 1 ? primaryColor : tabColor),
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
                          style:
                              text10w500(index == 2 ? primaryColor : tabColor),
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
                          style:
                              text10w500(index == 3 ? primaryColor : tabColor),
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
                            index == 4 ? primaryColor : tabColor,
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
