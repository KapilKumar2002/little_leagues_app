import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:little_leagues/screens/shop/yourcart.dart';
import 'package:little_leagues/services/database_service.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:little_leagues/widgets/showsnackbar.dart';

class OtherEvents extends StatefulWidget {
  final String id;
  final String institution;
  const OtherEvents({super.key, required this.id, required this.institution});

  @override
  State<OtherEvents> createState() => _OtherEventsState();
}

class _OtherEventsState extends State<OtherEvents>
    with TickerProviderStateMixin {
  String day = DateFormat.E().format(DateTime.now());
  Stream? stream;
  QuerySnapshot? snap;
  // final user = FirebaseAuth.instance.currentUser;
  List<String> enrolledClass = [];
  final CalendarWeekController _controller = CalendarWeekController();
  DateTime dateTime = DateTime.now();

  getEnrolledClasses() {
    enrolledClass = [];
    DatabaseService(uid: widget.id).getSnap().then((value) {
      if (mounted) {
        setState(() {
          snap = value;
        });
      }
    });
  }

  getClasses() {
    DatabaseService().getClasses(widget.institution).then((value) {
      setState(() {
        stream = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getClasses();
    getEnrolledClasses();
    super.initState();
  }

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
                setState(() {
                  day = DateFormat.E().format(datetime);
                });
              },
              onDateLongPressed: (DateTime datetime) {},
              onWeekChanged: () {},
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
                enrolledClass.add(snap!.docs[i].id);
              }
            }
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var id = snapshot.data.docs[index]["class_id"];
                      var days = snapshot.data.docs[index]['class_days'];
                      return enrolledClass.contains(id)
                          ? horizontalSpace(0)
                          : days.contains(day)
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
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  color: backgroundColor,
                                                );
                                              },
                                              imageUrl: snapshot.data
                                                  .docs[index]['class_image'],
                                              height: 60,
                                              width: 60,
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
                                            Text(
                                              "Class Days",
                                              style: text14w400(primaryColor),
                                            ),
                                            verticalSpace(4),
                                            Container(
                                              height: 20,
                                              child: ListView.separated(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (context, i) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4)),
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      child: Text(
                                                        snapshot.data
                                                                .docs[index]
                                                            ['class_days'][i],
                                                        style:
                                                            text10w800(black),
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return horizontalSpace(10);
                                                  },
                                                  itemCount: snapshot
                                                      .data
                                                      .docs[index]['class_days']
                                                      .length),
                                            ),
                                            // InkWell(
                                            //   onTap: () {
                                            //     NextScreen(
                                            //         context,
                                            //         PaymentPage(
                                            //           userId: widget.id,
                                            //           totalPrice: snapshot.data
                                            //               .docs[index]['price'],
                                            //           productList: [
                                            //             {
                                            //               'item': "class",
                                            //               "id": snapshot.data
                                            //                       .docs[index]
                                            //                   ['class_id']
                                            //             }
                                            //           ],
                                            //         ));
                                            //   },
                                            //   child: Container(
                                            //     margin:
                                            //         EdgeInsets.only(top: 12),
                                            //     padding: EdgeInsets.symmetric(
                                            //         horizontal: 12,
                                            //         vertical: 7),
                                            //     decoration: BoxDecoration(
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //                 5),
                                            //         color: primaryColor),
                                            //     child: Text(
                                            //       "Join Now",
                                            //       style: text14w700(black),
                                            //     ),
                                            //   ),
                                            // ),
                                            // horizontalSpace(7),
                                            InkWell(
                                              onTap: () {
                                                DatabaseService(uid: widget.id)
                                                    .addClassToCart(snapshot
                                                            .data.docs[index]
                                                        ['class_id']);
                                                openSnackbar(
                                                  context,
                                                  "Your class has been added to cart",
                                                  primaryColor,
                                                  label: "View",
                                                  onTap: () {
                                                    NextScreen(
                                                        context,
                                                        YourCart(
                                                          id: widget.id,
                                                        ));
                                                  },
                                                );
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 12),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 7, vertical: 7),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: primaryColor),
                                                child: Text(
                                                  "Add to Cart",
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
                : Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
          },
        )
      ]),
    );
  }
}
