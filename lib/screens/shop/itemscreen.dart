import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/shop/itemdetails.dart';
import 'package:little_leagues/screens/shop/resultscreen.dart';
import 'package:little_leagues/screens/shop/yourcart.dart';
import 'package:little_leagues/utils/constants.dart';

class ItemScreen extends StatefulWidget {
  final String s_id;
  final String title;
  const ItemScreen({Key? key, required this.s_id, required this.title})
      : super(key: key);
  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  Stream<QuerySnapshot>? carousel;
  Stream<QuerySnapshot>? menNewArrival;
  Stream<QuerySnapshot>? womenNewArrival;
  Stream<QuerySnapshot>? newAccessories;
  Stream<QuerySnapshot>? dropdown;
  String? name;
  getCarouselData() async {}

  @override
  void initState() {
    // TODO: implement initState
    getProducts();
    super.initState();
  }

  getProducts() async {
    final data = await FirebaseFirestore.instance
        .collection("category")
        .doc("n7H0jLmG0KalEBjVwLm8")
        .collection("most_explored_sports")
        .doc("hjcTx9LzVHpmul6lk233")
        .collection("carousel")
        .snapshots();

    final newMen = await FirebaseFirestore.instance
        .collection("category")
        .doc("n7H0jLmG0KalEBjVwLm8")
        .collection("most_explored_sports")
        .doc("hjcTx9LzVHpmul6lk233")
        .collection("products")
        .where("category", isEqualTo: "new men")
        .snapshots();
    final newWomen = await FirebaseFirestore.instance
        .collection("category")
        .doc("n7H0jLmG0KalEBjVwLm8")
        .collection("most_explored_sports")
        .doc("hjcTx9LzVHpmul6lk233")
        .collection("products")
        .where("category", isEqualTo: "new women")
        .snapshots();
    final newAcc = await FirebaseFirestore.instance
        .collection("category")
        .doc("n7H0jLmG0KalEBjVwLm8")
        .collection("most_explored_sports")
        .doc("hjcTx9LzVHpmul6lk233")
        .collection("products")
        .where("category", isEqualTo: "new acc")
        .snapshots();
    final drop = await FirebaseFirestore.instance
        .collection("category")
        .doc("n7H0jLmG0KalEBjVwLm8")
        .collection("most_explored_sports")
        .doc("hjcTx9LzVHpmul6lk233")
        .collection("dropdown")
        .snapshots();
    setState(() {
      carousel = data;
      dropdown = drop;
      menNewArrival = newMen;
      womenNewArrival = newWomen;
      newAccessories = newAcc;
    });
  }

