import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/helper/helper_function.dart';
import 'package:little_leagues/screens/start/onboard.dart';
import 'package:little_leagues/services/database_service.dart';
import 'package:little_leagues/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isSignedIn = false;
  final user = FirebaseAuth.instance.currentUser;

  getMainScreen() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
    Timer(const Duration(seconds: 2), () async {
      _isSignedIn
          ? await DatabaseService(uid: user!.uid).getUserDataField(context,
              num: user!.phoneNumber != null ? 3 : null)
          : nextScreenReplace(context, const OnBoardScreen());
    });
  }

  @override
  void initState() {
    getMainScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 169),
              padding: const EdgeInsets.symmetric(horizontal: 79),
              child: Image.asset("assets/logo.png")),
          Container(
            margin: const EdgeInsets.only(bottom: 115),
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
    );
  }
}
