import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/bottomnav.dart';
import 'package:little_leagues/screens/payment/getpaymentinfo.dart';
import 'package:little_leagues/utils/constants.dart';
import 'dart:math' as math;
import 'package:little_leagues/widgets/showsnackbar.dart';

class YourCart extends StatefulWidget {
  final String? id;
  const YourCart({super.key, this.id});

  @override
  State<YourCart> createState() => _YourCartState();
}

class _YourCartState extends State<YourCart> {
  bool selectAll = false;
  num charge = 50;
  String? selectedSize;
  Stream? cartProducts;

  QuerySnapshot? snap;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  getMyCart() async {
    final products =
        userCollection.doc(widget.id).collection("cart").snapshots();
    setState(() {
      cartProducts = products;
    });
  }

  removeProduct(String id) async {
    await userCollection.doc(widget.id).collection("cart").doc(id).delete();
  }

  seDeSeProduct(String id, bool value) async {
    await userCollection
        .doc(widget.id)
        .collection("cart")
        .doc(id)
        .update({"isSelected": value});
  }

  updateQTY(String id, int qty) async {
    await userCollection
        .doc(widget.id)
        .collection("cart")
        .doc(id)
        .update({"qty": qty});
  }

  updateSize(String id) async {
    await userCollection
        .doc(widget.id)
        .collection("cart")
        .doc(id)
        .update({"selectedSize": selectedSize});
  }

