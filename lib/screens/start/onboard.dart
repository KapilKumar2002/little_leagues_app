import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/auth/signin.dart';
import 'package:little_leagues/utils/constants.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 20),
              child: Image.asset(
                "assets/logo.png",
                height: 46,
                width: 69,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              height: height(context) * .5,
              width: width(context),
              child: Image.asset(
                "assets/home.jpeg",
                fit: BoxFit.fill,
              ),
            ),
            verticalSpace(20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'With “Little Leagues”, now every residential complex can boast of having a mini sports academy with facilities otherwise available only at specialized sports academies, helping their children get qualified training from the safety of their homes.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w300,
                    height: 1.25),
                textAlign: TextAlign.center,
              ),
            ),
            verticalSpace(20),
            ElevatedButton(
                onPressed: () {
                  nextScreenReplace(context, const SignIn());
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * .75, 68)),
                child: const Text(
                  "ARE YOU INTERESTED?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: Colors.black),
                )),
            verticalSpace(72)
          ],
        ),
      ),
    );
  }
}
