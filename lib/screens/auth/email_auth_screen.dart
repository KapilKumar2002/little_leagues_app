import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/auth/signin.dart';
import 'package:little_leagues/screens/infoscreen.dart';
import 'package:little_leagues/services/auth_service.dart';
import 'package:little_leagues/services/database_service.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:little_leagues/widgets/showsnackbar.dart';
import 'package:pinput/pinput.dart';

import '../../helper/helper_function.dart';

class EmailAuthScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final EmailOTP emailOTP;
  const EmailAuthScreen(
      {super.key,
      required this.fullName,
      required this.email,
      required this.password,
      required this.phone,
      required this.emailOTP});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  bool _isLoading = false;
  AuthService authService = AuthService();
  final user = FirebaseAuth.instance.currentUser;

  String? uid;

  register() async {
    await authService
        .registerUserWithEmailandPassword(
            widget.fullName, widget.email, widget.password, widget.phone)
        .then((value) async {
      if (value == true) {
        await HelperFunctions.saveUserLoggedInStatus(true);

        final user = FirebaseAuth.instance.currentUser;
        await DatabaseService(uid: user!.uid).getUserDataField(context);
      } else {
        openSnackbar(context, value, primaryColor);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  verify() async {
    if (await widget.emailOTP.verifyOTP(otp: _pinPutController.value.text) ==
        true) {
      openSnackbar(context, "Email is verified", primaryColor);
      register();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid OTP"),
      ));
    }
  }

  final TextEditingController _pinPutController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 45,
    height: 45,
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Email Verification"),
        foregroundColor: white2,
        backgroundColor: transparentColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Center(
                  child: Pinput(
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    controller: _pinPutController,
                    pinAnimationType: PinAnimationType.fade,
                  ),
                ),
              ),
              verticalSpace(20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "A 6 digit verification code has been sent on your email id '${widget.email}'.\nPlease check it!",
                  style: text15w500(white2),
                ),
              ),
            ],
          ),
          Container(
              height: 80,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ElevatedButton(
                  onPressed: () {
                    verify();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(68)),
                      minimumSize: Size(MediaQuery.of(context).size.width, 71)),
                  child: Text(
                    "VERIFY",
                    style: text20w800(black),
                  )))
        ],
      ),
    );
  }
}
