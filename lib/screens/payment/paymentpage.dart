import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:little_leagues/widgets/showsnackbar.dart';
import 'package:upi_india/upi_india.dart';
import 'package:upi_india/upi_response.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final String sportId;
  final String? sportName;
  const PaymentPage({super.key, required this.sportId, this.sportName});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? txnId;

  joinClass() async {
    final event = await FirebaseFirestore.instance
        .collection("classes")
        .doc(widget.sportId)
        .get();
    final data = event.data() as Map<String, dynamic>;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("enrolled_classes")
        .doc(widget.sportId)
        .set({
      "class_days": data['class_days'],
      "class_id": data['class_id'],
      "class_image": data['class_image'],
      "class_name": data['class_name'],
      "end_time": data['end_time'],
      "start_time": data['start_time'],
      "start_date": DateTime.now(),
      "next_pay_date": DateTime.now().add(Duration(days: 30))
    });

    paymentHistory(txnId!);

    openSnackbar(
        context,
        "You have registered class successfully.\nEnjoy your sports days.",
        primaryColor);
  }

  paymentHistory(String tId) async {
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
          .set({"allEntries": []});
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
          "transaction_details": "${widget.sportName} sport registration",
          "payment": "\u20B9 150",
          "time": DateTime.now()
        }
      ])
    });
  }

  final user = FirebaseAuth.instance.currentUser;
  String? id;
  Future<UpiResponse>? _transaction;
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  @override
  void initState() {
    // TODO: implement initState
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      print(e);
      apps = [];
      setState(() {});
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
        app: app,
        receiverUpiId: "8445589271@paytm",
        receiverName: 'Kapil Kumar',
        transactionRefId: 'LittleLeaguesLive',
        transactionNote: 'Sport registration.',
        amount: 1.00,
        flexibleAmount: true);
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps!.length == 0)
      return Center(
        child: Container(
          decoration: BoxDecoration(color: black, boxShadow: [
            BoxShadow(color: primaryColor, blurRadius: 2, spreadRadius: 2)
          ]),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            "No apps found to handle transaction.",
            style: text16w500(primaryColor),
          ),
        ),
      );
    else
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: white2, blurRadius: 2, spreadRadius: 2)
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      verticalSpace(10),
                      Text(
                        app.name,
                        style: text15w400(white2),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        joinClass();
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        break;
      default:
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: text16w500(white)),
          Flexible(
              child: Text(
            body,
            style: text16w500(white2),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: transparentColor,
        elevation: 0,
        foregroundColor: white2,
        title: Text('UPI'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: displayUpiApps(),
          ),
          Expanded(
            child: FutureBuilder(
              future: _transaction,
              builder:
                  (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        _upiErrorHandler(snapshot.error.runtimeType),
                        style: text18w500(white2),
                      ), // Print's text message on screen
                    );
                  }

                  // If we have data then definitely we will have UpiResponse.
                  // It cannot be null
                  UpiResponse _upiResponse = snapshot.data!;

                  // Data in UpiResponse can be null. Check before printing
                  txnId = _upiResponse.transactionId ?? 'N/A';
                  String resCode = _upiResponse.responseCode ?? 'N/A';
                  String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                  String status = _upiResponse.status ?? 'N/A';
                  String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';

                  _checkTxnStatus(status);

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    decoration: BoxDecoration(
                        color: black,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: white2, blurRadius: 2, spreadRadius: 2)
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        displayTransactionData('Transaction Id', txnId),
                        Divider(
                          color: white,
                        ),
                        displayTransactionData('Response Code', resCode),
                        Divider(
                          color: white,
                        ),
                        displayTransactionData('Reference Id', txnRef),
                        Divider(
                          color: white,
                        ),
                        displayTransactionData('Status', status.toUpperCase()),
                        Divider(
                          color: white,
                        ),
                        displayTransactionData('Approval No', approvalRef),
                      ],
                    ),
                  );
                } else
                  return Center(
                    child: Text(''),
                  );
              },
            ),
          )
        ],
      ),
    );
  }
}
