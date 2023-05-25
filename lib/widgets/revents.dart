import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:intl/intl.dart';

class RegisteredEvents extends StatefulWidget {
  const RegisteredEvents({super.key});

  @override
  State<RegisteredEvents> createState() => _RegisteredEventsState();
}

class _RegisteredEventsState extends State<RegisteredEvents>
    with TickerProviderStateMixin {
  String day = DateFormat.E().format(DateTime.now());
  Stream? stream;
  final user = FirebaseAuth.instance.currentUser;
  getRegisteredEvents() async {
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("enrolled_classes")
        .snapshots();
    setState(() {
      stream = data;
    });
  }

  String? selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    getRegisteredEvents();
    super.initState();
  }

  final CalendarWeekController _controller = CalendarWeekController();
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 6, vsync: this);

    return SingleChildScrollView(
      child: Column(children: [
        Container(
            width: width(context),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1)
            ]),
            child: CalendarWeek(
              backgroundColor: transparentColor,
              controller: _controller,
              todayBackgroundColor: white,
              todayDateStyle: text15w500(Colors.red),
              weekendsStyle: TextStyle(color: primaryColor),
              dayOfWeekStyle: TextStyle(color: primaryColor),
              pressedDateStyle: TextStyle(color: black),
              pressedDateBackgroundColor: white2,
              dateStyle: TextStyle(color: primaryColor),
              dayOfWeek: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
              height: 100,
              showMonth: true,
              minDate: DateTime.now().add(
                Duration(days: -365),
              ),
              maxDate: DateTime.now().add(
                Duration(days: 365),
              ),
              onDatePressed: (DateTime datetime) {
                selectedDate = DateFormat.yMd().format(datetime);
                // Do something

                setState(() {
                  day = DateFormat.E().format(datetime);
                });
              },
              onDateLongPressed: (DateTime datetime) {
                // Do something
              },
              onWeekChanged: () {
                // Do something
              },
              monthViewBuilder: (DateTime time) => Align(
                alignment: FractionalOffset.center,
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMM().format(time),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    )),
              ),
              decorations: [
                DecorationItem(
                    decorationAlignment: FractionalOffset.bottomRight,
                    date: DateTime.now(),
                    decoration: Icon(
                      Icons.today,
                      color: Colors.orange,
                    )),
                // DecorationItem(
                //     date: DateTime.now().add(Duration(days: 3)),
                //     decoration: Text(
                //       'Holiday',
                //       style: TextStyle(
                //         color: Colors.brown,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     )),
              ],
            )),
        verticalSpace(15),
        StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return snapshot.data.docs[index]['class_days']
                              .contains(day)
                          ? Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: white2, blurRadius: 1)
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: backgroundColor),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                              color: white2, blurRadius: 1)
                                        ]),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: 75,
                                        height: 75,
                                        child: Image.network(
                                          snapshot.data.docs[index]
                                              ['class_image'],
                                          fit: BoxFit.fill,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: white.withOpacity(.6),
                                              child: Center(
                                                child: Icon(
                                                    Icons.image_search_rounded),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  horizontalSpace(15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data.docs[index]
                                              ['class_name'],
                                          style: text15w500(white2),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Start time",
                                              style: text14w500(white2),
                                            ),
                                            Text(
                                              snapshot.data.docs[index]
                                                  ['start_time'],
                                              style: text12w400(white),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "End time",
                                              style: text14w500(white2),
                                            ),
                                            Text(
                                              snapshot.data.docs[index]
                                                  ['end_time'],
                                              style: text12w400(white),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ))
                          : horizontalSpace(0);
                    },
                  )
                : Center(
                    child: Text(
                      "data",
                      style: text15w400(white2),
                    ),
                  );
          },
        )
      ]),
    );
  }
}
