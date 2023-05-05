import 'package:flutter/material.dart';
import 'package:little_leagues/screens/auth/signin.dart';
import 'package:little_leagues/screens/auth/signup.dart';
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
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50, bottom: 20),
                child: Image.asset(
                  "assets/logo.png",
                  height: 46,
                  width: 69,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        blurStyle: BlurStyle.inner,
                        spreadRadius: 20,
                        blurRadius: 20,
                        color: black)
                  ]),
                  height: height(context) * .5,
                  width: width(context),
                  child: Image.asset(
                    "assets/onboard.png",
                    fit: BoxFit.fill,
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * .75, 68)),
                  child: Text(
                    "ARE YOU INTERESTED?",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: Colors.black),
                  )),
              SizedBox(
                height: 72,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
