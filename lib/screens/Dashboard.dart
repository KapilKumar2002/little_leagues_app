import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/messages.dart';
import 'package:little_leagues/screens/payment/getpaymentinfo.dart';
import 'package:little_leagues/screens/shop/yourcart.dart';
import 'package:little_leagues/services/database_service.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:little_leagues/widgets/showsnackbar.dart';
import 'package:http/http.dart' as http;

// import 'package:flutter_charts/flutter_charts.dart' as charts;
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DashboardPage extends StatefulWidget {
  final String profilePic;
  final String username;
  final String id;
  const DashboardPage(this.username, this.id, this.profilePic);
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  String groupId = "";
  String fullName = "";
  String institution = "";

  giveId() async {
    if (widget.id != null) {
      final userCollection = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.id)
          .get();
      final data = userCollection.data() as Map<String, dynamic>;

      fullName = data['fullName'];

      groupId = data['groupId'];
      institution = data['institution'];
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    giveId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      floatingActionButton: Container(
        height: 68,
        width: 68,
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            NextScreen(
                context,
                MessagePage(
                    groupId: groupId,
                    groupName:
                        FirebaseAuth.instance.currentUser!.uid.toString() +
                            fullName,
                    userName: fullName,
                    height: height(context) - 50));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/headp.png"),
          ),
        ),
      ),
      backgroundColor: black,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: white2,
                          backgroundImage: widget.profilePic.isNotEmpty
                              ? NetworkImage(widget.profilePic)
                              : null,
                        ),
                        horizontalSpace(15),
                        Text(
                          'Hello, ${widget.username}',
                          style: text15w500(white),
                        )
                      ],
                    ),
                    verticalSpace(15),
                    Row(
                      children: [
                        Text(
                          'Institution :',
                          style: text15w500(white),
                        ),
                        horizontalSpace(7),
                        Text(
                          institution.toString(),
                          style: text15w500(white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              TabBar(
                  labelColor: white2,
                  unselectedLabelColor: white,
                  controller: tabController,
                  tabs: [
                    Tab(
                      text: "My Classes",
                    ),
                    Tab(
                      text: "Other Classes",
                    ),
                  ]),
              verticalSpace(20),
              Container(
                height: height(context) - 330,
                child: TabBarView(
                  children: [
                    CurrentClasses(
                      id: widget.id,
                    ),
                    OtherClasses(
                      id: widget.id,
                      institution: institution,
                    )
                  ],
                  controller: tabController,
                ),
              )
              // verticalSpace(20),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 15),
              //   height: 80,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(
              //             "19",
              //             style: text15w500(primaryColor),
              //           ),
              //           Text(
              //             "Challenges\ncompleted",
              //             style: text14w500(white),
              //           )
              //         ],
              //       ),
              //       Container(width: 1.5, color: Colors.grey),
              //       Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(
              //             "19",
              //             style: text15w500(primaryColor),
              //           ),
              //           Text(
              //             "Challenges\ncompleted",
              //             style: text14w500(white),
              //           )
              //         ],
              //       ),
              //       Container(
              //         width: 1.5,
              //         color: Colors.grey,
              //       ),
              //       Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(
              //             "19",
              //             style: text15w500(primaryColor),
              //           ),
              //           Text(
              //             "Challenges\ncompleted",
              //             style: text14w500(white),
              //           )
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // verticalSpace(20),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              //   decoration: BoxDecoration(
              //       color: Color.fromARGB(255, 77, 76, 76),
              //       borderRadius: BorderRadius.circular(15),
              //       boxShadow: [
              //         BoxShadow(
              //             color: Color.fromARGB(255, 77, 76, 76),
              //             spreadRadius: 0,
              //             blurRadius: 10,
              //             blurStyle: BlurStyle.solid)
              //       ]),
              //   width: width(context),
              //   child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Chess Playing",
              //               style: text15w500(white),
              //             ),
              //             Text(
              //               "75% Completed",
              //               style: text12w400(white),
              //             ),
              //             verticalSpace(4),
              //             Container(
              //                 width: width(context) - 200,
              //                 child: LinearPercentIndicator(
              //                   lineHeight: 3,
              //                   barRadius: Radius.circular(2),
              //                   percent: .76,
              //                   progressColor: primaryColor,
              //                   backgroundColor: white,
              //                   padding: EdgeInsets.zero,
              //                 ))
              //           ],
              //         ),
              //         Container(
              //           decoration: BoxDecoration(
              //               color: black,
              //               borderRadius: BorderRadius.circular(
              //                 18,
              //               )),
              //           height: 35,
              //           width: 120,
              //           child: Center(
              //             child: Text(
              //               "Continue",
              //               style: text16w500(primaryColor),
              //             ),
              //           ),
              //         )
              //       ]),
              // ),
              // verticalSpace(30),
              // Padding(
              //   padding: const EdgeInsets.only(left: 15),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Today Activity",
              //         style: text15w500(white),
              //       ),
              //       verticalSpace(5),
              //       Text(
              //         "2 hours",
              //         style: text12w400(white),
              //       ),
              //     ],
              //   ),
              // ),
              // verticalSpace(15),
              // Container(
              //   height: 200,
              //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              //   decoration: BoxDecoration(
              //       color: Color.fromARGB(255, 77, 76, 76),
              //       borderRadius: BorderRadius.circular(15),
              //       boxShadow: [
              //         BoxShadow(
              //             color: Color.fromARGB(255, 77, 76, 76),
              //             spreadRadius: 0,
              //             blurRadius: 10,
              //             blurStyle: BlurStyle.solid)
              //       ]),
              //   width: width(context),
              //   child: Center(
              //     child: Container(
              //       child: SfCartesianChart(
              //         plotAreaBorderWidth: 0,
              //         primaryYAxis: NumericAxis(
              //             placeLabelsNearAxisLine: false,
              //             majorGridLines: const MajorGridLines(
              //                 width: 1, color: Colors.grey),
              //             axisLine: const AxisLine(
              //                 width: 1, color: Colors.transparent)),
              //         primaryXAxis: CategoryAxis(
              //           isVisible: false,
              //           majorGridLines:
              //               const MajorGridLines(width: 0, color: Colors.grey),
              //           axisLine: const AxisLine(width: 0, color: Colors.black),
              //         ),
              //         tooltipBehavior: TooltipBehavior(enable: true),
              //         series: <ChartSeries>[
              //           // HistogramSeries<ChartData1, double>(
              //           //     dataSource: histogramData,
              //           //     showNormalDistributionCurve: true,
              //           //     curveColor: transparentColor,
              //           //     binInterval: 1.5,
              //           //     color: primaryColor.withOpacity(.8),
              //           //     width: 1,
              //           //     spacing: 2,
              //           //     yValueMapper: (ChartData1 data, _) => data.y),
              //           StackedColumn100Series<ChartData1, String>(
              //             color: primaryColor,
              //             width: 1,
              //             spacing: 0.01,
              //             dataSource: histogramData,
              //             xValueMapper: (ChartData1 sales, _) => sales.x,
              //             yValueMapper: (ChartData1 sales, _) => sales.y,
              //             name: 'Sales',
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // verticalSpace(25),
              // Padding(
              //   padding: const EdgeInsets.only(left: 15),
              //   child: Text(
              //     "Explore Activities",
              //     style: text15w500(white),
              //   ),
              // ),
              // verticalSpace(25),
              // Container(
              //   height: 180,
              //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              //   decoration: BoxDecoration(
              //       color: Color.fromARGB(255, 46, 45, 45),
              //       borderRadius: BorderRadius.circular(15),
              //       boxShadow: [
              //         BoxShadow(
              //             color: Color.fromARGB(255, 77, 76, 76),
              //             spreadRadius: 0,
              //             blurRadius: 4,
              //             blurStyle: BlurStyle.solid)
              //       ]),
              //   width: width(context),
              // ),
              // verticalSpace(25)
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentClasses extends StatefulWidget {
  final String id;
  const CurrentClasses({super.key, required this.id});

  @override
  State<CurrentClasses> createState() => _CurrentClassesState();
}

class _CurrentClassesState extends State<CurrentClasses> {
  Stream? stream;
  // final user = FirebaseAuth.instance.currentUser;
  getClasses() async {
    DatabaseService(uid: widget.id).getRegClasses().then((value) {
      setState(() {
        stream = value;
      });
    });
  }

  int toDateNumber = 0;
  @override
  void initState() {
    // TODO: implement initState
    toDateNumber = dateNumber(DateTime.now());
    getClasses();
    super.initState();
  }

  int dateNumber(DateTime date) {
    String month = date.month.toString();
    String day = date.day.toString();
    String year = date.year.toString();
    if (day.length == 1) {
      day = "0" + day;
    }
    int finalDate = int.parse(month + day + year);
    return finalDate;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DateTime dateTime = snapshot
                                  .data.docs[index]['next_pay_date']
                                  .toDate() ??
                              DateTime.now();
                          String date = DateFormat.yMd().format(dateTime);
                          return dateNumber(dateTime) >= toDateNumber
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
                                            Text(
                                              snapshot.data.docs[index]
                                                  ['class_desc'],
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
                                                  shrinkWrap: true,
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
                                            verticalSpace(7),
                                            dateNumber(dateTime) <=
                                                    dateNumber(DateTime.now()
                                                        .add(Duration(days: 5)))
                                                ? Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          NextScreen(
                                                              context,
                                                              GetPaymentInfo(
                                                                  product: [
                                                                    {
                                                                      "type":
                                                                          "installment",
                                                                      "id": snapshot
                                                                          .data
                                                                          .docs[index]['class_id'],
                                                                      "date": snapshot
                                                                          .data
                                                                          .docs[index]['next_pay_date']
                                                                    }
                                                                  ],
                                                                  amount: snapshot
                                                                      .data
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'price']
                                                                      .toString()));
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 12),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 7),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color:
                                                                  primaryColor),
                                                          child: Text(
                                                            "Pay Now",
                                                            style: text14w700(
                                                                black),
                                                          ),
                                                        ),
                                                      ),
                                                      horizontalSpace(20),
                                                      Text(
                                                        "\u20B9 ${snapshot.data.docs[index]['price']}",
                                                        style:
                                                            text12w500(white2),
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Next payment date",
                                                        style: text12w500(
                                                            primaryColor),
                                                      ),
                                                      Text(
                                                        date,
                                                        style: text10w400(
                                                            Colors.red),
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
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
              })),
    );
  }
}

