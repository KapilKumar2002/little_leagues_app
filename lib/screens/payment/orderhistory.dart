import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatefulWidget {
  final String id;
  const OrderHistoryPage({super.key, required this.id});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  Stream? _stream;

  getPaymentHistory() async {
    _stream = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.id)
        .collection("orderTable")
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
        backgroundColor: backgroundColor,
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
          backgroundColor: black,
          title: Text(
            "Order History",
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
                    "You haven't order anything yet!",
                    style: text18w500(white2),
                  ),
                ),
              );
            } else {
              return snapshot.hasData
                  ? ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: white.withOpacity(.5),
                          height: 0,
                        );
                      },
                      itemCount: snapshot.data.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        index = snapshot.data.docs.length - index - 1;
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
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
                                horizontalSpace(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data.docs[index]['class_name']
                                          .toString()
                                          .toUpperCase(),
                                      style: text16w500(white2),
                                    ),
                                    Text(
                                      "\u20B9" +
                                          snapshot.data.docs[index]['price']
                                              .toString(),
                                      style: text12w500(white2),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Order Date: ",
                                          style: text12w400(white2),
                                        ),
                                        horizontalSpace(10),
                                        Text(
                                          DateFormat.yMd()
                                              .format(snapshot.data
                                                  .docs[index]['order_date']
                                                  .toDate())
                                              .toString(),
                                          style: text12w600(white2),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Order Time: ",
                                          style: text12w400(white2),
                                        ),
                                        horizontalSpace(10),
                                        Text(
                                          DateFormat.jm()
                                              .format(snapshot.data
                                                  .docs[index]['order_date']
                                                  .toDate())
                                              .toString(),
                                          style: text12w600(white2),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
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
