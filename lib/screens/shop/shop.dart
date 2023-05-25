import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:little_leagues/screens/shop/itemscreen.dart';
import 'package:little_leagues/services/database_service.dart';
import 'package:little_leagues/utils/constants.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  Stream<QuerySnapshot>? explored_sports;
  Stream<QuerySnapshot>? all_sports;

  getsports() async {
    DatabaseService().getexports("n7H0jLmG0KalEBjVwLm8").then((val) {
      setState(() {
        explored_sports = val;
      });
    });
    DatabaseService().getallsports("n7H0jLmG0KalEBjVwLm8").then((val) {
      setState(() {
        all_sports = val;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getsports();
    super.initState();
  }

  final pageController = PageController();
  final _controller = CarouselController();

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MOST EXPLORED",
                    style: text12w400(white, fontStyle: FontStyle.italic),
                  ),
                  verticalSpace(5),
                  Text(
                    "SPORTS",
                    style: text16w600(white2),
                  ),
                ],
              ),
            ),
            verticalSpace(4),
            StreamBuilder(
                stream: explored_sports,
                builder: (context, AsyncSnapshot snapshot) {
                  return snapshot.hasData
                      ? Container(
                          height: 120,
                          child: ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    NextScreen(
                                        context,
                                        ItemScreen(
                                          title: snapshot.data.docs[index]
                                              ['sname'],
                                          s_id: snapshot.data.docs[index]
                                              ['sid'],
                                        ));
                                  },
                                  child: Container(
                                    width: 120,
                                    decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                              color: white2,
                                              blurRadius: 2,
                                              blurStyle: BlurStyle.solid,
                                              spreadRadius: 1)
                                        ]),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Container(
                                            child: Image.network(
                                              snapshot.data.docs[index]
                                                  ['s_pic'],
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
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          child: Align(
                                            alignment: AlignmentDirectional
                                                .bottomCenter,
                                            child: Text(
                                              snapshot.data.docs[index]['sname']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: text10w800(white2),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Container(
                          height: 120,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: primaryColor,
                          )));
                }),
            verticalSpace(25),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DISCOVER",
                    style: text12w400(white),
                  ),
                  verticalSpace(4),
                  Text(
                    "ALL SPORTS",
                    style: text16w500(white2),
                  )
                ],
              ),
            ),
            verticalSpace(15),
            StreamBuilder(
              stream: all_sports,
              builder: (context, AsyncSnapshot snapshot) {
                return snapshot.hasData
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: width(context) * .4 / 110),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              NextScreen(
                                  context,
                                  ItemScreen(
                                    title: snapshot.data.docs[index]['sname'],
                                    s_id: snapshot.data.docs[index]['sid'],
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                        color: white2,
                                        blurRadius: 1,
                                        blurStyle: BlurStyle.solid,
                                        spreadRadius: 1)
                                  ]),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    snapshot.data.docs[index]['s_pic'],
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: white.withOpacity(.6),
                                        child: Center(
                                          child:
                                              Icon(Icons.image_search_rounded),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Align(
                                    alignment: AlignmentDirectional.bottomStart,
                                    child: Text(
                                      snapshot.data.docs[index]['sname']
                                          .toString()
                                          .toUpperCase(),
                                      style: text12w800(white2),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        color: primaryColor,
                      ));
              },
            )
          ],
        ),
      ),
    );
  }
}