  final _carouselController = CarouselController();

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(TextSpan(
          text: widget.title.toUpperCase(),
          style: TextStyle(overflow: TextOverflow.visible, fontSize: 14),
        )),
        elevation: 0,
        backgroundColor: white2,
        titleSpacing: -15,
        leading: IconButton(
          onPressed: () {
            popBack(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
          IconButton(
              onPressed: () {}, icon: Icon(Icons.favorite_border_rounded)),
          IconButton(
              onPressed: () {
                NextScreen(context, YourCart());
              },
              icon: Icon(Icons.shopping_cart_outlined)),
        ],
      ),
      // body: Text(name.toString()),
      body: SingleChildScrollView(
        child: Container(
          color: grey.withOpacity(.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(7),
              StreamBuilder(
                  stream: carousel,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData && snapshot.data.docs.length != 0) {
                      List<Widget> list = [];

                      //Create for loop and store the urls in the list
                      for (int i = 0; i < snapshot.data.docs.length; i++) {
                        list.add(Image(
                          image: NetworkImage(snapshot.data.docs[i]['c_image']),
                          height: 450,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: white.withOpacity(.6),
                              child: Center(
                                child: Icon(Icons.image_search_rounded),
                              ),
                            );
                          },
                        ));
                      }
                      return Container(
                        child: Column(
                          children: [
                            Container(
                              color: grey.withOpacity(.2),
                              height: 450,
                              child: Stack(
                                children: [
                                  CarouselSlider(
                                    carouselController: _carouselController,
                                    options: CarouselOptions(
                                        viewportFraction: 1,
                                        enlargeCenterPage: true,
                                        // autoPlay: true,
                                        height: double.infinity,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        }),
                                    items: list.map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return i;
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional.topEnd,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 15, top: 10),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Starting from",
                                              style: text15w500(white2),
                                            ),
                                            verticalSpace(5),
                                            Text(
                                              "\u20B9 " +
                                                  snapshot.data.docs[_current]
                                                      ['from'],
                                              style: text14w500(white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 15),
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          "${_current + 1}/${list.length}",
                                          style: text14w400(white2),
                                        ),
                                      ),
                                      height: 25,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: grey.withOpacity(.4),
                                          borderRadius:
                                              BorderRadius.circular(12.5)),
                                    ),
                                  ),
                                  Align(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 70, vertical: 100),
                                        child: Text(
                                          snapshot.data.docs[_current]['title'],
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: white2,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                  Align(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 40),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          NextScreen(
                                              context,
                                              ResultScreen(
                                                category: snapshot.data
                                                    .docs[_current]['category'],
                                                type: snapshot.data
                                                    .docs[_current]['type'],
                                              ));
                                        },
                                        child: Text(
                                          snapshot
                                              .data.docs[_current]['buttonName']
                                              .toString()
                                              .toUpperCase(),
                                          style: text14w700(black),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 15),
                                            elevation: 0,
                                            backgroundColor: primaryColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpace(8),
                            Container(
                              height: 30,
                              width: width(context),
                              color: white,
                              child: Container(
                                height: 10,
                                width: 80,
                                child: Center(
                                  child: CarouselIndicator(
                                    space: 10,
                                    height: 8,
                                    width: 8,
                                    activeColor: primaryColor,
                                    color: primaryColor.withOpacity(.3),
                                    count: list.length,
                                    index: _current,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
              verticalSpace(15),
              StreamBuilder(
                stream: dropdown,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Container(
                          color: white2,
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  collapsedBackgroundColor: transparentColor,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ListView.builder(
                                        itemCount: snapshot.data!
                                            .docs[index]['content'].length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, i) {
                                          return InkWell(
                                            onTap: () {
                                              NextScreen(
                                                  context,
                                                  ResultScreen(
                                                    category: snapshot.data!
                                                                .docs[index]
                                                            ['content'][i]
                                                        ['category'],
                                                    type: snapshot
                                                            .data!.docs[index]
                                                        ['content'][i]['type'],
                                                  ));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(snapshot
                                                          .data!.docs[index]
                                                      ['content'][i]['name']),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 12,
                                                    color: black,
                                                  )
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                  color: grey.withOpacity(.035),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 2),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                  leading: Container(
                                    width: 70,
                                    color: grey,
                                    child: Image.network(
                                      snapshot.data!.docs[index]['leading'],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: white.withOpacity(.6),
                                          child: Center(
                                            child: Icon(
                                                Icons.image_search_rounded),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    snapshot.data!.docs[index]['title'],
                                    style: text15w500(black),
                                  ),
                                  onExpansionChanged: (value) {},
                                  trailing: Icon(Icons.add),
                                ),
                              );
                            },
                          ),
                        )
                      : horizontalSpace(0);
                },
              ),
              verticalSpace(20),
              Container(
                color: white2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpace(20),
                          Text(
                            "NEW ARRIVALS",
                            style: text14w400(black),
                          ),
                          verticalSpace(7),
                          Text(
                            "MEN",
                            style: text16w600(black),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(10),
                    StreamBuilder(
                      stream: menNewArrival,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? GridView.builder(
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 2,
                                        crossAxisSpacing: 2,
                                        childAspectRatio:
                                            width(context) * .4 / 250,
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      NextScreen(
                                          context,
                                          ItemDetailScreen(
                                            pid: snapshot.data!.docs[index]
                                                ['pid'],
                                          ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: white2,
                                          boxShadow: [
                                            BoxShadow(
                                              blurStyle: BlurStyle.outer,
                                              blurRadius: 1,
                                              color: grey,
                                            ),
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 225,
                                            child: Stack(children: [
                                              Image.network(
                                                snapshot.data!.docs[index]
                                                    ['image'][0],
                                                width: double.infinity,
                                                height: double.infinity,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    color:
                                                        grey.withOpacity(.08),
                                                    child: Center(
                                                      child: Icon(Icons
                                                          .image_search_rounded),
                                                    ),
                                                  );
                                                },
                                                fit: BoxFit.cover,
                                              ),
                                              snapshot.data!.docs[index]
                                                          ['bestseller'] ==
                                                      true
                                                  ? Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 7,
                                                              vertical: 4),
                                                      color: primaryColor,
                                                      child: Text(
                                                        "BEST SELLER",
                                                        style: text8w800(black),
                                                      ),
                                                    )
                                                  : horizontalSpace(0),
                                              Align(
                                                alignment: AlignmentDirectional
                                                    .bottomCenter,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10,
                                                      right: 8,
                                                      left: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: white
                                                                .withOpacity(
                                                                    .5),
                                                            border: Border.all(
                                                                color: grey
                                                                    .withOpacity(
                                                                        .2))),
                                                        height: 20,
                                                        width: 40,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                size: 12,
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                              Text(
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'rating']
                                                                    .toString(),
                                                                style: text8w800(
                                                                    Colors
                                                                        .blueAccent),
                                                              )
                                                            ]),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: white
                                                                .withOpacity(
                                                                    .5),
                                                            border: Border.all(
                                                                color: grey
                                                                    .withOpacity(
                                                                        .2))),
                                                        height: 20,
                                                        width: 20,
                                                        child: Icon(
                                                          Icons
                                                              .favorite_border_rounded,
                                                          color:
                                                              Colors.blueAccent,
                                                          size: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data!.docs[index]['name']
                                                      .toString(),
                                                  style: text12w500(black),
                                                ),
                                                verticalSpace(5),
                                                Text(
                                                  snapshot
                                                      .data!.docs[index]['desc']
                                                      .toString(),
                                                  style: text10w400(
                                                      black.withOpacity(.4)),
                                                ),
                                                verticalSpace(5),
                                                Row(
                                                  children: [
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            color: primaryColor,
                                                            border: Border.all(
                                                                color: grey
                                                                    .withOpacity(
                                                                        .2))),
                                                        height: 20,
                                                        width: 40,
                                                        child: Center(
                                                          child: Text(
                                                            "\u{20B9} ${snapshot.data!.docs[index]['price'].toString()}",
                                                            style: text10w500(
                                                                black),
                                                          ),
                                                        )),
                                                    horizontalSpace(5),
                                                    Text(
                                                      "\u{20B9} ${snapshot.data!.docs[index]['previous price'].toString()}",
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container();
                      },
                    ),
                    verticalSpace(20),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            NextScreen(context, ResultScreen());
                          },
                          child: Text(
                            "View All",
                            style: text16w600(primaryColor),
                          )),
                    ),
                    verticalSpace(20)
                  ],
                ),
              ),
              verticalSpace(20),
              Container(
                color: white2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpace(20),
                          Text(
                            "NEW ARRIVALS",
                            style: text14w400(black),
                          ),
                          verticalSpace(7),
                          Text(
                            "WOMEN",
                            style: text16w600(black),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(10),
                    StreamBuilder(
                      stream: womenNewArrival,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? GridView.builder(
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 2,
                                        crossAxisSpacing: 2,
                                        childAspectRatio:
                                            width(context) * .4 / 250,
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      NextScreen(
                                          context,
                                          ItemDetailScreen(
                                            pid: snapshot.data!.docs[index]
                                                ['pid'],
                                          ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: white2,
                                          boxShadow: [
                                            BoxShadow(
                                              blurStyle: BlurStyle.outer,
                                              blurRadius: 1,
                                              color: grey,
                                            ),
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 225,
                                            child: Stack(children: [
                                              Image.network(
                                                snapshot.data!.docs[index]
                                                    ['image'][0],
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    color: grey.withOpacity(.1),
                                                    child: Center(
                                                      child: Icon(Icons
                                                          .image_search_rounded),
                                                    ),
                                                  );
                                                },
                                              ),
                                              snapshot.data!.docs[index]
                                                          ['bestseller'] ==
                                                      true
                                                  ? Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 7,
                                                              vertical: 4),
                                                      color: primaryColor,
                                                      child: Text(
                                                        "BEST SELLER",
                                                        style: text8w800(black),
                                                      ),
                                                    )
                                                  : horizontalSpace(0),
                                              Align(
                                                alignment: AlignmentDirectional
                                                    .bottomCenter,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10,
                                                      right: 8,
                                                      left: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: white
                                                                .withOpacity(
                                                                    .5),
                                                            border: Border.all(
                                                                color: grey
                                                                    .withOpacity(
                                                                        .2))),
                                                        height: 20,
                                                        width: 40,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                size: 12,
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                              Text(
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'rating']
                                                                    .toString(),
                                                                style: text8w800(
                                                                    Colors
                                                                        .blueAccent),
                                                              )
                                                            ]),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: white
                                                                .withOpacity(
                                                                    .5),
                                                            border: Border.all(
                                                                color: grey
                                                                    .withOpacity(
                                                                        .2))),
                                                        height: 20,
                                                        width: 20,
                                                        child: Icon(
                                                          Icons
                                                              .favorite_border_rounded,
                                                          color:
                                                              Colors.blueAccent,
                                                          size: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data!.docs[index]['name']
                                                      .toString(),
                                                  style: text12w500(black),
                                                ),
                                                verticalSpace(5),
                                                Text(
                                                  snapshot
                                                      .data!.docs[index]['desc']
                                                      .toString(),
                                                  style: text10w400(
                                                      black.withOpacity(.4)),
                                                ),
                                                verticalSpace(5),
                                                Row(
                                                  children: [
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            color: primaryColor,
                                                            border: Border.all(
                                                                color: grey
                                                                    .withOpacity(
                                                                        .2))),
                                                        height: 20,
                                                        width: 40,
                                                        child: Center(
                                                          child: Text(
                                                            "\u{20B9} ${snapshot.data!.docs[index]['price'].toString()}",
                                                            style: text10w500(
                                                                black),
                                                          ),
                                                        )),
                                                    horizontalSpace(5),
                                                    Text(
                                                      "\u{20B9} ${snapshot.data!.docs[index]['previous price'].toString()}",
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container();
                      },
                    ),
                    verticalSpace(20),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            NextScreen(context, ResultScreen());
                          },
                          child: Text(
                            "View All",
                            style: text16w600(primaryColor),
                          )),
                    ),
                    verticalSpace(20)
                  ],
                ),
              ),
              verticalSpace(20),
              Container(
                color: white2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpace(20),
                          Text(
                            "NEW ARRIVALS",
                            style: text14w400(black),
                          ),
                          verticalSpace(7),
                          Text(
                            "ACCESSORIES",
                            style: text16w600(black),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(10),
                    StreamBuilder(
                      stream: newAccessories,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? GridView.builder(
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 2,
                                        crossAxisSpacing: 2,
                                        childAspectRatio:
                                            width(context) * .4 / 250,
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      NextScreen(
                                          context,
                                          ItemDetailScreen(
                                            pid: snapshot.data!.docs[index]
                                                ['pid'],
                                          ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: white2,
                                          boxShadow: [
                                            BoxShadow(
                                              blurStyle: BlurStyle.outer,
                                              blurRadius: 1,
                                              color: grey,
                                            ),
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 225,
                                            child: Stack(children: [
                                              Image.network(
                                                snapshot.data!.docs[index]
                                                    ['image'][0],
                                                width: double.infinity,
                                                height: double.infinity,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    color: grey.withOpacity(.1),
                                                    child: Center(
                                                      child: Icon(Icons
                                                          .image_search_rounded),
                                                    ),
                                                  );
                                                },
                                                fit: BoxFit.cover,
                                              ),
                                              snapshot.data!.docs[index]
                                                          ['bestseller'] ==
                                                      true
                                                  ? Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 7,
                                                              vertical: 4),
                                                      color: primaryColor,
                                                      child: Text(
                                                        "BEST SELLER",
                                                        style: text8w800(black),
                                                      ),
                                                    )
                                                  : horizontalSpace(0),
                                              Align(
                                                alignment: AlignmentDirectional
                                                    .bottomCenter,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10,
                                                      right: 8,
                                                      left: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: white
                                                                .withOpacity(
                                                                    .5),
                                                            border: Border.all(
                                                                color: grey
                                                                    .withOpacity(
                                                                        .2))),
                                                        height: 20,
                                                        width: 40,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                size: 12,
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                              Text(
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'rating']
                                                                    .toString(),
                                                                style: text8w800(
                                                                    Colors
                                                                        .blueAccent),
                                                              )
                                                            ]),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: white
                                                                .withOpacity(
                                                                    .5),
                                                            border: Border.all(
                                                                color: grey
                                                                    .withOpacity(
                                                                        .2))),
                                                        height: 20,
                                                        width: 20,
                                                        child: Icon(
                                                          Icons
                                                              .favorite_border_rounded,
                                                          color:
                                                              Colors.blueAccent,
                                                          size: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data!.docs[index]['name']
                                                      .toString(),
                                                  style: text12w500(black),
                                                ),
                                                verticalSpace(5),
                                                Text(
                                                  snapshot
                                                      .data!.docs[index]['desc']
                                                      .toString(),
                                                  style: text10w400(
                                                      black.withOpacity(.4)),
                                                ),
                                                verticalSpace(5),
                                                Row(
                                                  children: [
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            color: primaryColor,
                                                            border: Border.all(
                                                                color: grey
                                                                    .withOpacity(
                                                                        .2))),
                                                        height: 20,
                                                        width: 40,
                                                        child: Center(
                                                          child: Text(
                                                            "\u{20B9} ${snapshot.data!.docs[index]['price'].toString()}",
                                                            style: text10w500(
                                                                black),
                                                          ),
                                                        )),
                                                    horizontalSpace(5),
                                                    Text(
                                                      "\u{20B9} ${snapshot.data!.docs[index]['previous price'].toString()}",
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container();
                      },
                    ),
                    verticalSpace(20),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            NextScreen(context, ResultScreen());
                          },
                          child: Text(
                            "View All",
                            style: text16w600(primaryColor),
                          )),
                    ),
                    verticalSpace(20)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
