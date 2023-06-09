import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/screens/messages.dart';
import 'package:little_leagues/screens/shop/yourcart.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:little_leagues/widgets/showsnackbar.dart';

class ItemDetailScreen extends StatefulWidget {
  final String pid;
  const ItemDetailScreen({super.key, required this.pid});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  Map<String, dynamic> productDetails = {};

  String groupId = "";
  String fullName = "";
  String? productSize;

  giveId() async {
    // print(user!.uid);
    if (user != null) {
      final userCollection = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();
      final data = userCollection.data() as Map<String, dynamic>;

      setState(() {
        fullName = data['fullName'];
      });

      setState(() {
        groupId = data['groupId'];
      });

      // print(groupId);
    }
  }

  String? selectedSize;

  addToCart() async {
    await userCollection.doc(user!.uid).collection("cart").doc(widget.pid).set({
      "bestseller": productDetails['bestseller'],
      "category": productDetails['category'],
      "desc": productDetails['desc'],
      "image": productDetails['image'],
      "name": productDetails['name'],
      "pid": productDetails['pid'],
      "price": productDetails['price'],
      "previous price": productDetails['previous price'],
      "rating": productDetails['rating'],
      "size": productDetails['size'],
      "type": productDetails['type'],
      "selectedSize": selectedSize == null ? "" : selectedSize,
      "qty": 1,
      "item": "product",
      'isSelected': true
    });
  }

  List<Widget> list = [];

