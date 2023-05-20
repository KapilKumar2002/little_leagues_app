import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/bottomnav.dart';
import 'package:little_leagues/screens/messages.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:flutter_charts/flutter_charts.dart' as charts;

class DashboardPage extends StatefulWidget {
  final String username;
  DashboardPage(this.username);
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;

  String groupId = "";
  String fullName = "";

  giveId() async {
    // print(user!.uid);
    if (user != null) {
      final userCollection = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();
      final data = userCollection.data() as Map<String, dynamic>;

      setState(() {
        fullName = data['fullName'];
      });

      setState(() {
        groupId = data['groupId'];
      });

      // print(groupId);
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    giveId();

    super.initState();
  }

  final List<ChartData1> histogramData = <ChartData1>[
    ChartData1("1", 80.5),
    ChartData1("2", 20.9),
    ChartData1("3", 30.6),
    ChartData1("4", 12.0),
    ChartData1("5", 85.5),
  ];

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
                          backgroundColor: transparentColor,
                          backgroundImage: AssetImage("assets/pim.jpg"),
                        ),
                        horizontalSpace(15),
                        Text(
                          'Hello, ${widget.username}',
                          style: text16w600(white),
                        )
                      ],
                    ),
                    verticalSpace(15),
                    Row(
                      children: [
                        Text(
                          'Apartment :',
                          style: text16w600(white),
                        ),
                        horizontalSpace(15),
                        Text(
                          'apartment name?',
                          style: text16w600(white),
                        )
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
                      text: "Current Classes",
                    ),
                    Tab(
                      text: "Other Classes",
                    ),
                  ]),
              verticalSpace(20),
              Container(
                height: height(context) - 330,
                child: TabBarView(
                  children: [CurrentClasses(), OtherClasses()],
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

class ChartData1 {
  ChartData1(
    this.x,
    this.y,
  );
  final double y;
  final String x;
}

class CurrentClasses extends StatefulWidget {
  const CurrentClasses({super.key});

  @override
  State<CurrentClasses> createState() => _CurrentClassesState();
}

class _CurrentClassesState extends State<CurrentClasses> {
  Stream? stream;
  final user = FirebaseAuth.instance.currentUser;
  getClasses() async {
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("enrolled_classes")
        .where("current", isEqualTo: true)
        .snapshots();
    setState(() {
      stream = data;
    });
  }

  updateEvents(String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("enrolled_classes")
        .doc(id)
        .update({"current": false});
  }

  @override
  void initState() {
    // TODO: implement initState
    getClasses();
    super.initState();
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
                        return Container(
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
                                        BoxShadow(color: white2, blurRadius: 1)
                                      ]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      snapshot.data.docs[index]['class_image'],
                                      fit: BoxFit.fill,
                                      width: 75,
                                      height: 75,
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
                                        snapshot.data.docs[index]['class_name'],
                                        style: text15w500(white2),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Start date",
                                            style: text14w500(white2),
                                          ),
                                          Text(
                                            snapshot.data.docs[index]
                                                ['start_date'],
                                            style: text12w400(white),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "End date",
                                            style: text14w500(white2),
                                          ),
                                          Text(
                                            snapshot.data.docs[index]
                                                ['end_date'],
                                            style: text12w400(white),
                                          )
                                        ],
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
                                      Text(
                                        "Class Days",
                                        style: text14w400(primaryColor),
                                      ),
                                      verticalSpace(4),
                                      Container(
                                        height: 20,
                                        child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, i) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
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
          )),
    );
  }
}

class OtherClasses extends StatefulWidget {
  const OtherClasses({super.key});

  @override
  State<OtherClasses> createState() => _OtherClassesState();
}

class _OtherClassesState extends State<OtherClasses> {
  Stream? stream;
  final user = FirebaseAuth.instance.currentUser;
  getClasses() async {
    final data =
        await FirebaseFirestore.instance.collection("classes").snapshots();
    setState(() {
      stream = data;
    });
  }

  joinClass(String id) async {
    final event =
        await FirebaseFirestore.instance.collection("classes").doc(id).get();
    final data = event.data() as Map<String, dynamic>;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("enrolled_classes")
        .doc(id)
        .set(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    getClasses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          boxShadow: [BoxShadow(color: white2, blurRadius: 1)],
                          borderRadius: BorderRadius.circular(10),
                          color: backgroundColor),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
                              child: Image.network(
                                snapshot.data.docs[index]['class_image'],
                                fit: BoxFit.fill,
                                width: 75,
                                height: 75,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Start date",
                                      style: text14w500(white2),
                                    ),
                                    Text(
                                      snapshot.data.docs[index]['start_date'],
                                      style: text12w400(white),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "End date",
                                      style: text14w500(white2),
                                    ),
                                    Text(
                                      snapshot.data.docs[index]['end_date'],
                                      style: text12w400(white),
                                    )
                                  ],
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
                                      snapshot.data.docs[index]['start_time'],
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
                                      itemCount: snapshot.data
                                          .docs[index]['class_days'].length),
                                ),
                                verticalSpace(10),
                                InkWell(
                                  onTap: () {
                                    joinClass(
                                        snapshot.data.docs[index]['class_id']);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 125,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: primaryColor),
                                    child: Center(
                                      child: Text(
                                        "Join Now",
                                        style:
                                            text16w600(black.withOpacity(.5)),
                                      ),
                                    ),
                                  ),
                                )
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
    ));
  }
}
