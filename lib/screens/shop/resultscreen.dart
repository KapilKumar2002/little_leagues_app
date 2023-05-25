import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/shop/itemdetails.dart';
import 'package:little_leagues/utils/constants.dart';

class ResultScreen extends StatefulWidget {
  final String? type;
  final String? category;
  const ResultScreen({super.key, this.category, this.type});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Stream<QuerySnapshot>? product;
  Stream<QuerySnapshot>? bestSeller;

  getproducts() async {
    final data = await FirebaseFirestore.instance
        .collection("category")
        .doc("n7H0jLmG0KalEBjVwLm8")
        .collection("most_explored_sports")
        .doc("hjcTx9LzVHpmul6lk233")
        .collection("products")
        .where("category", isEqualTo: widget.category)
        .where("type", isEqualTo: widget.type)
        .snapshots();
    setState(() {
      product = data;
    });
  }

  getBestSeller() async {
    final data = await FirebaseFirestore.instance
        .collection("category")
        .doc("n7H0jLmG0KalEBjVwLm8")
        .collection("most_explored_sports")
        .doc("hjcTx9LzVHpmul6lk233")
        .collection("products")
        .where("bestseller", isEqualTo: true)
        .where("category", isEqualTo: widget.category)
        .where("type", isEqualTo: widget.type)
        .snapshots();
    setState(() {
      bestSeller = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getproducts();
    getBestSeller();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        titleSpacing: -10,
        title: Text(
          "Table Tennis Rackets",
          style: TextStyle(
            fontSize: 14,
            overflow: TextOverflow.visible,
          ),
        ),
        elevation: 0,
        backgroundColor: transparentColor,
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
              onPressed: () {}, icon: Icon(Icons.shopping_cart_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: grey.withOpacity(.2))),
              height: 50,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.swap_vert_outlined),
                        Text(" SORT "),
                        Icon(
                          Icons.circle,
                          size: 6,
                        )
                      ],
                    ),
                    Icon(Icons.grid_view_outlined),
                    Row(
                      children: [
                        Icon(Icons.filter_alt_outlined),
                        Text(" FILTER")
                      ],
                    )
                  ]),
            ),
            verticalSpace(8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: grey.withOpacity(.2))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "How to choose",
                          style: text12w400(black),
                        ),
                        Text(
                          "TT Rackets",
                          style: text14w500(black),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.play_arrow_outlined,
                          size: 18,
                          color: Colors.blue,
                        ),
                        horizontalSpace(20),
                        Text(
                          "Read\nMore",
                          style: text14w800(Colors.blue),
                        )
                      ],
                    )
                  ]),
            ),
            verticalSpace(10),
            Container(
              color: white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(15),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Text(
                      "OUR BESTSELLERS",
                      style: text16w600(black),
                    ),
                  ),
                  StreamBuilder(
                    stream: bestSeller,
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? Container(
                              width: width(context),
                              height: 290,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length,
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
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 15),
                                      width: width(context) * .45,
                                      decoration: BoxDecoration(
                                          color: white2,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 1,
                                              color: grey,
                                            ),
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 175,
                                            child: Stack(children: [
                                              Center(
                                                child: Image.network(
                                                  snapshot.data!.docs[index]
                                                      ['image'][0],
                                                  height: double.infinity,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      color:
                                                          grey.withOpacity(.1),
                                                      child: Center(
                                                        child: Icon(Icons
                                                            .image_search_rounded),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 7, vertical: 4),
                                                color: primaryColor,
                                                child: Text(
                                                  "BEST SELLER",
                                                  style: text8w800(black),
                                                ),
                                              ),
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
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: text12w500(black),
                                                ),
                                                verticalSpace(5),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['desc'],
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
                                                            "\u{20B9} ${snapshot.data!.docs[index]['price']}",
                                                            style: text10w500(
                                                                black),
                                                          ),
                                                        )),
                                                    horizontalSpace(5),
                                                    Text(
                                                      "\u{20B9} ${snapshot.data!.docs[index]['previous price']}",
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
                              ),
                            )
                          : Container();
                    },
                  )
                ],
              ),
            ),
            verticalSpace(10),
            Container(
                color: white2,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: StreamBuilder(
                  stream: product,
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
                                    childAspectRatio: width(context) * .4 / 250,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  NextScreen(
                                      context,
                                      ItemDetailScreen(
                                        pid: snapshot.data!.docs[index]['pid'],
                                      ));
                                },
                                child: Container(
                                  decoration:
                                      BoxDecoration(color: white2, boxShadow: [
                                    BoxShadow(
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
                                            snapshot.data!.docs[index]['image']
                                                [0],
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: grey.withOpacity(.1),
                                                child: Center(
                                                  child: Icon(Icons
                                                      .image_search_rounded),
                                                ),
                                              );
                                            },
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                          snapshot.data!.docs[index]
                                                  ['bestseller']
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 4),
                                                  color: primaryColor,
                                                  child: Text(
                                                    "BEST SELLER",
                                                    style: text8w800(black),
                                                  ),
                                                )
                                              : Container(),
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
                                                            .withOpacity(.5),
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
                                                            color: primaryColor,
                                                          ),
                                                          Text(
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['rating']
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
                                                                .circular(10),
                                                        color: white
                                                            .withOpacity(.5),
                                                        border: Border.all(
                                                            color: grey
                                                                .withOpacity(
                                                                    .2))),
                                                    height: 20,
                                                    width: 20,
                                                    child: Icon(
                                                      Icons
                                                          .favorite_border_rounded,
                                                      color: Colors.blueAccent,
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
                                              snapshot.data!.docs[index]['name']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: text12w500(black),
                                            ),
                                            verticalSpace(5),
                                            Text(
                                              snapshot.data!.docs[index]
                                                  ['desc'],
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
                                                        "\u{20B9} ${snapshot.data!.docs[index]['price']}",
                                                        style:
                                                            text10w500(black),
                                                      ),
                                                    )),
                                                horizontalSpace(5),
                                                Text(
                                                  "\u{20B9} ${snapshot.data!.docs[index]['previous price']}",
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      decoration: TextDecoration
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
                )),
            verticalSpace(20)
          ],
        ),
      ),
    );
  }
}
