import 'package:flutter/material.dart';
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
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          // color: backgroundColor,
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      height: 50,
                      width: 75,
                      fit: BoxFit.fill,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 35,
                        ))
                  ],
                ),
              ),
              Image.asset("assets/onboard.png"),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Text(
                      "SPORTS AT\nYOUR\nDOORSTEP",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          color: primaryColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'With "Little Leagues" can boast of facilities otherwise With "Little Leagues" can boast of facilities otherwise With "Little Leagues" can boast of facilities otherwise With "Little Leagues" can boast of facilities otherwise',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          wordSpacing: 2,
                          height: 1.5),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * .75, 60)),
                        child: Text(
                          "ARE YOU INTERESTED?",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: Colors.black),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
