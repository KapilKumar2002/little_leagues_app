import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/auth/signin.dart';
import 'package:little_leagues/screens/infoscreen.dart';
import 'package:little_leagues/screens/payment/orderhistory.dart';
import 'package:little_leagues/screens/payment/paymenthistory.dart';
import 'package:little_leagues/screens/shop/yourcart.dart';
import 'package:little_leagues/services/auth_service.dart';
import 'package:little_leagues/utils/constants.dart';

class CustomDrawer extends StatefulWidget {
  final String id;
  final String? image;
  const CustomDrawer({super.key, required this.id, required this.image});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? fullName;
  String? phoneNumber;
  String? email;
  getUserDetails() async {
    // final user = FirebaseAuth.instance.currentUser;
    final userCollection = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.id)
        .get();
    final data = userCollection.data() as Map<String, dynamic>;
    fullName = data['fullName'];
    phoneNumber = data['phone'].toString();
    email = data['email'];
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context),
      child: Stack(children: [
        Container(
          width: 250,
          height: height(context),
          color: primaryColor,
        ),
        Container(
          margin: EdgeInsets.only(top: 40),
          height: 150,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName ?? "",
                          style: text14w500(black),
                        ),
                        Text(
                          phoneNumber ?? "",
                          style: text12w500(black),
                        ),
                        Text(
                          email ?? "",
                          style: text12w400(black),
                        ),
                      ],
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 52,
                  backgroundColor: primaryColor,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: transparentColor,
                    backgroundImage: widget.image!.isNotEmpty
                        ? NetworkImage(widget.image!)
                        : null,
                  ),
                )
              ]),
        ),
        Container(
          margin: EdgeInsets.only(top: 150),
          width: width(context) * .7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    onTap: () {
                      NextScreen(
                          context,
                          InfoScreen(
                            id: widget.id,
                          ));
                    },
                    leading: Icon(
                      Icons.settings,
                      color: black,
                    ),
                    title: Text("My Info & Settings"),
                  ),
                  ListTile(
                    onTap: () {
                      NextScreen(
                          context,
                          PaymentHistory(
                            id: widget.id,
                          ));
                    },
                    leading: Icon(
                      Icons.payment,
                      color: black,
                    ),
                    title: Text("Payment History"),
                  ),
                  ListTile(
                    onTap: () {
                      NextScreen(
                          context, OrderHistoryPage(id: widget.id.toString()));
                    },
                    leading: Icon(
                      Icons.shopping_bag_rounded,
                      color: black,
                    ),
                    title: Text("Order History"),
                  ),
                  ListTile(
                    onTap: () {
                      NextScreen(
                          context,
                          YourCart(
                            id: widget.id,
                          ));
                    },
                    leading: Icon(
                      Icons.shopping_cart,
                      color: black,
                    ),
                    title: Text("My Cart"),
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  await AuthService().signOut(widget.id.toString());
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const SignIn()),
                      (route) => false);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 80),
                  height: 45,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundColor.withOpacity(.35)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: black,
                        ),
                        horizontalSpace(10),
                        Text(
                          "Logout",
                          style: text18w500(black),
                        )
                      ]),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
