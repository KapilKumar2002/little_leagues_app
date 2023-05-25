import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';

import 'package:intl/intl.dart';
import 'package:little_leagues/widgets/customdatepicker.dart';

class SportsEntryPortal extends StatefulWidget {
  const SportsEntryPortal({super.key});

  @override
  State<SportsEntryPortal> createState() => _SportsEntryPortalState();
}

class _SportsEntryPortalState extends State<SportsEntryPortal> {
  bool _loading = false;
  List newsPaper = ["Times of India", "Kesari", "Amar Ujala"];
  List? sportsList;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  String? sports = "Selct Sport";
  final classCollection = FirebaseFirestore.instance.collection("classes");

  setClasses() async {
    final response = await classCollection.add({
      "name": sports,
      "start_date": startDateController.text.toString(),
      "end_date": endDateController.text.toString(),
      "class_image": "",
      "current": true,
      "start_time": "11:00 AM",
      "end_time": "12:30 PM",
      "class_id": "",
      "class_days": []
    });

    classCollection.doc(response.id).update({"class_id": response.id});
  }

  getsports() async {
    setState(() {
      _loading = true;
    });
    final data = await FirebaseFirestore.instance
        .collection("app_data")
        .doc("Mn9CCmH9cKsTIKTju0u1")
        .get();

    final sports = data.data() as Map<String, dynamic>;

    setState(() {
      sportsList = sports['sports'];
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getsports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: transparentColor,
          title: Text(
            "Sports Entry Portal",
            style: text15w500(white2),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            // Form(
            //     child: Column(
            //   children: [
            //     CustomTextField(
            //       controller: nameController,
            //     )
            //   ],
            // ))
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.fromBorderSide(BorderSide(color: white2))),
              child: DropdownButton(
                  hint: Text(
                    sports!,
                    style: text15w400(white2),
                  ),
                  dropdownColor: white,
                  underline: SizedBox(),
                  isExpanded: true,
                  items: sportsList?.map((e) {
                    return DropdownMenuItem(
                        value: e.toString(), child: Text(e.toString()));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      sports = value;
                    });
                  }),
            ),
            CustomDateSelector(controller: startDateController),
            CustomDateSelector(controller: endDateController),
            verticalSpace(25),
            ElevatedButton(
              onPressed: () {
                setClasses();
              },
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  minimumSize: Size(width(context), 50)),
            )
          ],
        ),
      ),
    );
  }
}
