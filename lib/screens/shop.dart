import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final pageController = PageController();
  final _controller = CarouselController();
  List list = [
    Container(
      alignment: AlignmentDirectional.bottomCenter,
      height: 200,
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
      ),
    ),
    Container(
      height: 200,
      alignment: AlignmentDirectional.bottomCenter,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
      ),
    ),
    Container(
      alignment: AlignmentDirectional.bottomCenter,
      height: 200,
      color: grey,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
      ),
    ),
    Container(
      alignment: AlignmentDirectional.bottomCenter,
      height: 200,
      color: white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
      ),
    ),
  ];
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: white2, boxShadow: [
                BoxShadow(
                    color: white, blurRadius: 5, blurStyle: BlurStyle.outer)
              ]),
              height: 200,
              width: width(context),
              child: Stack(
                children: [
                  CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                        viewportFraction: 1,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        height: MediaQuery.of(context).size.height * 0.3,
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
                              i,
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        height: 10,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: black.withOpacity(.2)),
                        child: Center(
                          child: CarouselIndicator(
                            space: 10,
                            height: 9,
                            width: 9,
                            activeColor: white,
                            color: grey,
                            count: list.length,
                            index: _current,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(15),
            Container(
              decoration: BoxDecoration(color: primaryColor, boxShadow: [
                BoxShadow(
                    color: grey, blurRadius: 5, blurStyle: BlurStyle.outer)
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recommended Items",
                          style: text16w600(black),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 12,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: width(context) * .27 / 120,
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: white2,
                            boxShadow: [
                              BoxShadow(
                                  color: grey,
                                  blurRadius: 1,
                                  blurStyle: BlurStyle.outer)
                            ]),
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: Center(
                                child: Image.asset(
                                  "assets/tshirt.jpg",
                                  height: 100,
                                ),
                              ),
                            ),
                            verticalSpace(10),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sport T-shirt",
                                    style: text14w500(black,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "799",
                                        style: text10w500(grey,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                      horizontalSpace(10),
                                      Text(
                                        "\u20B9 599 /- Only",
                                        style: text10w500(grey),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Free Delivery",
                                    style: text12w400(black),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  verticalSpace(15)
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: white2, boxShadow: [
                BoxShadow(
                    color: grey, blurRadius: 5, blurStyle: BlurStyle.outer)
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Top Rated",
                          style: text16w600(black),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 12,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 9,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: width(context) * .24 / 120,
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(color: white, boxShadow: [
                          BoxShadow(
                              color: grey,
                              blurRadius: 1,
                              blurStyle: BlurStyle.outer)
                        ]),
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: Center(
                                child: Image.asset(
                                  "assets/tshirt.jpg",
                                  height: 50,
                                ),
                              ),
                            ),
                            verticalSpace(10),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sport T-shirt",
                                    style: text14w500(black,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "799",
                                        style: text10w500(grey,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                      horizontalSpace(4),
                                      Text(
                                        "\u20B9 599 /- Only",
                                        style: text10w500(grey),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Free Delivery",
                                    style: text12w400(black),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  verticalSpace(15)
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.pink.shade200,
                  boxShadow: [
                    BoxShadow(
                        color: grey, blurRadius: 5, blurStyle: BlurStyle.outer)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Best Quality",
                          style: text16w600(white),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 12,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 6,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: width(context) * .27 / 120,
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: white2,
                            boxShadow: [
                              BoxShadow(
                                  color: grey,
                                  blurRadius: 1,
                                  blurStyle: BlurStyle.outer)
                            ]),
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: Center(
                                child: Image.asset(
                                  "assets/tshirt.jpg",
                                  height: 100,
                                ),
                              ),
                            ),
                            verticalSpace(10),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sport T-shirt",
                                    style: text14w500(black,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "799",
                                        style: text10w500(grey,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                      horizontalSpace(4),
                                      Text(
                                        "\u20B9 599 /- Only",
                                        style: text10w500(grey),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Free Delivery",
                                    style: text12w400(black),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              color: white2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace(15),
                    Text(
                      "Recently Viewed",
                      style: text16w500(black),
                    ),
                    verticalSpace(5),
                    Container(
                        height: 175,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) {
                            return horizontalSpace(12);
                          },
                          itemCount: 12,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: white2,
                                  boxShadow: [
                                    BoxShadow(
                                        color: grey,
                                        blurRadius: 1,
                                        blurStyle: BlurStyle.outer)
                                  ]),
                              width: 120,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 20),
                                    child: Center(
                                      child: Image.asset(
                                        "assets/tshirt.jpg",
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                  verticalSpace(10),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sport T-shirt",
                                          style: text14w500(black,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "799",
                                              style: text10w500(grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                            horizontalSpace(4),
                                            Text(
                                              "\u20B9 599 /- Only",
                                              style: text10w500(grey),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "Free Delivery",
                                          style: text12w400(black),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