class OtherClasses extends StatefulWidget {
  final String institution;
  final String id;
  const OtherClasses({super.key, required this.id, required this.institution});

  @override
  State<OtherClasses> createState() => _OtherClassesState();
}

class _OtherClassesState extends State<OtherClasses> {
  Stream? stream;
  QuerySnapshot? snap;
  List<String> enrolledClass = [];
  // final user = FirebaseAuth.instance.currentUser;

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
    return StreamBuilder(
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
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var id = snapshot.data.docs[index]['class_id'];
                  return enrolledClass.contains(id)
                      ? horizontalSpace(0)
                      : Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: white2, blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: backgroundColor),
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(color: white2, blurRadius: 1)
                                    ]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
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
                                      imageUrl: snapshot.data.docs[index]
                                          ['class_image'],
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                ),
                              ),
                              horizontalSpace(15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data.docs[index]['class_name'],
                                      style: text15w500(white2),
                                    ),
                                    Text(
                                      snapshot.data.docs[index]['class_desc'],
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
                                          snapshot.data.docs[index]['end_time'],
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
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, i) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              padding: EdgeInsets.all(4),
                                              child: Text(
                                                snapshot.data.docs[index]
                                                    ['class_days'][i],
                                                style: text10w800(black),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return horizontalSpace(10);
                                          },
                                          itemCount: snapshot
                                              .data
                                              .docs[index]['class_days']
                                              .length),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
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
                                        //               "id": snapshot
                                        //                       .data.docs[index]
                                        //                   ['class_id']
                                        //             }
                                        //           ],
                                        //         ));
                                        //   },
                                        //   child: Container(
                                        //     margin: EdgeInsets.only(top: 12),
                                        //     padding: EdgeInsets.symmetric(
                                        //         horizontal: 12, vertical: 7),
                                        //     decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(5),
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
                                                .addClassToCart(snapshot.data
                                                    .docs[index]['class_id']);
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
                                            margin: EdgeInsets.only(top: 12),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 7, vertical: 7),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: primaryColor),
                                            child: Text(
                                              "Add to Cart",
                                              style: text14w700(black),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "\u20b9 " +
                                              snapshot.data.docs[index]['price']
                                                  .toString(),
                                          style: text12w500(white2),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ));
                },
              )
            : Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
      },
    );
  }
}
