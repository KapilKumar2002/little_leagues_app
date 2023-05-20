import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/services/auth_service.dart';
import 'package:little_leagues/services/database_service.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:little_leagues/widgets/grouptile.dart';
import 'package:intl/intl.dart';

class AdminChatRoom extends StatefulWidget {
  const AdminChatRoom({super.key});

  @override
  State<AdminChatRoom> createState() => _AdminChatRoomState();
}

class _AdminChatRoomState extends State<AdminChatRoom> {
  // final user = FirebaseAuth.instance.currentUser;
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  void initState() {
    super.initState();
    // gettingUserData();
    getUserGroups();
  }

  gettingUserData() async {
    // getting the list of snapshots in our stream
    await DatabaseService(uid: adminUID).getUserGroups().then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  getUserGroups() async {
    final data = await DatabaseService().getGroups();
    setState(() {
      groups = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: transparentColor,
        foregroundColor: black,
        title: Text("Admin Chat Room"),
      ),
      body: groupList(),
    );
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data.docs != null) {
            if (snapshot.data.docs.length != 0) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data.docs.length - index - 1;

                  final DateTime dateTime = snapshot.data.docs[reverseIndex]
                              ['recentMessageTime'] !=
                          null
                      ? snapshot.data.docs[reverseIndex]['recentMessageTime']
                          .toDate()
                      : Timestamp.now().toDate();

                  final String recentTime =
                      DateFormat.Hm().format(dateTime).toString();

                  return GroupTile(
                      groupId: snapshot.data.docs[reverseIndex]['groupId'],
                      groupName: snapshot.data.docs[reverseIndex]['groupName'],
                      userName: "admin",
                      recentMessage: snapshot.data.docs[reverseIndex]
                          ['recentMessage'],
                      sender: snapshot.data.docs[reverseIndex]
                          ['recentMessageSender'],
                      recentTime: recentTime);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: const Text(
        "Users are not there!",
        textAlign: TextAlign.center,
      ),
    );
  }
}
