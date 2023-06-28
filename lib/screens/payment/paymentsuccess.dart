import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/bottomnav.dart';
import 'package:little_leagues/utils/constants.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String id;
  final bool isDone;
  const PaymentSuccessPage({super.key, required this.id, required this.isDone});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  bool toBottom = false;
  goToBottom() async {
    await Timer(Duration(seconds: 5), () {
      toBottom
          ? null
          : !mounted
              ? null
              : Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomNav(
                            id: widget.id,
                          )),
                  (Route<dynamic> route) => false,
                );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    goToBottom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          verticalSpace(40),
          Icon(
            widget.isDone ? Icons.verified : Icons.thumb_down_alt_rounded,
            color: primaryColor,
            size: 100,
          ),
          SizedBox(height: height(context) * 0.08),
          Text(
            widget.isDone ? "Thank You!" : "Sorry!",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 36,
            ),
          ),
          SizedBox(height: height(context) * 0.01),
          Text(
            widget.isDone ? "Payment done Successfully" : "Payment failed!",
            style: text18w500(primaryColor),
          ),
          SizedBox(height: height(context) * 0.05),
          Text(
            "You will be redirected to the home page shortly\nor click here to return to home page",
            textAlign: TextAlign.center,
            style: text14w400(primaryColor),
          ),
          SizedBox(height: height(context) * 0.35),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  toBottom = !toBottom;
                });
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomNav(
                            id: widget.id,
                          )),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                "Home",
                style: text20Bold(black),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(width(context), 60),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
          )
        ]),
      ),
    );
  }
}
