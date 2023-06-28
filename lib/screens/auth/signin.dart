import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:little_leagues/helper/helper_function.dart';
import 'package:little_leagues/screens/auth/phoneauth.dart';
import 'package:little_leagues/screens/auth/signup.dart';
import 'package:little_leagues/screens/bottomnav.dart';
import 'package:little_leagues/services/auth_service.dart';
import 'package:little_leagues/services/database_service.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:little_leagues/widgets/showsnackbar.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  bool remember = false;
  bool obscureText = true;
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthService authService = AuthService();
  final user = FirebaseAuth.instance.currentUser;

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(
              emailController.text, passController.text)
          .then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(emailController.text);
          nextScreenReplace(
              context,
              BottomNav(
                id: FirebaseAuth.instance.currentUser!.uid,
              ));
        } else {
          openSnackbar(
            context,
            value,
            primaryColor,
          );
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: primaryColor,
            ))
          : SingleChildScrollView(
              child: Container(
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
                      verticalSpace(35),
                      Center(
                        child: Text(
                          "SIGN IN",
                          style: text20w500(white),
                        ),
                      ),
                      verticalSpace(20),
                      Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email ID",
                                style: text16w600(white),
                              ),
                              verticalSpace(6),
                              TextFormField(
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val!)
                                      ? null
                                      : "Please enter a valid email!";
                                },
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: text18w500(black),
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
                              verticalSpace(27),
                              Text(
                                "Password",
                                style: text16w600(white),
                              ),
                              verticalSpace(6),
                              TextFormField(
                                validator: (val) {
                                  return RegExp(
                                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                          .hasMatch(val!)
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
                                    ),
                                  ),
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
                              verticalSpace(2),
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Text(
                                  "Forgot password?",
                                  style: text12w600(white),
                                ),
                              ),
                              verticalSpace(10),
                              // Row(
                              //   children: [
                              //     Checkbox(
                              //         side: BorderSide(color: white),
                              //         value: remember,
                              //         activeColor: primaryColor,
                              //         checkColor: black,
                              //         onChanged: (value) {
                              //           setState(() {
                              //             // remember == true
                              //             //     ? remember = false
                              //             //     : remember = true;
                              //           });
                              //         }),
                              //     Text(
                              //       "Remember me?",
                              //       style: text12w600(white),
                              //     ),
                              //   ],
                              // ),
                              verticalSpace(20),
                              ElevatedButton(
                                  onPressed: () {
                                    login();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(68)),
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width,
                                          71)),
                                  child: Text(
                                    "SIGN IN",
                                    style: text20w800(black),
                                  )),
                            ],
                          )),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: TextButton(
                          onPressed: () {
                            NextScreen(context, SignUp());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: text12w600(white),
                              ),
                              Text(
                                "Sign up",
                                style: text12w600(primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            NextScreen(context, PhoneAuthScreen());
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: transparentColor,
                              shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: white.withOpacity(.5)),
                                  borderRadius: BorderRadius.circular(68)),
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 71)),
                          child: Text(
                            "Sign in with Phone Number",
                            style: text16w600(white.withOpacity(.68)),
                          )),
                      verticalSpace(20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
