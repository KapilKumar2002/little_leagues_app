import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_leagues/screens/payment/instamojopage.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:little_leagues/widgets/customdropdown.dart';

class GetPaymentInfo extends StatefulWidget {
  final List product;
  final String amount;
  const GetPaymentInfo(
      {super.key, required this.amount, required this.product});

  @override
  State<GetPaymentInfo> createState() => _GetPaymentInfoState();
}

class _GetPaymentInfoState extends State<GetPaymentInfo> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final descController = TextEditingController();
  static List list = ["Order", "Installment", "Others"];
  final key = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        foregroundColor: white,
        backgroundColor: transparentColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Payment Details'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Builder(
              builder: (context) => Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Name'),
                      // ignore: missing_return
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the name';
                        }
                        return null;
                      },
                    ),
                    verticalSpace(20),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Email Id'),
                      // ignore: missing_return
                      validator: validateEmail,
                    ),
                    verticalSpace(20),
                    TextFormField(
                      controller: numberController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Mobile Number'),
                      // ignore: missing_return
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the phone number.';
                        } else if (value.length < 10) {
                          return "Please enter a valid phone number";
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      readOnly: true,

                      initialValue: widget.amount,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      maxLengthEnforcement: MaxLengthEnforcement.none,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Amount'),
                      // ignore: missing_return
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the amount.';
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the purpose.';
                        }
                        return null;
                      },
                      controller: descController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Purpose'),
                    ),
                    // SwitchListTile(
                    //     title: Text(_data.isLive ?? false
                    //         ? 'Live Account'
                    //         : 'Test Account'),
                    //     value: _data.isLive ?? false,
                    //     onChanged: (bool val) =>
                    //         setState(() => _data.isLive = val)),
                    verticalSpace(height(context) * .25),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(width(context), 55),
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        onPressed: () {
                          final form = _formKey.currentState;
                          if (form!.validate()) {
                            NextScreen(
                                context,
                                InstaMojoPage(
                                  checkList: widget.product,
                                  getData: [
                                    {
                                      "name": nameController.text,
                                      "email": emailController.text,
                                      "amount": widget.amount,
                                      "phone": numberController.text,
                                      "desc": descController.text
                                    }
                                  ],
                                ));

                            form.save();
                          }
                        },
                        child: Text(
                          'Place Order',
                          style: text18w500(black),
                        )),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     child: Text("Response: $_paymentResponse")),
          const SizedBox(
            height: 30,
          ),
        ],
      )),
    );
  }

  String? validateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern as String);
    if (!regex.hasMatch(value!)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }
}
