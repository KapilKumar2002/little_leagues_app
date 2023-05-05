import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/helper/helper_function.dart';
import 'package:little_leagues/services/auth_service.dart';
import 'package:little_leagues/services/database_service.dart';

import 'package:little_leagues/utils/constants.dart';
import 'package:little_leagues/widgets/showsnackbar.dart';
import 'package:pinput/pinput.dart';

import '../bottomnav.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController phoneController = TextEditingController();
  int start = 30;
  bool wait = false;
  String buttonName = "Send OTP";
  String verificationIdFinal = "";
  String smsCode = "";
  String? uid;
  final TextEditingController _pinPutController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle:
        TextStyle(fontSize: 20, color: black, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: fillColor,
      borderRadius: BorderRadius.circular(4),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: black,
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 74),
                  child: Center(
                      child: Image.asset(
                    "assets/logo.png",
                    width: 140,
                    height: 102,
                  )),
                ),
                verticalSpace(56),
                Center(
                  child: Text(
                    "OTP AUTHENTICATION",
                    style: text20w500(white),
                  ),
                ),
                verticalSpace(53),
                Text(
                  "Phone Number",
                  style: text16w600(white),
                ),
                verticalSpace(7),
                Form(
                  key: key,
                  child: TextFormField(
                    controller: phoneController,
                    style: text16w600(black),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 27, vertical: 22),
                      hintText: "Phone Number",
                      filled: true,
                      hintStyle: text16w600(Colors.grey.shade500),
                      fillColor: fillColor,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 2),
                        child: Text(
                          " (+91) ",
                          style: text15w500(black),
                        ),
                      ),
                      suffixIcon: InkWell(
                        onTap: wait
                            ? null
                            : () async {
                                setState(() {
                                  start = 30;
                                  wait = true;
                                  buttonName = "Resend";
                                });
                                await AuthService().verifyPhoneNumber(
                                    "+91${phoneController.text}",
                                    context,
                                    setData);
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          child: Text(
                            buttonName,
                            style: TextStyle(
                              color: wait ? grey : black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                verticalSpace(27),
                Text(
                  "OTP",
                  style: text16w600(white),
                ),
                verticalSpace(7),
                Center(
                  child: Pinput(
                    onCompleted: (value) {
                      setState(() {
                        smsCode = value;
                      });
                    },
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    controller: _pinPutController,
                    pinAnimationType: PinAnimationType.fade,
                  ),
                ),
                verticalSpace(25),
                Center(
                  child: RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Send OTP again in ",
                        style: text14w400(primaryColor),
                      ),
                      TextSpan(
                        text: "00:$start",
                        style: text15w500(Colors.red),
                      ),
                      TextSpan(
                        text: " sec ",
                        style: text14w400(primaryColor),
                      ),
                    ],
                  )),
                ),
                verticalSpace(47),
                ElevatedButton(
                    onPressed: () {
                      AuthService()
                          .signInwithPhoneNumber(
                              verificationIdFinal, smsCode, context)
                          .then((value) async {
                        if (value == true) {
                          await HelperFunctions.saveUserLoggedInStatus(true);

                          final user = await FirebaseAuth.instance.currentUser;
                          await DatabaseService(uid: user!.uid)
                              .getUserDataField(context, num: 3);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(68)),
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 71)),
                    child: Text(
                      "Submit",
                      style: text20w800(white2),
                    )),
                verticalSpace(10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField() {
    return TextFormField(
      validator: (value) {
        if (value!.length < 10) {
          return "Password must be at least 10 characters";
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.number,
      controller: phoneController,
      style: text18w500(black),
      decoration: InputDecoration(),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }
}
