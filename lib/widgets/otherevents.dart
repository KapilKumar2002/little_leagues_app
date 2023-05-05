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
                setState(() {});
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
        ListView.builder(
          itemCount: 8,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              height: 120,
              width: width(context),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: white2),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: double.infinity,
                      width: width(context) * .275,
                      child: Image.asset(
                        "assets/tt.jpg",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Table Tennis",
                                style: text16w600(black),
                              ),
                              Container(
                                height: 35,
                                width: 70,
                                child: Center(
                                    child: Text(
                                  "Join Now",
                                  style: text14w700(black),
                                )),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            ],
                          ),
                          verticalSpace(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date",
                                style: text14w700(black),
                              ),
                              Text(
                                "09/04/2023",
                                style: text12w400(black),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Start time",
                                style: text14w700(black),
                              ),
                              Text(
                                "10:00 AM",
                                style: text12w400(black),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "End time",
                                style: text14w700(black),
                              ),
                              Text(
                                "10:45 AM",
                                style: text12w400(black),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ]),
    );
  }
}
