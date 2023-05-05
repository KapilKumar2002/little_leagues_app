import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/helper/helper_function.dart';
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

  // saving the userdata
  Future savingUserData(String fullName, String email, String phone) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "address": "",
      "DOB": "",
      "lastSignout": "",
      "email": email,
      "phone": "${phone}",
      "groups": [],
      "profilePic": "",
      "groupId": "",
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

  getGroups() async {
    return groupCollection.orderBy("recentMessageTime").snapshots();
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
  // Future<bool> isUserJoined(
  //     String groupName, String groupId, String userName) async {
  //   DocumentReference userDocumentReference = userCollection.doc(uid);
  //   DocumentSnapshot documentSnapshot = await userDocumentReference.get();

  //   List<dynamic> groups = await documentSnapshot['groups'];
  //   if (groups.contains("${groupId}_$groupName")) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // toggling the group join/exit
  // Future toggleGroupJoin(
  //     String groupId, String userName, String groupName) async {
  //   // doc reference
  //   DocumentReference userDocumentReference = userCollection.doc(uid);
  //   DocumentReference groupDocumentReference = groupCollection.doc(groupId);

  //   DocumentSnapshot documentSnapshot = await userDocumentReference.get();
  //   List<dynamic> groups = await documentSnapshot['groups'];

  //   // if user has our groups -> then remove then or also in other part re join
  //   if (groups.contains("${groupId}_$groupName")) {
  //     await userDocumentReference.update({
  //       "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
  //     });
  //     await groupDocumentReference.update({
  //       "members": FieldValue.arrayRemove(["${uid}_$userName"])
  //     });
  //   } else {
  //     await userDocumentReference.update({
  //       "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
  //     });
  //     await groupDocumentReference.update({
  //       "members": FieldValue.arrayUnion(["${uid}_$userName"])
  //     });
  //   }
  // }

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