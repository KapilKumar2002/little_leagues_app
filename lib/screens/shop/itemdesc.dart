import 'package:flutter/material.dart';
import 'package:little_leagues/screens/shop/resultscreen.dart';
import 'package:little_leagues/utils/constants.dart';

class ItemResultScreen extends StatefulWidget {
  const ItemResultScreen({super.key});

  @override
  State<ItemResultScreen> createState() => _ItemResultScreenState();
}

class _ItemResultScreenState extends State<ItemResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 320,
            child: Stack(children: [
              Image.asset(
                "assets/tablet.jpg",
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                height: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            popBack(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: white2,
                          )),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.search,
                                color: white2,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite_border_rounded,
                                color: white2,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                color: white2,
                              )),
                        ],
                      )
                    ]),
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: Container(
                  margin: EdgeInsets.only(top: 40),
                  height: 150,
                  child: Column(
                    children: [
                      Text(
                        "TABLE TENNIS",
                        style: text25Bold(white2),
                      ),
                      verticalSpace(18),
                      Text(
                        "Mark favorite",
                        style: text10w800(white2),
                      ),
                      verticalSpace(20),
                      Container(
                        height: 60,
                        width: 60,
                        color: white,
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite_rounded,
                              size: 45,
                              color: white2,
                            )),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: InkWell(
                    onTap: () {
                      NextScreen(context, ResultScreen());
                    },
                    child: Container(
                      height: 50,
                      color: primaryColor,
                      child: Center(
                        child: Text(
                          "View all products",
                          style: text14w500(black),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ListView(
              shrinkWrap: true,
              children: [
                InkWell(
                  onTap: () {
                    NextScreen(context, ResultScreen());
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "TABLE TENNIS TABLES",
                            style: text16w600(black),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                            size: 18,
                          )
                        ]),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    NextScreen(context, const ResultScreen());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "TABLE TENNIS TABLES",
                            style: text16w600(black),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                            size: 18,
                          )
                        ]),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    NextScreen(context, ResultScreen());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "TABLE TENNIS TABLES",
                            style: text16w600(black),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                            size: 18,
                          )
                        ]),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    NextScreen(context, const ResultScreen());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "TABLE TENNIS TABLES",
                            style: text16w600(black),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                            size: 18,
                          )
                        ]),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    NextScreen(context, const ResultScreen());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "TABLE TENNIS TABLES",
                            style: text16w600(black),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                            size: 18,
                          )
                        ]),
                  ),
                ),
                const Divider()
              ],
            ),
          )
        ],
      ),
    );
  }
}