  deleteProduct(String id) async {
    await userCollection.doc(widget.id).collection("cart").doc(id).delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    getMyCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white2,
        foregroundColor: black,
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              popBack(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
            )),
        title: Text(
          "Your Cart",
          style: text16w500(black),
        ),
      ),
      body: StreamBuilder(
        stream: cartProducts,
        builder: (context, AsyncSnapshot snapshot) {
          num total = 0;

          num rtotal = 0;

          var itemSelected = 0;
          List pOrder = [];

          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              if (snapshot.data.docs[i]['isSelected']) {
                total = total + snapshot.data.docs[i]['price'];
                rtotal = rtotal + snapshot.data.docs[i]['previous price'];
                pOrder.add({
                  "item": snapshot.data.docs[i]['item'],
                  "id": snapshot.data.docs[i]['pid']
                });
                itemSelected = itemSelected + 1;
              }
            }
          }

          return snapshot.hasData
              ? snapshot.data.docs.length == 0
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "There is no product added yet!",
                            style: text16w600(black),
                          ),
                          verticalSpace(10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor),
                              onPressed: () {
                                NextScreen(
                                    context,
                                    BottomNav(
                                      id: widget.id,
                                    ));
                              },
                              child: Text(
                                "Explore More",
                                style: text18w500(black),
                              ))
                        ],
                      ),
                    )
                  : Container(
                      height: height(context),
                      child: Stack(
                        children: [
                          Container(
                            height: height(context) - 165,
                            color: grey.withOpacity(.05),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // change
                                    //     ? Padding(
                                    //         padding: const EdgeInsets.symmetric(
                                    //             vertical: 8),
                                    //         child: Form(
                                    //           key: formkey,
                                    //           child: TextFormField(
                                    //             controller: controller,
                                    //             validator: (value) {
                                    //               if (value == null ||
                                    //                   value.trim().isEmpty) {
                                    //                 return 'This field is required!';
                                    //               }
                                    //               if (value.trim().length < 6) {
                                    //                 return 'Field must have at least 6 characters in length!';
                                    //               }
                                    //               // Return null if the entered username is valid
                                    //               return null;
                                    //             },
                                    //             decoration: InputDecoration(
                                    //                 border: InputBorder.none,
                                    //                 suffixIcon: TextButton(
                                    //                     onPressed: () async {
                                    //                       if (formkey
                                    //                           .currentState!
                                    //                           .validate()) {
                                    //                         await FirebaseFirestore
                                    //                             .instance
                                    //                             .collection(
                                    //                                 "users")
                                    //                             .doc(widget.id)
                                    //                             .update({
                                    //                           "zip_code":
                                    //                               controller
                                    //                                   .text
                                    //                         });
                                    //                         setState(() {
                                    //                           change = !change;
                                    //                         });
                                    //                       }
                                    //                     },
                                    //                     child: Text("Update")),
                                    //                 focusedErrorBorder:
                                    //                     OutlineInputBorder(
                                    //                         borderSide: BorderSide(
                                    //                             color: black),
                                    //                         borderRadius:
                                    //                             BorderRadius.circular(
                                    //                                 10)),
                                    //                 focusedBorder: OutlineInputBorder(
                                    //                     borderSide: BorderSide(
                                    //                         color: black),
                                    //                     borderRadius:
                                    //                         BorderRadius.circular(
                                    //                             10)),
                                    //                 errorBorder: OutlineInputBorder(
                                    //                     borderSide: BorderSide(
                                    //                         color: black),
                                    //                     borderRadius:
                                    //                         BorderRadius.circular(
                                    //                             10)),
                                    //                 enabledBorder: OutlineInputBorder(
                                    //                     borderSide: BorderSide(
                                    //                         color: black),
                                    //                     borderRadius:
                                    //                         BorderRadius.circular(
                                    //                             10))),
                                    //           ),
                                    //         ),
                                    //       )
                                    //     : Container(
                                    //         decoration: BoxDecoration(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(5),
                                    //             color: white2,
                                    //             boxShadow: [
                                    //               BoxShadow(
                                    //                   color:
                                    //                       grey.withOpacity(.05),
                                    //                   blurRadius: 1)
                                    //             ]),
                                    //         margin: EdgeInsets.symmetric(
                                    //             vertical: 25),
                                    //         padding: EdgeInsets.symmetric(
                                    //             horizontal: 15),
                                    //         height: 45,
                                    //         child: Row(children: [
                                    //           Text(
                                    //             "PINCODE: 120001",
                                    //             style: text14w400(grey),
                                    //           ),
                                    //           horizontalSpace(12),
                                    //           Icon(
                                    //             Icons.check_circle_outline,
                                    //             color: Colors.green,
                                    //             size: 17,
                                    //           ),
                                    //           Expanded(child: Container()),
                                    //           InkWell(
                                    //             onTap: () {
                                    //               setState(() {
                                    //                 change = !change;
                                    //               });
                                    //             },
                                    //             child: Text(
                                    //               "CHANGE",
                                    //               style: text14w400(
                                    //                   Colors.blueAccent),
                                    //             ),
                                    //           ),
                                    //         ]),
                                    //       ),
                                    Text(
                                      "Items for delivery",
                                      style: text16w500(black),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: white2,
                                          boxShadow: [
                                            BoxShadow(
                                                color: grey.withOpacity(.05),
                                                blurRadius: 1)
                                          ]),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 15),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 20),
                                      child: Column(
                                        children: [
                                          Column(children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(children: [
                                                  // Checkbox(
                                                  //   side: BorderSide(
                                                  //       color: black, width: 2),
                                                  //   activeColor: primaryColor,
                                                  //   checkColor: black,
                                                  //   value: selectAll,
                                                  //   onChanged: (value) {
                                                  //     selectAll = !selectAll;
                                                  //     setState(() {});
                                                  //   },
                                                  // ),
                                                  // horizontalSpace(10),
                                                  Text(
                                                    "${itemSelected.toString()}/${snapshot.data.docs.length.toString()} Item selected",
                                                    style: text12w500(black),
                                                  )
                                                ]),
                                                // selectAll
                                                //     ? IconButton(
                                                //         onPressed: () {
                                                //           deleteAll();
                                                //         },
                                                //         icon:
                                                //             Icon(Icons.delete))
                                                //     : horizontalSpace(0),
                                              ],
                                            ),
                                            Divider(),
                                            ListView.separated(
                                              separatorBuilder:
                                                  (context, index) {
                                                return Divider();
                                              },
                                              itemCount:
                                                  snapshot.data.docs.length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return snapshot.data.docs[index]
                                                            ['item'] ==
                                                        "product"
                                                    ? Container(
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height: 60,
                                                              width: 60,
                                                              child: Stack(
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    progressIndicatorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return Container(
                                                                        color:
                                                                            backgroundColor,
                                                                      );
                                                                    },
                                                                    imageUrl: snapshot
                                                                            .data
                                                                            .docs[index]
                                                                        [
                                                                        'image'],
                                                                    height: 60,
                                                                    width: 60,
                                                                  ),
                                                                  CachedNetworkImage(
                                                                      imageUrl: snapshot
                                                                          .data
                                                                          .docs[index]['image'][0]),
                                                                  Checkbox(
                                                                    side: BorderSide(
                                                                        color:
                                                                            white,
                                                                        width:
                                                                            2),
                                                                    activeColor:
                                                                        primaryColor,
                                                                    checkColor:
                                                                        black,
                                                                    value: snapshot
                                                                            .data
                                                                            .docs[index]
                                                                        [
                                                                        'isSelected'],
                                                                    onChanged:
                                                                        (value) {
                                                                      seDeSeProduct(
                                                                          snapshot
                                                                              .data
                                                                              .docs[index]['pid'],
                                                                          value!);
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            horizontalSpace(10),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      snapshot
                                                                          .data
                                                                          .docs[
                                                                              index]
                                                                              [
                                                                              'name']
                                                                          .toString()
                                                                          .toUpperCase(),
                                                                      style: text14w400(
                                                                          black),
                                                                    ),
                                                                    snapshot.data.docs[index]
                                                                            [
                                                                            'isSelected']
                                                                        ? InkWell(
                                                                            onTap:
                                                                                () {
                                                                              removeProduct(snapshot.data.docs[index]['pid']);
                                                                            },
                                                                            child: Icon(Icons
                                                                                .delete))
                                                                        : horizontalSpace(
                                                                            0),
                                                                  ],
                                                                ),
                                                                verticalSpace(
                                                                    5),
                                                                Text(
                                                                  snapshot.data
                                                                              .docs[
                                                                          index]
                                                                      ['desc'],
                                                                  style:
                                                                      text12w500(
                                                                          black),
                                                                ),
                                                                verticalSpace(
                                                                    10),
                                                                Row(
                                                                  children: [
                                                                    snapshot.data.docs[index]["type"] ==
                                                                                "upper" ||
                                                                            snapshot.data.docs[index]["type"] ==
                                                                                "bottom"
                                                                        ? InkWell(
                                                                            onTap:
                                                                                () {
                                                                              showModalBottomSheet(
                                                                                backgroundColor: transparentColor,
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return Wrap(
                                                                                    children: [
                                                                                      Align(
                                                                                        alignment: AlignmentDirectional.topEnd,
                                                                                        child: Container(
                                                                                          color: white2,
                                                                                          height: 50,
                                                                                          width: 50,
                                                                                          child: IconButton(
                                                                                              onPressed: () {
                                                                                                popBack(context);
                                                                                              },
                                                                                              icon: Icon(Icons.clear)),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                        width: width(context),
                                                                                        color: white2,
                                                                                        child: Column(
                                                                                          children: [
                                                                                            verticalSpace(15),
                                                                                            Container(
                                                                                              color: white2,
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        "SELECT SIZE",
                                                                                                        style: text16w600(black),
                                                                                                      ),
                                                                                                      TextButton(
                                                                                                          onPressed: () {},
                                                                                                          child: Text(
                                                                                                            "Size chart",
                                                                                                            style: text14w400(Colors.blueAccent),
                                                                                                          ))
                                                                                                    ],
                                                                                                  ),
                                                                                                  Container(
                                                                                                    height: 40,
                                                                                                    child: ListView.builder(
                                                                                                      itemCount: 5,
                                                                                                      shrinkWrap: true,
                                                                                                      scrollDirection: Axis.horizontal,
                                                                                                      itemBuilder: (context, i) {
                                                                                                        return InkWell(
                                                                                                          onTap: () {
                                                                                                            setState(() {
                                                                                                              selectedSize = snapshot.data.docs[index]['size'][i];
                                                                                                            });
                                                                                                          },
                                                                                                          child: Container(
                                                                                                            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                                                            height: 35,
                                                                                                            width: 60,
                                                                                                            child: Center(
                                                                                                              child: Text(
                                                                                                                snapshot.data.docs[index]['size'][i].toString().toUpperCase(),
                                                                                                                style: text15w500(black),
                                                                                                              ),
                                                                                                            ),
                                                                                                            decoration: BoxDecoration(color: primaryColor, boxShadow: [
                                                                                                              BoxShadow(color: grey, blurRadius: 2),
                                                                                                            ]),
                                                                                                          ),
                                                                                                        );
                                                                                                      },
                                                                                                    ),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            verticalSpace(20),
                                                                                            ElevatedButton(
                                                                                                style: ElevatedButton.styleFrom(minimumSize: Size(width(context), 45), backgroundColor: primaryColor),
                                                                                                onPressed: () {
                                                                                                  if (selectedSize == null) {
                                                                                                    popBack(context);
                                                                                                    openSnackbar(context, "You haven't changed size", primaryColor);
                                                                                                  } else {
                                                                                                    popBack(context);
                                                                                                    openSnackbar(context, "You have changed size to ${selectedSize.toString().toUpperCase()}", primaryColor);
                                                                                                    updateSize(snapshot.data.docs[index]['pid']);
                                                                                                  }
                                                                                                },
                                                                                                child: Text(
                                                                                                  "Update",
                                                                                                  style: text16w600(black),
                                                                                                ))
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(color: primaryColor, boxShadow: [
                                                                                BoxShadow(color: grey, blurRadius: 1)
                                                                              ]),
                                                                              width: 75,
                                                                              height: 25,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    "Size: ${snapshot.data.docs[index]['selectedSize'].toString().toUpperCase()}",
                                                                                    style: text12w400(black),
                                                                                  ),
                                                                                  horizontalSpace(2),
                                                                                  Icon(
                                                                                    CupertinoIcons.chevron_down,
                                                                                    size: 12,
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : horizontalSpace(
                                                                            0),
                                                                    horizontalSpace(
                                                                        20),
                                                                    Container(
                                                                      width: 75,
                                                                      height:
                                                                          25,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              color: primaryColor),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          InkWell(
                                                                              onTap: () async {
                                                                                if (snapshot.data.docs[index]['qty'] > 1) {
                                                                                  updateQTY(snapshot.data.docs[index]['pid'], snapshot.data.docs[index]['qty'] - 1);
                                                                                }
                                                                              },
                                                                              child: Icon(Icons.remove)),
                                                                          Container(
                                                                            width:
                                                                                25,
                                                                            child:
                                                                                Center(
                                                                              child: Text(snapshot.data.docs[index]['qty'].toString()),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                              onTap: () async {
                                                                                if (snapshot.data.docs[index]['qty'] < 5) {
                                                                                  updateQTY(snapshot.data.docs[index]['pid'], snapshot.data.docs[index]['qty'] + 1);
                                                                                }
                                                                              },
                                                                              child: Icon(Icons.add)),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                verticalSpace(
                                                                    7),
                                                                Text.rich(TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                          text:
                                                                              "\u20B9 ${snapshot.data.docs[index]['price']} ",
                                                                          style:
                                                                              text12w500(black)),
                                                                      TextSpan(
                                                                          text:
                                                                              "\u20B9 ${snapshot.data.docs[index]['previous price']}",
                                                                          style: text10w500(
                                                                              grey,
                                                                              decoration: TextDecoration.lineThrough))
                                                                    ])),
                                                                verticalSpace(
                                                                    4),
                                                                Text(
                                                                    "Delivery by 11th May 2023",
                                                                    style: text12w400(
                                                                        grey)),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : Container(
                                                        child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    progressIndicatorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return Container(
                                                                        color:
                                                                            backgroundColor,
                                                                      );
                                                                    },
                                                                    imageUrl: snapshot
                                                                            .data
                                                                            .docs[index]
                                                                        [
                                                                        'class_image'],
                                                                    height: 60,
                                                                    width: 60,
                                                                  ),
                                                                  Checkbox(
                                                                    side: BorderSide(
                                                                        color:
                                                                            white,
                                                                        width:
                                                                            2),
                                                                    activeColor:
                                                                        primaryColor,
                                                                    checkColor:
                                                                        black,
                                                                    value: snapshot
                                                                            .data
                                                                            .docs[index]
                                                                        [
                                                                        'isSelected'],
                                                                    onChanged:
                                                                        (value) {
                                                                      seDeSeProduct(
                                                                          snapshot
                                                                              .data
                                                                              .docs[index]['pid'],
                                                                          value!);
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                              horizontalSpace(
                                                                  8),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "${snapshot.data.docs[index]['class_name']}"
                                                                              .toUpperCase(),
                                                                          style:
                                                                              text15w500(black),
                                                                        ),
                                                                        snapshot.data.docs[index]['isSelected']
                                                                            ? InkWell(
                                                                                onTap: () {
                                                                                  removeProduct(snapshot.data.docs[index]['pid']);
                                                                                },
                                                                                child: Icon(Icons.delete),
                                                                              )
                                                                            : horizontalSpace(0),
                                                                      ],
                                                                    ),
                                                                    verticalSpace(
                                                                        4),
                                                                    Text(
                                                                        "\u20b9 ${snapshot.data.docs[index]['price']}")
                                                                  ],
                                                                ),
                                                              ),
                                                            ]),
                                                      );
                                              },
                                            ),
                                          ])
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: white2,
                                          boxShadow: [
                                            BoxShadow(
                                                color: grey.withOpacity(.05),
                                                blurRadius: 1)
                                          ]),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: primaryColor,
                                          radius: 25,
                                          child: Image.asset(
                                            "assets/promo-code.png",
                                            width: 30,
                                          ),
                                        ),
                                        title: Text("APPLY VOUCHER CODE"),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 15,
                                          color: black,
                                        ),
                                      ),
                                    ),
                                    verticalSpace(20),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 14),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: white2,
                                          boxShadow: [
                                            BoxShadow(
                                                color: grey.withOpacity(.05),
                                                blurRadius: 1)
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Order Summary",
                                            style: text14w500(black),
                                          ),
                                          verticalSpace(10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Total price (Inc GST)",
                                                style: text12w400(
                                                    grey.withOpacity(.8)),
                                              ),
                                              Text(
                                                "\u20B9 ${total}",
                                                style: text12w400(black),
                                              )
                                            ],
                                          ),
                                          verticalSpace(10),
                                          // rtotal != 0
                                          //     ? Row(
                                          //         mainAxisAlignment:
                                          //             MainAxisAlignment
                                          //                 .spaceBetween,
                                          //         children: [
                                          //           Text(
                                          //             "Discount",
                                          //             style: text14w700(
                                          //                 Colors.green),
                                          //           ),
                                          //           Text(
                                          //             "- \u20B9 ${rtotal - total}",
                                          //             style: text14w700(
                                          //                 Colors.green),
                                          //           )
                                          //         ],
                                          //       )
                                          //     : horizontalSpace(0),
                                          // verticalSpace(12),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Text(
                                          //       "Estimated Delivery Fee",
                                          //       style: text14w400(black),
                                          //     ),
                                          //     Text(
                                          //       "\u20B9 ${charge}",
                                          //       style: text14w500(black),
                                          //     )
                                          //   ],
                                          // ),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Total"),
                                              Text(
                                                "\u20B9 ${total}",
                                                style: text14w700(black),
                                              )
                                            ],
                                          ),
                                          verticalSpace(15),
                                          // ElevatedButton(
                                          //     style: ElevatedButton.styleFrom(
                                          //         elevation: 0,
                                          //         shape: RoundedRectangleBorder(
                                          //             borderRadius:
                                          //                 BorderRadius.circular(
                                          //                     10)),
                                          //         backgroundColor: primaryColor
                                          //             .withOpacity(.8),
                                          //         minimumSize:
                                          //             Size(width(context), 45)),
                                          //     onPressed: () {},
                                          //     child: Text(
                                          //         "You save \u20B9 ${rtotal - totalamount} on your order"))
                                        ],
                                      ),
                                    ),
                                    verticalSpace(20),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: white2,
                                          boxShadow: [
                                            BoxShadow(
                                                color: grey.withOpacity(.05),
                                                blurRadius: 1)
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: primaryColor,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: grey
                                                            .withOpacity(.05),
                                                        blurRadius: 1)
                                                  ]),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "OUR",
                                                    style: text12w400(black),
                                                  ),
                                                  verticalSpace(5),
                                                  Text(
                                                    "PROMISE",
                                                    style: text16w600(black),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          horizontalSpace(7),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: primaryColor,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: grey
                                                            .withOpacity(.05),
                                                        blurRadius: 1)
                                                  ]),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.security_outlined),
                                                  verticalSpace(7),
                                                  Text(
                                                    "100% Secure\nPayments",
                                                    style: text12w400(black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          horizontalSpace(7),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: primaryColor,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: grey
                                                            .withOpacity(.05),
                                                        blurRadius: 1)
                                                  ]),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons
                                                      .swap_horizontal_circle_outlined),
                                                  verticalSpace(7),
                                                  Text(
                                                    "Easy Returns",
                                                    style: text12w400(black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    verticalSpace(20),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: white2,
                                          boxShadow: [
                                            BoxShadow(
                                                color: grey.withOpacity(.05),
                                                blurRadius: 1)
                                          ]),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: Icon(
                                              Icons.verified_user,
                                              color: primaryColor,
                                              size: 40,
                                            ),
                                            title: Text(
                                              "100% SECURE TRANSACTION",
                                              style: text16w600(black),
                                            ),
                                            subtitle: Text(
                                              "Secure SSL Encryption",
                                              style: text12w400(grey),
                                            ),
                                          ),
                                          verticalSpace(15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: width(context) * .285,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: white2,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: grey,
                                                          blurRadius: 1)
                                                    ]),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons
                                                        .credit_card_outlined),
                                                    horizontalSpace(5),
                                                    Text(
                                                      "CREDIT/\nDEBIT CARD",
                                                      style: text10w400(black),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: width(context) * .275,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: white2,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: grey,
                                                          blurRadius: 1)
                                                    ]),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons
                                                        .account_balance_outlined),
                                                    horizontalSpace(5),
                                                    Text(
                                                      "NET\nBANKING",
                                                      style: text10w400(black),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: width(context) * .2,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: white2,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: grey,
                                                          blurRadius: 1)
                                                    ]),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Transform.rotate(
                                                      angle:
                                                          350 * math.pi / 180,
                                                      child: Container(
                                                        width: 30,
                                                        child: Stack(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .play_arrow_rounded,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .centerEnd,
                                                              child: Icon(
                                                                Icons
                                                                    .play_arrow_rounded,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "UPI",
                                                      style: text10w400(black),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    verticalSpace(20)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: Container(
                              color: grey.withOpacity(.05),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                    color: white2,
                                    borderRadius: BorderRadius.circular(5)),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                height: 80,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "\u20B9 ${total}",
                                          style: text15w500(black),
                                        ),
                                        Text(
                                          "View Details",
                                          style: text16w500(Colors.blueAccent),
                                        )
                                      ],
                                    ),
                                    horizontalSpace(15),
                                    Expanded(
                                      child: InkWell(
                                        onTap: itemSelected != 0
                                            ? () {
                                                // NextScreen(
                                                //     context,
                                                //     PaymentPage(
                                                //       userId:
                                                //           widget.id.toString(),
                                                //       totalPrice: total.toInt(),
                                                //       productList: pOrder,
                                                //     ));
                                                NextScreen(
                                                    context,
                                                    GetPaymentInfo(
                                                      amount: total.toString(),
                                                      product: [
                                                        {"type": "order"}
                                                      ],
                                                    ));
                                              }
                                            : null,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: grey, blurRadius: 2)
                                              ],
                                              color: itemSelected == 0
                                                  ? primaryColor.withOpacity(.5)
                                                  : primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          height: 60,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "PROCEED TO CHECKOUT",
                                                style: text15w500(black),
                                              ),
                                              horizontalSpace(8),
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 16,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
              : horizontalSpace(0);
        },
      ),
    );
  }
}
