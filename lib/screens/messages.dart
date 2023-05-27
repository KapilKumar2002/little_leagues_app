import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:little_leagues/services/database_service.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:little_leagues/widgets/messagetile.dart';
import 'package:uuid/uuid.dart';

class MessagePage extends StatefulWidget {
  final String? token;
  final String groupId;
  final String? groupName;
  final String? userName;
  final double? height;
  const MessagePage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName,
      required this.height,
      this.token})
      : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        .child('chat_images')
        .child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      if (imageUrl != "") {
        Map<String, dynamic> chatMessageMap = {
          "message": imageUrl,
          "sender": widget.userName,
          "time": FieldValue.serverTimestamp(),
          "type": "img",
        };

        DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      }
    }
  }

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: <Widget>[
          // chat messages here
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                  color: white, borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Image.asset(
                        "assets/pic.png",
                        height: 38,
                      )),
                ),
                horizontalSpace(10),
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write Something",
                      hintStyle: text18w500(Colors.grey.shade400)),
                )),
                horizontalSpace(20),
                Transform.rotate(
                  angle: 315 * math.pi / 180,
                  child: IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(
                        Icons.send,
                        color: bottomBarColor,
                        size: 35,
                      )),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Container(
                height: widget.height,
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    final DateTime dateTime = fromJson(
                        snapshot.data.docs[index]['time'] != null
                            ? snapshot.data.docs[index]['time']
                            : Timestamp.now());

                    final String date = DateFormat.yMMMd().format(dateTime);

                    return widget.token != "admin"
                        ? date == DateFormat.yMMMd().format(DateTime.now())
                            ? MessageTile(
                                message: snapshot.data.docs[index]['message'],
                                sender: snapshot.data.docs[index]['sender'],
                                type: snapshot.data.docs[index]['type'],
                                time: dateTime,
                                sentByMe: widget.userName ==
                                    snapshot.data.docs[index]['sender'])
                            : Container()
                        : MessageTile(
                            message: snapshot.data.docs[index]['message'],
                            sender: snapshot.data.docs[index]['sender'],
                            type: snapshot.data.docs[index]['type'],
                            time: dateTime,
                            sentByMe: widget.userName ==
                                snapshot.data.docs[index]['sender']);
                  },
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                color: primaryColor,
              ));
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": FieldValue.serverTimestamp(),
        "type": "text",
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
