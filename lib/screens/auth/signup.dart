import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';

import 'package:little_leagues/helper/helper_function.dart';
import 'package:little_leagues/screens/auth/email_auth_screen.dart';

import 'package:little_leagues/screens/auth/signin.dart';
import 'package:little_leagues/screens/bottomnav.dart';
import 'package:little_leagues/services/auth_service.dart';
import 'package:little_leagues/services/database_service.dart';

import 'package:little_leagues/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:little_leagues/widgets/showsnackbar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  AuthService authService = AuthService();

  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool _isLoading = false;
  EmailOTP? myauth;
  @override
  void initState() {
    obscureText = true;
    myauth = EmailOTP();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void sendOTP() async {
    await myauth!.setConfig(
        appEmail: "kapil012002@gmail.com",
        appName: "Little Leagues Live",
        userEmail: emailController.value.text.trim(),
        otpLength: 6,
        otpType: OTPType.digitsOnly);
    if (await myauth!.sendOTP() == true) {
      // using a void function because i am using a
      // stateful widget and seting the state from here.
      openSnackbar(context, "OTP has been sent", primaryColor);
      NextScreen(
          context,
          EmailAuthScreen(
            fullName: nameController.value.text.trim(),
            email: emailController.value.text.trim(),
            password: passController.value.text.trim(),
            emailOTP: myauth!,
            phone: "+91${phoneController.value.text.trim()}",
          ));
      _isLoading = false;
    } else {
      openSnackbar(context, "Oops, OTP send failed", primaryColor);
    }
  }

  validate() async {
    if (formKey.currentState!.validate()) {
      sendOTP();
      _isLoading = true;
    }
  }

  Future handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });
    await AuthService().signInWithGoogle().then((value) async {
      if (value == true) {
        final user = FirebaseAuth.instance.currentUser;
        await DatabaseService(uid: user!.uid).getUserDataField(context);
        await HelperFunctions.saveUserLoggedInStatus(true);
      } else {
        openSnackbar(context, value, primaryColor);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future handleFacebookSignIn() async {
    setState(() {
      _isLoading = true;
    });
    await AuthService().signInWithFacebook().then((value) async {
      if (value == true) {
        await HelperFunctions.saveUserLoggedInStatus(true);

        final user = FirebaseAuth.instance.currentUser;
        await DatabaseService(uid: user!.uid).getUserDataField(context);
      } else {
        // openSnackbar(context, value, primaryColor);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, const BottomNav());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Center(
                          child: Image.asset(
                        "assets/logo.png",
                        width: 140,
                        height: 102,
                      )),
                    ),
                    verticalSpace(28),
                    Center(
                      child: Text(
                        "SIGN UP",
                        style: text20w500(white),
                      ),
                    ),
                    verticalSpace(25),
                    Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: text16w600(white),
                            ),
                            verticalSpace(6),
                            TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This field is required!';
                                }
                                if (value.trim().length < 6) {
                                  return 'Username must be at least 6 characters in length!';
                                }
                                // Return null if the entered username is valid
                                return null;
                              },
                              style: text18w500(black),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 27, vertical: 22),
                                hintText: "Enter your Name",
                                filled: true,
                                hintStyle: text18w500(Colors.grey.shade600),
                                fillColor: fillColor,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                            ),
                            verticalSpace(25),
                            Text(
                              "Phone Number",
                              style: text16w600(white),
                            ),
                            verticalSpace(6),
                            TextFormField(
                              maxLength: 10,
                              controller: phoneController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This field is required!';
                                }
                                if (value.trim().length < 10) {
                                  return 'Username must be at least 6 characters in length!';
                                }
                                // Return null if the entered username is valid
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              style: text18w500(black),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 27, vertical: 22),
                                hintText: "Enter your Phone Number",
                                filled: true,
                                hintStyle: text18w500(Colors.grey.shade600),
                                fillColor: fillColor,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                            ),
                            Text(
                              "Email ID",
                              style: text16w600(white),
                            ),
                            verticalSpace(6),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This field is required!';
                                }
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)
                                    ? null
                                    : "Please enter a valid email!";
                              },
                              controller: emailController,
                              style: text18w500(black),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 27, vertical: 22),
                                hintText: "Enter your Email ID",
                                filled: true,
                                hintStyle: text18w500(Colors.grey.shade600),
                                fillColor: fillColor,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                            ),
                            verticalSpace(25),
                            Text(
                              "Password",
                              style: text16w600(white),
                            ),
                            verticalSpace(6),
                            TextFormField(
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'This field is required!';
                                }
                                return RegExp(
                                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                        .hasMatch(val)
                                    ? null
                                    : "1 upper, 1 special character, 1 numeric character!";
                              },
                              controller: passController,
                              style: text18w500(black),
                              obscureText: obscureText,
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        obscureText
                                            ? obscureText = false
                                            : obscureText = true;
                                      });
                                    },
                                    child: Icon(
                                      obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: black,
                                    )),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 27, vertical: 22),
                                hintText: "Enter your Password",
                                filled: true,
                                hintStyle: text18w500(Colors.grey.shade600),
                                fillColor: fillColor,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                            ),
                            verticalSpace(31),
                            ElevatedButton(
                                onPressed: () {
                                  validate();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(68)),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width, 71)),
                                child: Text(
                                  "SIGN UP",
                                  style: text20w800(black),
                                )),
                          ],
                        )),
                    verticalSpace(10),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: text12w500(white),
                          ),
                          Text(
                            "Sign in",
                            style: text12w500(primaryColor),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(24),
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          height: 2,
                          color: Color(0xffBABABA),
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "OR",
                            style: text20w600(white2.withOpacity(.43)),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          height: 2,
                          color: Color(0xffBABABA),
                        )),
                      ],
                    ),
                    verticalSpace(17),
                    Center(
                      child: Text(
                        "Sign Up with",
                        style: text16w600(white2.withOpacity(.68)),
                      ),
                    ),
                    verticalSpace(20),
                    Center(
                      child: Container(
                        height: 40,
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                handleGoogleSignIn();
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 40,
                                  child: Image.asset("assets/google.png")),
                            ),
                            InkWell(
                              onTap: () {
                                handleFacebookSignIn();
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 40,
                                  child: Image.asset("assets/facebook.png")),
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpace(30)
                  ],
                ),
              ),
            ),
    );
  }
}
