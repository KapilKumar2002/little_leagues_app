import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:intl/intl.dart';

class PaymentHistory extends StatefulWidget {
  final String? id;
  const PaymentHistory({super.key, this.id});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  // final user = FirebaseAuth.instance.currentUser;

  Stream? _stream;

  getPaymentHistory() async {
    _stream = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.id)
        .collection("payment_history")
        .orderBy("time", descending: true)
        .snapshots();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getPaymentHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: -10,
          leading: IconButton(
              onPressed: () {
                popBack(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
              )),
          elevation: 0,
          foregroundColor: white2,
          backgroundColor: transparentColor,
          title: Text(
            "Payment History",
            style: text16w600(white2),
          ),
        ),
        body: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.docs.length == 0) {
              return Center(
                child: Container(
                  decoration: BoxDecoration(color: black, boxShadow: [
                    BoxShadow(
                        color: primaryColor, spreadRadius: 2, blurRadius: 2)
                  ]),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    "No payment done yet!",
                    style: text18w500(white2),
                  ),
                ),
              );
            } else {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // index = snapshot.data.docs.length - index - 1;
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              width: width(context),
                              color: primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Center(
                                  child: Text(
                                snapshot.data.docs[index].id,
                                style: text15w500(black),
                              )),
                            ),
                            ListView.builder(
                              itemCount: snapshot
                                  .data.docs[index]['allEntries'].length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                i = snapshot
                                        .data.docs[index]['allEntries'].length -
                                    i -
                                    1;
                                String time = DateFormat.jm().format(snapshot
                                    .data.docs[index]['allEntries'][i]['time']
                                    .toDate());
                                return Container(
                                  decoration: BoxDecoration(
                                      color: black,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: white2,
                                            blurRadius: 2,
                                            spreadRadius: 2)
                                      ]),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 7),
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Transaction ID:",
                                            style: text14w500(white2),
                                          ),
                                          Text(
                                            snapshot.data.docs[index]
                                                    ['allEntries'][i]
                                                ['transaction_id'],
                                            style: text10w400(white2),
                                          ),
                                          verticalSpace(2),
                                          Text(
                                            "Transaction Details:",
                                            style: text14w500(white2),
                                          ),
                                          Text(
                                            snapshot.data.docs[index]
                                                    ['allEntries'][i]
                                                ['transaction_details'],
                                            style: text10w400(white2),
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data.docs[index]
                                                ['allEntries'][i]['payment'],
                                            style: text14w500(white2),
                                          ),
                                          verticalSpace(18),
                                          Text(
                                            time,
                                            style: text8w800(white2),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                      color: primaryColor,
                    ));
            }
          },
        ));
  }
}
