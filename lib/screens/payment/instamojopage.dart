import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:little_leagues/screens/payment/paymentsuccess.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:little_leagues/widgets/showsnackbar.dart';

class InstaMojoPage extends StatefulWidget {
  final List checkList;
  final List getData;
  const InstaMojoPage(
      {super.key, required this.getData, required this.checkList});
  @override
  _InstaMojoPageState createState() => _InstaMojoPageState();
}

bool isLoading = true; //this can be declared outside the class

class _InstaMojoPageState extends State<InstaMojoPage> {
  final user = FirebaseAuth.instance.currentUser;
  late AnimationController _controller;
  String? selectedUrl;
  double progress = 0;
  String? txnId;
  bool isPaymentDone = false;

  nextInstallment() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("enrolled_classes")
        .doc(widget.checkList[0]['id'])
        .update({
      "next_pay_date":
          widget.checkList[0]['date'].toDate().add(Duration(days: 30))
    });
    paymentHistory(txnId!, "sport next installment");
  }

  makePayment() async {
    final orderSelected = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("cart")
        .where("isSelected", isEqualTo: true)
        .get();
    for (int i = 0; i < orderSelected.docs.length; i++) {
      if (orderSelected.docs[i]['item'] == "class") {
        final event = await FirebaseFirestore.instance
            .collection("sport_classes")
            .doc(orderSelected.docs[i]['pid'])
            .get();
        final data = event.data() as Map<String, dynamic>;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .collection("enrolled_classes")
            .doc(orderSelected.docs[i]['pid'])
            .set({
          "class_days": data['class_days'],
          "class_desc": data['class_desc'],
          "class_id": data['class_id'],
          "class_image": data['class_image'],
          "class_name": data['class_name'],
          "end_time": data['end_time'],
          "price": data['price'],
          "start_time": data['start_time'],
          "start_date": DateTime.now(),
          "next_pay_date": DateTime.now().add(Duration(days: 30))
        });
      }
      final product = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("cart")
          .doc(orderSelected.docs[i]['pid'])
          .get();
      final data = product.data() as Map<String, dynamic>;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("orderTable")
          .doc(orderSelected.docs[i]['pid'])
          .set({
        "pid": data['pid'],
        "class_image": data['class_image'],
        "class_name": data['class_name'],
        "price": data['price'],
        "order_date": DateTime.now()
      });
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("cart")
          .doc(orderSelected.docs[i]['pid'])
          .delete();
    }
    paymentHistory(txnId!, "Sport Registration");
  }

  paymentHistory(String tId, String details) async {
    String dayHistory = DateFormat.yMMMMd().format(DateTime.now());
    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("payment_history")
        .doc(dayHistory)
        .get();
    if (!snap.exists) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("payment_history")
          .doc(dayHistory)
          .set({"allEntries": [], "time": DateTime.now()});
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("payment_history")
        .doc(dayHistory)
        .update({
      "allEntries": FieldValue.arrayUnion([
        {
          "transaction_id": tId,
          "transaction_details": details,
          "payment": "\u20B9 ${widget.getData[0]['amount']}",
          "time": DateTime.now()
        }
      ])
    });
  }

  @override
  void initState() {
    super.initState();
    isPaymentDone = false;
    isLoading = true;
    // print(widget.data!['name']);
    // _controller = AnimationController(
    //   vsync: this,
    //   lowerBound: 0.5,
    //   duration: const Duration(milliseconds: 500),
    // )..repeat();

    createRequest();

    //creating the HTTP request
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Pay"),
      ),
      body: Container(
        child: Center(
          child: isLoading
              ? //check loadind status
              CircularProgressIndicator(
                  color: grey,
                )
              : InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: Uri.tryParse(selectedUrl ?? ""),
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {},
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  onUpdateVisitedHistory: (controller, uri, androidIsReload) {
                    String url = uri.toString();
                    // print(uri);
                    // uri containts newly loaded url
                    if (mounted) {
                      if (url.contains('https://www.google.com/')) {
//Take the payment_id parameter of the url.
                        String paymentRequestId =
                            uri!.queryParameters['payment_id']!;
                        setState(() {
                          txnId = paymentRequestId;
                          isPaymentDone = !isPaymentDone;
                        });

                        // print("value is: " + paymentRequestId);

//calling this method to check payment status
                        isPaymentDone
                            ? _checkPaymentStatus(paymentRequestId)
                            : null;
                      }
                    }
                  },
                ),
        ),
      ),
    );
  }

  _checkPaymentStatus(String id) async {
    var response = await http.get(
        Uri.parse("https://www.instamojo.com/api/1.1/payments/$id/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "dd4acaba7e17bfe6eb84048db925051b",
          "X-Auth-Token": "a4243b422b9b4312f9a1f534ba8b36b7"
        });
    var realResponse = json.decode(response.body);
    print(realResponse);
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
        // print('sucesssssssssssful');
        if (widget.checkList[0]['type'] == "installment") {
          nextInstallment();
        } else {
          makePayment();
        }
        nextScreenReplace(
            context,
            PaymentSuccessPage(
              isDone: true,
              id: user!.uid,
            ));
//payment is successful.
      } else {
        // await makePayment();
        nextScreenReplace(
            context,
            PaymentSuccessPage(
              isDone: false,
              id: user!.uid,
            ));
      }
    } else {
      print("PAYMENT STATUS FAILED");
      nextScreenReplace(
          context,
          PaymentSuccessPage(
            isDone: false,
            id: user!.uid,
          ));
    }
  }

  Future createRequest() async {
    Map<String, String> body = {
      "amount": widget.getData[0]['amount'], //amount to be paid
      "purpose": widget.getData[0]['desc'],
      "buyer_name": widget.getData[0]['name'],
      "email": widget.getData[0]['email'],
      "phone": widget.getData[0]['phone'],
      "allow_repeated_payments": "true",
      "send_email": "true",
      "send_sms": "true",
      "redirect_url": "https://www.google.com/",
      //Where to redirect after a successful payment.
      "webhook": "https://littleleagues.live/",
    };
//First we have to create a Payment_Request.
//then we'll take the response of our request.
    var resp = await http
        .post(Uri.parse("https://www.instamojo.com/api/1.1/payment-requests/"),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/x-www-form-urlencoded",
              "X-Api-Key": "dd4acaba7e17bfe6eb84048db925051b",
              "X-Auth-Token": "a4243b422b9b4312f9a1f534ba8b36b7"
            },
            body: body)
        .catchError((e) {
      print(e);
    });
    if (json.decode(resp.body)['success'] == true) {
//If request is successful take the longurl.
      setState(() {
        isLoading = false; //setting state to false after data loaded

        selectedUrl =
            json.decode(resp.body)["payment_request"]['longurl'].toString() +
                "?embed=form";
      });
      print(json.decode(resp.body)['message'].toString());
    }
  }
}
