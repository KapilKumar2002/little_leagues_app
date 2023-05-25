import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:intl/intl.dart';

class OtherEvents extends StatefulWidget {
  const OtherEvents({super.key});

  @override
  State<OtherEvents> createState() => _OtherEventsState();
}

class _OtherEventsState extends State<OtherEvents>
    with TickerProviderStateMixin {
  String day = DateFormat.E().format(DateTime.now());
  Stream? stream;
  QuerySnapshot? snap;
  final user = FirebaseAuth.instance.currentUser;
  List<String> enrolledClass = [];

  joinClass(String id) async {
    final event =
        await FirebaseFirestore.instance.collection("classes").doc(id).get();
    final data = event.data() as Map<String, dynamic>;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("enrolled_classes")
        .doc(id)
        .set({
      "class_days": data['class_days'],
      "class_id": data['class_id'],
      "class_image": data['class_image'],
      "class_name": data['class_name'],
      "end_time": data['end_time'],
      "start_time": data['start_time'],
      "next_pay_date": DateFormat.yMd()
          .format(DateTime.now().add(Duration(days: 30)))
          .toString()
    });
  }

  getEnrolledClasses() async {
    enrolledClass = [];
    final enroll = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("enrolled_classes")
        .get();
    if (mounted) {
      setState(() {
        snap = enroll;
      });
    }
  }

  getClasses() async {
    final data =
        await FirebaseFirestore.instance.collection("classes").snapshots();
    setState(() {
      stream = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getClasses();
    getEnrolledClasses();
    super.initState();
  }

  final CalendarWeekController _controller = CalendarWeekController();

  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 6, vsync: this);

    return SingleChildScrollView(
      child: Column(children: [
        Container(
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
            getEnrolledClasses();
            if (snap != null) {
              for (int i = 0; i < snap!.docs.length; i++) {
                enrolledClass.add(snap!.docs[i]['class_id']);
              }
            }
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return enrolledClass
                              .contains(snapshot.data.docs[index]['class_id'])
                          ? horizontalSpace(0)
                          : snapshot.data.docs[index]['class_days']
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: white2, blurRadius: 1)
                                            ]),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                    child: Icon(Icons
                                                        .image_search_rounded),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                            InkWell(
                                              onTap: () {
                                                joinClass(snapshot.data
                                                    .docs[index]['class_id']);

                                                getEnrolledClasses();
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 12),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 7),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: primaryColor),
                                                child: Text(
                                                  "Join Now",
                                                  style: text14w700(black),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ))
                              : horizontalSpace(0);
                    },
                  )
                : CircularProgressIndicator();
          },
        )
      ]),
    );
  }
}
