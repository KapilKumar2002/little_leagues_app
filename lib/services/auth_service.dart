import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:little_leagues/helper/helper_function.dart';
import 'package:little_leagues/screens/bottomnav.dart';
import 'package:little_leagues/services/database_service.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:little_leagues/widgets/showsnackbar.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  // login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password, String phone) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();
        if (userData.data() == null) {
          await DatabaseService(uid: user.uid)
              .savingUserData(fullName, email, phone);
          await DatabaseService(uid: user.uid).createGroup(fullName, user.uid);
        }

        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      openSnackbar(context, "Verification Completed", primaryColor);
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      openSnackbar(context, exception.toString(), primaryColor);
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      openSnackbar(context, "Time out", primaryColor);
    };
    try {
      await firebaseAuth.verifyPhoneNumber(
          timeout: Duration(seconds: 30),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: (String? verificationId, int? resendToken) {
            openSnackbar(context, "Verification Code sent on the phone number",
                primaryColor);
            setData(verificationId);
          },
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      openSnackbar(context, e.toString(), primaryColor);
    }
  }

  Future signInwithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      if (userCredential != null) {
        final user = userCredential.user;

        bool decision = await DatabaseService(uid: user!.uid).checkUserExists();
        if (decision) {
          return true;
        } else {
          await DatabaseService(uid: user.uid)
              .savingUserData("", "", user.phoneNumber.toString());
        }
        return true;
      }
    } catch (e) {
      if (e == "Time out") {
      } else {
        openSnackbar(context, e.toString(), primaryColor);
      }
    }
  }

  // Google signin

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // executing our authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // signing to firebase user instance
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        if (userDetails != null) {
          final userData = await FirebaseFirestore.instance
              .collection("users")
              .doc(userDetails.uid)
              .get();

          if (userData.data() == null) {
            await DatabaseService(uid: userDetails.uid).savingUserData(
              userDetails.displayName.toString(),
              userDetails.email.toString(),
              "",
            );

            await DatabaseService(uid: userDetails.uid).createGroup(
              userDetails.displayName.toString(),
              userDetails.uid,
            );
          }

          return true;
        }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            break;

          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
        }
      }
    } else {
      _hasError = true;
    }
  }

  Future signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']);
    // getting the profile
    final graphResponse = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${loginResult.accessToken!.token}'));

    final profile = jsonDecode(graphResponse.body);

    if (loginResult.status == LoginStatus.success) {
      try {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        await firebaseAuth.signInWithCredential(facebookAuthCredential);

        final user = FirebaseAuth.instance.currentUser;
        final userData = await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .get();
        if (userData.data() == null) {
          await DatabaseService(uid: user.uid).savingUserData(
              profile['name'].toString(), profile['email'].toString(), "");

          await DatabaseService(uid: user.uid)
              .createGroup(profile['name'], user.uid);
        }

        return true;
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";

            _hasError = true;
            break;

          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
        }
      }
    } else {
      _hasError = true;
    }
  }

  // signout
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await FacebookAuth.instance.logOut();
      await firebaseAuth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      return null;
    }
  }
}
