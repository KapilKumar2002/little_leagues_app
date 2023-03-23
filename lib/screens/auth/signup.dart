import 'package:flutter/material.dart';
import 'package:little_leagues/screens/auth/signin.dart';
import 'package:little_leagues/utils/constants.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 200,
                    child: Center(child: Image.asset("assets/logo.png"))),
                Center(
                  child: Text(
                    "SIGN UP",
                    style: text25Bold(white),
                  ),
                ),
                verticalSpace(25),
                Text(
                  "Name",
                  style: text18w500(white),
                ),
                verticalSpace(7),
                TextFormField(
                  style: text18w500(black),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    hintText: "Enter your Name",
                    filled: true,
                    hintStyle: text18w500(Colors.grey.shade600),
                    fillColor: Color.fromARGB(255, 204, 201, 201),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0)),
                  ),
                ),
                verticalSpace(25),
                Text(
                  "Email ID",
                  style: text18w500(white),
                ),
                verticalSpace(7),
                TextFormField(
                  style: text18w500(black),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    hintText: "Enter your Email ID",
                    filled: true,
                    hintStyle: text18w500(Colors.grey.shade600),
                    fillColor: Color.fromARGB(255, 204, 201, 201),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0)),
                  ),
                ),
                verticalSpace(25),
                Text(
                  "Password",
                  style: text18w500(white),
                ),
                verticalSpace(7),
                TextFormField(
                  style: text18w500(black),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    hintText: "Enter your Password",
                    filled: true,
                    hintStyle: text18w500(Colors.grey.shade600),
                    fillColor: Color.fromARGB(255, 204, 201, 201),
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
                    style: text12w400(white),
                  ),
                ),
                verticalSpace(40),
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
                            Size(MediaQuery.of(context).size.width, 65)),
                    child: Text(
                      "SIGN UP",
                      style: text25Bold(black),
                    )),
                verticalSpace(4),
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
                        style: text14w500(white),
                      ),
                      Text(
                        "Login",
                        style: text14w500(primaryColor),
                      ),
                    ],
                  ),
                ),
                verticalSpace(40)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
