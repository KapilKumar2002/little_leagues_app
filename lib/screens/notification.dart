import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    color: white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.pink,
                          radius: 12,
                          child: Text(
                            "F",
                            style: text12w400(white),
                          ),
                        ),
                        horizontalSpace(10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Figma",
                                    style: text15w500(black),
                                  ),
                                  Text(
                                    "10:45 AM",
                                    style: text10w400(black.withOpacity(.4)),
                                  )
                                ],
                              ),
                              verticalSpace(8),
                              Text(
                                'Toni has invited you to view the file "Toni Hot Takes"',
                                style: text12w500(black.withOpacity(.7)),
                              ),
                              verticalSpace(10),
                              Text(
                                "Toni has invited you to view the file. Figma is the first design tool with real-time collaboration",
                                style: text12w400(
                                  black.withOpacity(.4),
                                ),
                              ),
                              verticalSpace(8),
                              index == 3
                                  ? Container(
                                      padding: EdgeInsets.only(right: 30),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey.shade100),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            child: Icon(
                                              Icons.text_snippet_outlined,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Resume.pdf",
                                                style: text12w500(
                                                    black.withOpacity(.65)),
                                              ),
                                              Text(
                                                "12kb",
                                                style: text10w400(
                                                    black.withOpacity(.5)),
                                              )
                                            ],
                                          )
                                        ],
                                      ))
                                  : verticalSpace(0)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
