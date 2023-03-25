import 'package:flutter/material.dart';
import 'package:little_leagues/model/bar_model.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:flutter_charts/flutter_charts.dart' as charts;

class DashboardPage extends StatelessWidget {
  List<BarModel> data = [
    BarModel('2', 35),
    BarModel('3', 28),
    BarModel('6', 34),
    BarModel('9', 32),
    BarModel('11', 40)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "19",
                          style: text15w500(primaryColor),
                        ),
                        Text(
                          "Challenges\ncompleted",
                          style: text14w500(white),
                        )
                      ],
                    ),
                    Container(width: 1.5, color: Colors.grey),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "19",
                          style: text15w500(primaryColor),
                        ),
                        Text(
                          "Challenges\ncompleted",
                          style: text14w500(white),
                        )
                      ],
                    ),
                    Container(
                      width: 1.5,
                      color: Colors.grey,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "19",
                          style: text15w500(primaryColor),
                        ),
                        Text(
                          "Challenges\ncompleted",
                          style: text14w500(white),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              verticalSpace(20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 77, 76, 76),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 77, 76, 76),
                          spreadRadius: 0,
                          blurRadius: 10,
                          blurStyle: BlurStyle.solid)
                    ]),
                width: width(context),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chess Playing",
                            style: text15w500(white),
                          ),
                          Text(
                            "75% Completed",
                            style: text12w400(white),
                          ),
                          verticalSpace(4),
                          Container(
                              width: width(context) - 200,
                              child: LinearPercentIndicator(
                                lineHeight: 3,
                                barRadius: Radius.circular(2),
                                percent: .76,
                                progressColor: primaryColor,
                                backgroundColor: white,
                                padding: EdgeInsets.zero,
                              ))
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(
                              18,
                            )),
                        height: 35,
                        width: 120,
                        child: Center(
                          child: Text(
                            "Continue",
                            style: text16w500(primaryColor),
                          ),
                        ),
                      )
                    ]),
              ),
              verticalSpace(30),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today Activity",
                      style: text15w500(white),
                    ),
                    verticalSpace(5),
                    Text(
                      "2 hours",
                      style: text12w400(white),
                    ),
                  ],
                ),
              ),
              verticalSpace(15),
              Container(
                height: 180,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 77, 76, 76),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 77, 76, 76),
                          spreadRadius: 0,
                          blurRadius: 10,
                          blurStyle: BlurStyle.solid)
                    ]),
                width: width(context),
                // child: SfCartesianChart(
                //     plotAreaBorderWidth: 0,
                //     primaryYAxis: NumericAxis(
                //         majorGridLines: const MajorGridLines(width: 0),
                //         axisLine: const AxisLine(width: 0)),
                //     primaryXAxis: CategoryAxis(
                //       majorGridLines: const MajorGridLines(width: 0),
                //       axisLine: const AxisLine(width: 0),
                //     ),
                //     // Enable tooltip
                //     tooltipBehavior: TooltipBehavior(enable: true),
                //     series: <ChartSeries<BarModel, String>>[
                //       StackedColumn100Series<BarModel, String>(
                //         dataSource: data,
                //         xValueMapper: (BarModel sales, _) => sales.Day,
                //         yValueMapper: (BarModel sales, _) => sales.value,
                //         name: 'Sales',
                //       ),
                //       StackedColumn100Series<BarModel, String>(
                //         dataSource: data,
                //         xValueMapper: (BarModel sales, _) => sales.Day,
                //         yValueMapper: (BarModel sales, _) => sales.value,
                //         name: 'Sales',
                //       ),
                //     ]),
              ),
              verticalSpace(25),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Explore Activities",
                  style: text15w500(white),
                ),
              ),
              verticalSpace(25),
              Container(
                height: 180,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 46, 45, 45),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 77, 76, 76),
                          spreadRadius: 0,
                          blurRadius: 4,
                          blurStyle: BlurStyle.solid)
                    ]),
                width: width(context),
              ),
              verticalSpace(25)
            ],
          ),
        ),
      ),
    );
  }
}
