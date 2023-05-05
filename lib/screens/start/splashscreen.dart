import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/helper/helper_function.dart';
import 'package:little_leagues/screens/Dashboard.dart';
import 'package:little_leagues/screens/adminsite/adminchatroom.dart';
import 'package:little_leagues/screens/auth/signin.dart';
import 'package:little_leagues/screens/bottomnav.dart';
import 'package:little_leagues/screens/start/onboard.dart';
import 'package:little_leagues/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isSignedIn = false;

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   // getUserLoggedInStatus();
  //   super.initState();
  //   Timer(Duration(seconds: 2), () {
  //     NextScreen(context, AdminChatRoom());
  //   });
  // }
  @override
  void initState() {
    // TODO: implement initState
    getUserLoggedInStatus();
    super.initState();
    Timer(Duration(seconds: 2), () {
      NextScreen(context, _isSignedIn ? BottomNav() : OnBoardScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.only(top: 169),
                padding: EdgeInsets.symmetric(horizontal: 79),
                child: Image.asset("assets/logo.png")),
            Container(
              margin: EdgeInsets.only(bottom: 115),
              child: Text(
                "SPORTS AT\nYOUR\nDOORSTEP",
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                    letterSpacing: 3,
                    height: 1.2,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
