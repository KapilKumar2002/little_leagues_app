import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/bottomnav.dart';
import 'package:little_leagues/screens/infoscreen.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:little_leagues/widgets/showsnackbar.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection("category");
  final CollectionReference classCollection =
      FirebaseFirestore.instance.collection("classes");

  // saving the userdata
  Future savingUserData(String fullName, String email, String phone) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "address": "",
      "DOB": "",
      "city": "",
      "state": "",
      "zip_code": "",
      "institution": "",
      "lastSignout": "",
      "email": email,
      "phone": "${phone}",
      "groups": [],
      "events": [],
      "profilePic": "",
      "groupId": "",
      "country": "",
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  Future createGroup(String? userName, String id) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": userName,
      "groupIcon": "",
      "admin": adminUID,
      "groupId": "",
      "members": FieldValue.arrayUnion([adminUID]),
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference adminDocumentReference = userCollection.doc(adminUID);
    await adminDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$userName"])
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(
        ["${groupDocumentReference.id}_$userName"],
      ),
      "groupId": groupDocumentReference.id,
    });
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  getexports(String categoryid) async {
    return categoryCollection
        .doc(categoryid)
        .collection("most_explored_sports")
        .snapshots();
  }

  getallsports(String categoryid) async {
    return categoryCollection
        .doc(categoryid)
        .collection("all_sports")
        .snapshots();
  }

  getcarousel(String id) async {
    return categoryCollection
        .doc("n7H0jLmG0KalEBjVwLm8")
        .collection("most_explored_sports")
        .doc(id)
        .collection("carousel")
        .snapshots();
  }

  getGroups() async {
    return await groupCollection.orderBy("recentMessageTime").snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  // getGroupMembers(groupId) async {
  //   return groupCollection.doc(groupId).snapshots();
  // }

  // search
  // searchByName(String groupName) {
  //   return groupCollection.where("groupName", isEqualTo: groupName).get();
  // }

  // function -> bool
  Future<bool> isUserJoined(String eventId) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> classes = await documentSnapshot['classes'];
    if (classes.contains(eventId)) {
      return true;
    } else {
      return false;
    }
  }

  getUserClasses() async {
    return userCollection.doc(uid).snapshots();
  }

  // toggling the group join/exit
  Future toggleClassesJoined(String classId) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = classCollection.doc(classId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> classes = await documentSnapshot['classes'];

    // if user has our groups -> then remove then or also in other part re join
    if (classes.contains(classId)) {
      await userDocumentReference.update({
        "classes": FieldValue.arrayRemove([classId])
      });
    } else {
      await userDocumentReference.update({
        "classes": FieldValue.arrayUnion([classId])
      });
    }
  }

  getUserDataField(BuildContext context, {int? num}) async {
    try {
      final userData = await userCollection.doc(uid).get();
      final userDetails = userData.data();
      if (userDetails == null) {
        NextScreen(
            context,
            InfoScreen(
              phone: num,
            ));
      }
      {
        final data = userDetails as Map<String, dynamic>;
        if (data['fullName'] == "" ||
            data['email'] == "" ||
            data['phone'] == "" ||
            data['DOB'] == "" ||
            data['address'] == "") {
          NextScreen(
              context,
              InfoScreen(
                phone: num,
              ));
        } else {
          NextScreen(context, BottomNav());
          openSnackbar(context, "Logged In", primaryColor);
        }
      }
    } catch (e) {
      openSnackbar(context, e.toString(), primaryColor);
    }
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    await groupCollection
        .doc(groupId)
        .collection("messages")
        .add(chatMessageData);
    await groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'],
    });
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (snap.exists) {
      print("EXISTING USER");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }
}
