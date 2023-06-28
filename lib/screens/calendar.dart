import 'package:flutter/material.dart';

import 'package:little_leagues/utils/constants.dart';
import 'package:little_leagues/widgets/otherevents.dart';
import 'package:little_leagues/widgets/revents.dart';

class CalendarPage extends StatefulWidget {
  final String? id;
  final String? institution;
  const CalendarPage({super.key, this.id, this.institution});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController controller = TabController(length: 2, vsync: this);
    return Scaffold(
      backgroundColor: black,
      body: Container(
        height: height(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
                unselectedLabelColor: white,
                labelColor: white2,
                labelStyle: text18w500(white),
                controller: controller,
                tabs: [
                  Tab(text: "Registered Events"),
                  Tab(text: "Other Events"),
                ]),
            verticalSpace(10),
            Expanded(
                child: TabBarView(controller: controller, children: [
              RegisteredEvents(
                id: widget.id,
              ),
              OtherEvents(
                institution: widget.institution.toString(),
                id: widget.id.toString(),
              )
            ])),
          ],
        ),
      ),
    );
  }
}
