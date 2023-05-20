import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:little_leagues/screens/bottomnav.dart';
import 'package:little_leagues/services/database_service.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:little_leagues/widgets/showsnackbar.dart';

class InfoScreen extends StatefulWidget {
  final int? phone;
  const InfoScreen({super.key, this.phone});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String? fullName;
  String? phone;
  String? email;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final user = FirebaseAuth.instance.currentUser;

  updateUserDate(BuildContext context) async {
    try {
      await userCollection.doc(user!.uid).update({
        "fullName": nameController.text,
        "phone": "+91${phoneController.text}",
        "email": emailController.text,
        "DOB": dobController.text,
        "address": addressController.text
      }).whenComplete(() async {
        if (widget.phone == 3) {
          final userData = await FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .get();
          final data = userData.data() as Map<String, dynamic>;

          if (data['groupId'] == "") {
            await DatabaseService(uid: user!.uid).createGroup(
              nameController.text,
              user!.uid,
            );
          }
        }
        NextScreen(context, BottomNav());
      });
    } catch (e) {
      openSnackbar(context, e.toString(), primaryColor);
    }
  }

  getUserData() async {
    try {
      final userData = await userCollection.doc(user!.uid).get();
      final data = userData.data() as Map<String, dynamic>;
      setState(() {
        fullName = data['fullName'];
        email = data['email'];
        nameController.text = data['fullName'];
        emailController.text = data['email'];
        dobController.text = data['DOB'];
        addressController.text = data['address'];
      });
      if (data['phone'].toString().isNotEmpty) {
        setState(() {
          phone = data['phone'];
          phoneController.text = data['phone'].toString().substring(3, 13);
        });
      }
    } catch (e) {
      openSnackbar(context, e.toString(), primaryColor);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    addressController.text =
        "${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
    setState(() {});
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1990),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        dobController.text =
            DateFormat('dd/MMM/yyyy').format(value!).toString();
      });
    });
  }

  validate() {
    if (formKey.currentState!.validate()) {
      updateUserDate(context);
    }
  }

  @override
  void initState() {
    getUserData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: black,
        body: SingleChildScrollView(
          child: Column(children: [
            verticalSpace(50),
            Container(
              child: Text(
                "My Info & Settings",
                style: text18w500(white2),
              ),
            ),
            verticalSpace(20),
            Center(
              child: Container(
                height: 80,
                width: 80,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade300,
                      child: Icon(
                        Icons.person_outline_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Icon(
                          Icons.edit,
                          color: white,
                        ))
                  ],
                ),
              ),
            ),
            verticalSpace(20),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                      readOnly: fullName.toString().isNotEmpty ? true : false,
                      style: text18w500(black),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 27, vertical: 22),
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
                      readOnly: phone == null ? false : true,
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 27, vertical: 22),
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
                    verticalSpace(5),
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
                      readOnly: email.toString().isNotEmpty ? true : false,
                      style: text18w500(black),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 27, vertical: 22),
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
                      "Date of Birth",
                      style: text16w600(white),
                    ),
                    verticalSpace(6),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field is required!';
                        }
                        // Return null if the entered username is valid
                        return null;
                      },
                      readOnly: true,
                      controller: dobController,
                      style: text18w500(black),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              _showDatePicker();
                            },
                            icon: Icon(
                              Icons.calendar_month,
                              color: Colors.black,
                            )),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 27, vertical: 22),
                        hintText: "Enter your D.O.B.",
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
                      "Address",
                      style: text16w600(white),
                    ),
                    verticalSpace(6),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field is required!';
                        }
                        if (value.trim().length < 10) {
                          return 'Address must be at least 10 characters in length!';
                        }
                        // Return null if the entered username is valid
                        return null;
                      },
                      readOnly: true,
                      minLines: 1,
                      maxLines: 2,
                      controller: addressController,
                      style: text18w500(black),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () async {
                              Position position = await _determinePosition();

                              GetAddressFromLatLong(position);
                            },
                            icon: Icon(
                              Icons.location_searching_rounded,
                              color: Colors.black,
                            )),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 27, vertical: 22),
                        hintText: "Enter your Address",
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
                                borderRadius: BorderRadius.circular(68)),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 71)),
                        child: Text(
                          "Update",
                          style: text20w800(black),
                        )),
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}