  getProductDetails() async {
    final details = await FirebaseFirestore.instance
        .collection("category")
        .doc("n7H0jLmG0KalEBjVwLm8")
        .collection("most_explored_sports")
        .doc("hjcTx9LzVHpmul6lk233")
        .collection("products")
        .doc(widget.pid)
        .get();

    final data = details.data() as Map<String, dynamic>;
    setState(() {
      productDetails = data;
    });

    // Create for loop and store the urls in the list
    // if (productDetails['image'].length != null) {
    for (int i = 0; i < productDetails['image'].length; i++) {
      list.add(
        Container(
          height: 450,
          child: Image(
            image: NetworkImage(productDetails['image'][i]),
            height: 425,
            errorBuilder: (context, error, stackTrace) {
              return Text("data");
            },
            fit: BoxFit.contain,
            // width: width(context) - 20,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    giveId();
    getProductDetails();
    super.initState();
  }

  final _carouselController = CarouselController();

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white2,
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
      body: productDetails == null
          ? horizontalSpace(0)
          : SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 350,
                        color: grey.withOpacity(.2),
                        child: Stack(
                          children: [
                            CarouselSlider(
                              carouselController: _carouselController,
                              options: CarouselOptions(
                                  viewportFraction: 1,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  height: double.infinity,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                              items: list.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Stack(
                                      children: [
                                        Container(
                                          width: width(context),
                                          height: 350,
                                          child: i,
                                        )
                                      ],
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: white.withOpacity(.5),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(color: grey, blurRadius: 1),
                                    ],
                                  ),
                                  child: Center(
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.share_outlined,
                                          color: primaryColor,
                                          size: 18,
                                        )),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: width(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: grey.withOpacity(.25)),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.copy,
                                    size: 12,
                                    color: Colors.blueAccent,
                                  ),
                                  horizontalSpace(5),
                                  Text(
                                    "View Similar",
                                    style: text12w400(Colors.blueAccent),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 10,
                              width: 80,
                              child: CarouselIndicator(
                                space: 5,
                                height: 6,
                                width: 6,
                                activeColor: Colors.blueAccent,
                                color: Colors.blueAccent.withOpacity(.3),
                                count: list.length != 0 ? list.length : 1,
                                index: _current,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: grey.withOpacity(.25)),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 12,
                                    color: Colors.yellow,
                                  ),
                                  horizontalSpace(4),
                                  Text(
                                    productDetails['rating'].toString(),
                                    style: text12w400(black),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: white2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(productDetails['name'] ?? ""),
                                  Text(
                                    "ID: 89P13",
                                    style: text12w400(grey.withOpacity(.5)),
                                  )
                                ],
                              ),
                              verticalSpace(5),
                              Text(
                                productDetails['desc'] ?? "",
                                style: text18w500(black),
                              ),
                              verticalSpace(5),
                              Text(
                                "\u20B9 ${productDetails['price'] ?? ''}",
                                style: text10w500(black,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              verticalSpace(10),
                              Container(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  boxShadow: [
                                    BoxShadow(color: grey, blurRadius: 2),
                                  ],
                                ),
                                height: 30,
                                width: 75,
                                child: Center(
                                    child: Text(
                                  "\u20B9 ${productDetails['previous price'] ?? ''}",
                                  style: text18w500(black),
                                )),
                              )
                            ],
                          ),
                        ),
                      ),
                      verticalSpace(20),
                      Container(
                        color: white2,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                            productDetails['type'] == "upper" ||
                                    productDetails['type'] == "bottom"
                                ? Container(
                                    height: 35,
                                    child: ListView.builder(
                                      itemCount: productDetails['size'].length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedSize =
                                                  productDetails['size'][index];
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            height: 35,
                                            width: 60,
                                            child: Center(
                                              child: Text(
                                                productDetails['size'][index]
                                                    .toString()
                                                    .toUpperCase(),
                                                style: text15w500(black),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: primaryColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: grey,
                                                      blurRadius: 2),
                                                ]),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : horizontalSpace(0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(20),
                  Container(
                    color: white2,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DELIVERY & SERVICES",
                          style: text16w600(black),
                        ),
                        verticalSpace(20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: grey.withOpacity(.4))),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: "Pin",
                                border: InputBorder.none,
                                suffixIcon: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Change",
                                      style: text14w400(Colors.blueAccent),
                                    ))),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text("Home Delivery by Tomorrow"),
                          subtitle: Text("Order by 06:00 PM"),
                          leading: Container(
                              height: 40,
                              child: Icon(
                                Icons.delivery_dining_rounded,
                                color: Colors.red,
                              ),
                              width: 40,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: grey, blurRadius: 2),
                                  ],
                                  color: white,
                                  borderRadius: BorderRadius.circular(4))),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text("Free Pickup in Store Available"),
                          trailing: TextButton(
                              onPressed: () {},
                              child: Text(
                                "View stores",
                                style: text10w400(Colors.blueAccent),
                              )),
                          leading: Container(
                              height: 40,
                              child: Icon(
                                Icons.store,
                                color: Colors.red,
                              ),
                              width: 40,
                              decoration: BoxDecoration(
                                  color: white,
                                  boxShadow: [
                                    BoxShadow(color: grey, blurRadius: 2),
                                  ],
                                  borderRadius: BorderRadius.circular(4))),
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(20),
                  Container(
                    width: width(context),
                    color: white2,
                    padding: EdgeInsets.symmetric(vertical: 35),
                    child: Column(children: [
                      Text(
                        "Still confused? Need Assistance?",
                        style: text16w600(black),
                      ),
                      verticalSpace(15),
                      InkWell(
                        onTap: () {
                          NextScreen(
                              context,
                              MessagePage(
                                  height: height(context) - 70,
                                  groupId: groupId,
                                  groupName: FirebaseAuth
                                          .instance.currentUser!.uid
                                          .toString() +
                                      fullName,
                                  userName: fullName));
                        },
                        child: Container(
                          height: 40,
                          width: 150,
                          child: Center(
                            child: Text(
                              "CHAT WITH US",
                              style: text14w800(black),
                            ),
                          ),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: grey, blurRadius: 2),
                              ],
                              color: primaryColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                        ),
                      )
                    ]),
                  ),
                  verticalSpace(20)
                ],
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: white,
          height: 80,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: white2,
                boxShadow: [
                  BoxShadow(color: grey, blurRadius: 5, offset: Offset(1, 1))
                ]),
            margin: EdgeInsets.only(right: 12, top: 10, left: 12, bottom: 15),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite_border_rounded)),
                  decoration: BoxDecoration(
                      color: white2,
                      boxShadow: [BoxShadow(color: grey, blurRadius: 2)],
                      border: Border.all(
                        color: grey.withOpacity(.4),
                      ),
                      borderRadius: BorderRadius.circular(7)),
                ),
                horizontalSpace(10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (productDetails['type'] == "upper" ||
                          productDetails['type'] == "bottom") {
                        if (selectedSize == null) {
                          openSnackbar(
                              context, "Please Select the size", primaryColor);
                        } else {
                          addToCart();
                          showModalBottomSheet(
                            backgroundColor: transparentColor,
                            isDismissible: false,
                            context: context,
                            builder: (context) {
                              return ShowBottomSheet();
                            },
                          );
                        }
                      } else {
                        addToCart();
                        showModalBottomSheet(
                          backgroundColor: transparentColor,
                          isDismissible: false,
                          context: context,
                          builder: (context) {
                            return ShowBottomSheet();
                          },
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [BoxShadow(color: grey, blurRadius: 2)],
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(2)),
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add to cart",
                            style: text18w500(black),
                          ),
                          horizontalSpace(8),
                          Icon(Icons.shopping_cart_outlined)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ShowBottomSheet() {
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
          color: white2,
          child: Column(
            children: [
              verticalSpace(15),
              InkWell(
                onTap: () {
                  popBack(context);
                  NextScreen(context, YourCart());
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: grey, blurRadius: 2)],
                      color: black,
                      borderRadius: BorderRadius.circular(2)),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.red,
                      ),
                      horizontalSpace(8),
                      Text(
                        "Item has been added",
                        style: text18w500(white2),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  popBack(context);
                  NextScreen(context, YourCart());
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: grey, blurRadius: 2)],
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(2)),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Go to cart",
                        style: text18w500(black),
                      ),
                      horizontalSpace(8),
                      Icon(Icons.arrow_forward)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
