import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        foregroundColor: white,
        automaticallyImplyLeading: false,
        backgroundColor: black,
        elevation: 0,
        title: Text(
          "Notification",
          style: text25Bold(white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {},
              child: Image.asset(
                "assets/search.png",
                width: 25,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    color: nColor,
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
                                    style: text16w500(white2),
                                  ),
                                  Text(
                                    "10:45 AM",
                                    style: text12w400(white2.withOpacity(.25)),
                                  )
                                ],
                              ),
                              verticalSpace(8),
                              Text(
                                'Toni has invited you to view the file "Toni Hot Takes"',
                                style: text12w500(white2.withOpacity(.2)),
                              ),
                              verticalSpace(10),
                              Text(
                                "Toni has invited you to view the file. Figma is the first design tool with real-time collaboration",
                                style: text12w400(
                                  white2.withOpacity(.5),
                                ),
                              ),
                              verticalSpace(8),
                              index == 3
                                  ? Container(
                                      padding: EdgeInsets.only(
                                          right: 30,
                                          top: 8,
                                          bottom: 8,
                                          left: 8),
                                      color: Color(0xFF3E3B3B),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            radius: 12,
                                            child: Icon(
                                              Icons.text_snippet_outlined,
                                              color: Colors.red,
                                              size: 10,
                                            ),
                                          ),
                                          horizontalSpace(12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Resume.pdf",
                                                style: text10w500(white2),
                                              ),
                                              Text("12kb",
                                                  style: text8w400(white2))
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
