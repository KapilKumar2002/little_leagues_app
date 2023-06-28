import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:little_leagues/helper/helper_function.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:little_leagues/screens/bottomnav.dart';
import 'package:little_leagues/services/database_service.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:little_leagues/widgets/customdropdown.dart';
import 'package:little_leagues/widgets/showsnackbar.dart';
import 'package:uuid/uuid.dart';

class InfoScreen extends StatefulWidget {
  final String? id;
  final int? phone;
  const InfoScreen({super.key, this.phone, this.id});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final user = FirebaseAuth.instance.currentUser;
  static const List<String> institute = <String>[
    "Genexx Valley",
    "Madgul Antaraa",
  ];

  final key = GlobalKey<FormFieldState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final zipController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String? fullName;
  String? phone;
  String? email;
  String? city;
  String? state;
  String? institution = "Select institution";
  String? country;
  String? profilePic;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  // final user = FirebaseAuth.instance.currentUser;

  updateUserDate(BuildContext context) async {
    try {
      // if (institute != null &&
      //     city != null &&
      //     state != null &&
      //     country != null) {
      await userCollection.doc(widget.id).update({
        "fullName": nameController.text,
        "phone": "${phoneController.text}",
        // "phone": "+91${phoneController.text}",
        "email": emailController.text,
        "DOB": dobController.text,
        "address": addressController.text,
        "city": city,
        "state": state,
        "country": country,
        "zip_code": zipController.text,
        "institution": key.currentState!.value == null
            ? institution
            : key.currentState!.value
      }).whenComplete(() async {
        if (widget.phone == 3) {
          print(widget.phone);
          final userData = await FirebaseFirestore.instance
              .collection("users")
              .doc(widget.id)
              .get();
          final data = userData.data() as Map<String, dynamic>;

          if (data['groupId'] == "") {
            await DatabaseService(uid: widget.id).createGroup(
              nameController.text,
              widget.id.toString(),
            );
          }
          await HelperFunctions.saveUserLoggedInStatus(true);
        }
        NextScreen(
            context,
            BottomNav(
              id: widget.id,
            ));

        // final userExist =
        //     await DatabaseService(uid: widget.id).checkUserExists();
      });
    } catch (e) {
      openSnackbar(context, e.toString(), primaryColor);
    }
  }

  getUserData() async {
    try {
      final userData = await userCollection.doc(widget.id).get();
      final data = userData.data() as Map<String, dynamic>;
      setState(() {
        country = data['country'] ?? "";
        state = data['state'] ?? "";
        city = data['city'] ?? "";
        institution = data['institution'] ?? "";

        nameController.text = data['fullName'] ?? "";
        emailController.text = data['email'] ?? "";
        dobController.text = data['DOB'] ?? "";
        addressController.text = data['address'] ?? "";
        zipController.text = data['zip_code'] ?? "";
        profilePic = data['profilePic'];
      });
      if (data['phone'].toString().isNotEmpty) {
        setState(() {
          // phone = "+91${data['phone'] ?? 5555555555}";
          // phone = data['phone'] ?? 5555555555.toString();

          // phoneController.text = data['phone'].toString().substring(0, 10);
          phoneController.text = data['phone'].toString();
        });
      }
    } catch (e) {
      openSnackbar(context, e.toString(), primaryColor);
    }
  }

  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    var ref = FirebaseStorage.instance
        .ref()
        .child('profileImages')
        .child("${user!.uid}.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      status = 0;
    });

    if (status == 1) {
      profilePic = await uploadTask.ref.getDownloadURL();
      setState(() {});

      if (profilePic != "") {
        FirebaseFirestore.instance
            .collection("users")
            .doc(widget.id)
            .update({"profilePic": profilePic});
      }
    }
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
                        backgroundColor: white,
                        backgroundImage:
                            NetworkImage(profilePic ?? profileIcon)),
                    Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: Icon(
                            Icons.edit,
                            color: white,
                          ),
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
                      // readOnly: fullName.toString().isNotEmpty ? true : false,
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
                          return 'Phone number must be at least 10 characters in length!';
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
                      // readOnly: email.toString().isNotEmpty ? true : false,
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
                      keyboardType: TextInputType.text,
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
                    CSCPicker(
                      dropdownDialogRadius: 0,
                      disabledDropdownDecoration: BoxDecoration(
                          color: white, borderRadius: BorderRadius.circular(0)),
                      dropdownDecoration: BoxDecoration(
                          color: white, borderRadius: BorderRadius.circular(0)),
                      countryDropdownLabel: country ?? "Select Country",
                      cityDropdownLabel: city ?? "Select City",
                      stateDropdownLabel: state ?? "Selct State",
                      flagState: CountryFlag.DISABLE,
                      onCountryChanged: (value) {
                        setState(() {
                          country = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          state = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          city = value;
                        });
                      },
                    ),
                    verticalSpace(25),
                    Text(
                      "Institution",
                      style: text16w600(white),
                    ),
                    verticalSpace(6),
                    CustomDropDownField(
                        list: institute,
                        fieldKey: key,
                        hint: institution == ""
                            ? "Select institution"
                            : institution!),
                    verticalSpace(25),
                    Text(
                      "Zip Code",
                      style: text16w600(white),
                    ),
                    verticalSpace(6),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field is required!';
                        }
                        if (value.trim().length < 6) {
                          return 'Address must be at least 6 characters in length!';
                        }
                        // Return null if the entered username is valid
                        return null;
                      },
                      minLines: 1,
                      maxLines: 2,
                      controller: zipController,
                      style: text18w500(black),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 27, vertical: 22),
                        hintText: "Enter institution zip code",
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
                      minLines: 1,
                      maxLines: 2,
                      controller: addressController,
                      style: text18w500(black),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
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
