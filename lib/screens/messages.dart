import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';
import 'dart:math' as math;

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            verticalSpace(20),
            Container(
              height: height(context) - 250,
              child: ListView.builder(
                itemCount: 8,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: transparentColor,
                          backgroundImage: AssetImage("assets/profile.jpeg"),
                        ),
                        horizontalSpace(10),
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "Jayant",
                                  style: text18w500(white),
                                ),
                              ),
                              verticalSpace(15),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Color.fromARGB(255, 104, 103, 103),
                                ),
                                width: width(context) * .63,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                child: Text(
                                  "Can you send the file? ",
                                  style: text16w500(white),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: white, borderRadius: BorderRadius.circular(8)),
              height: 70,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.image_outlined,
                          color: bottomBarColor,
                          size: 30,
                        )),
                  ),
                  horizontalSpace(10),
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write a message....",
                        hintStyle: text18w500(Colors.grey.shade400)),
                  )),
                  Transform.rotate(
                    angle: 315 * math.pi / 180,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.send,
                          color: bottomBarColor,
                          size: 35,
                        )),
                  ),
                  horizontalSpace(20)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
