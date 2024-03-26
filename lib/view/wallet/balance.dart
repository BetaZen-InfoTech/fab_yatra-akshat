import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fabyatra/loading.dart';
import 'package:fabyatra/utils/constant/index.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class balance extends StatefulWidget {
  const balance({super.key});

  @override
  State<balance> createState() => _balanceState();
}

class MyTextSample {
  static TextStyle? display4(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge;
  }

  static TextStyle? display3(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium;
  }

  static TextStyle? display2(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall;
  }

  static TextStyle? display1(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle? headline(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall;
  }

  static TextStyle? title(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge;
  }

  static TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      fontSize: 18,
    );
  }

  static TextStyle? subhead(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium;
  }

  static TextStyle? body2(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge;
  }

  static TextStyle? body1(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium;
  }

  static TextStyle? caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall;
  }

  static TextStyle? button(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(letterSpacing: 1);
  }

  static TextStyle? subtitle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall;
  }

  static TextStyle? overline(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall;
  }
}

class _balanceState extends State<balance> {
  DatabaseReference ref = FirebaseDatabase.instance
      .ref()
      .child("${GlobalVariable.appType}/project-backend")
      .child("account/user-data/user");
  String uid = "";
  bool showLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    firstData();
  }

  Map busDetails = {};

  double defaultRadius = 0;

  /// returns Radius
  BorderRadius radius([double? radius]) {
    return BorderRadius.all(radiusCircular(radius ?? defaultRadius));
  }

  /// returns Radius
  Radius radiusCircular([double? radius]) {
    return Radius.circular(radius ?? defaultRadius);
  }

  double walletBalance = 0.00;

  List allData = [];



  Future<void> firstData() async {
    setState(() {
      showLoading = true;
    });


    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid')!;
    setState(() {
      uid = prefs.getString('uid')!;
    });
    if (uid == "") {
      return;
    }

    Stream<DatabaseEvent> stream1 =
        ref.child(uid).child("wallet").onValue;

    stream1.listen((DatabaseEvent event1) {
      String data1 = event1.snapshot.value.toString();

      if(data1 == "null"){
        ref.child(uid).update({
          "wallet":"0.00"
        });
      }else{
        walletBalance = double.parse(data1);
        setState(() {

        });
      }

    });


    Stream<DatabaseEvent> stream2 =
        ref.child(uid).child("wallet-history").onValue;

    stream2.listen((DatabaseEvent event2) {

      if(event2.snapshot.value != "null"){

        Map data1 = event2.snapshot.value as Map;

        allData = data1.values.toList();

        setState(() {

        });

      }


    });

    setState(() {
      showLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade800,
                    ),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 70,
                            ),
                            Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Your wallet",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),



                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 125,
                  ),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Text(
                            "₹ $walletBalance",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        Text(
                          "FabYatra Travel Balance",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              // child: RecentTransactions(),
              child: Recentt(),
            ),
          ],
        ),
      ),
    );
  }

  Recentt() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Recent Transaction",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => WithdrawHistory(
                  //       busId: widget.busId,
                  //     ),
                  //   ),
                  // );
                },
                icon: Icon(Icons.refresh_outlined),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 480,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: allData.length,
              itemBuilder: (BuildContext context, int index) {
                Map data = allData[index];
                print("data");
                print(data);


                int times = 0;
                if (data["time"].runtimeType == int) {
                  times = data["time"];
                } else {
                  times = int.parse(data["time"]);
                }

                String month = DateFormat('MMM')
                    .format(DateTime.fromMillisecondsSinceEpoch(times))
                    .toString();
                String year = DateFormat('yyyy')
                    .format(DateTime.fromMillisecondsSinceEpoch(times))
                    .toString();
                String date = DateFormat('d')
                    .format(DateTime.fromMillisecondsSinceEpoch(times))
                    .toString();

                return Padding(
                  padding: const EdgeInsets.only(
                    top: 1,
                    bottom: 1,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    left: 10,
                                  ),
                                  child: Container(
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${month}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '${date}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${year}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                            Container(
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 110,
                                        child: Text(
                                          "Txn Details: ${data["type"]}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Container(
                                        width: 110,
                                        child: Text(
                                          "${data["note"]}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                    ],
                                  ),
                                ),

                                const Spacer(),


                                Container(
                                  width: 75,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  // child: Center(
                                  //   child: Text(
                                  //     "Added",
                                  //     style: TextStyle(
                                  //         fontSize: 11,
                                  //         color: Colors.blue,
                                  //         fontWeight: FontWeight.w500),
                                  //   ),
                                  // ),
                                )


                                // Container(
                                //   width: 75,
                                //   decoration: BoxDecoration(
                                //     color: Colors.yellow.shade100,
                                //     borderRadius:
                                //     BorderRadius.circular(20),
                                //   ),
                                //   child: Center(
                                //     child: Text(
                                //       "processing",
                                //       style: TextStyle(
                                //           fontSize: 11,
                                //           color: Colors.deepOrange,
                                //           fontWeight:
                                //           FontWeight.w500),
                                //     ),
                                //   ),
                                // )


                                // Container(
                                //   width: 75,
                                //   decoration: BoxDecoration(
                                //     color: Colors.green.shade100,
                                //     borderRadius:
                                //     BorderRadius.circular(20),
                                //   ),
                                //   child: Center(
                                //     child: Text(
                                //       "Completed",
                                //       style: TextStyle(
                                //           fontSize: 11,
                                //           color: Colors.green,
                                //           fontWeight:
                                //           FontWeight.w500),
                                //     ),
                                //   ),
                                // )
                                //
                                //
                                // Container(
                                //   width: 75,
                                //   decoration: BoxDecoration(
                                //     color:
                                //     Colors.red.shade100,
                                //     borderRadius:
                                //     BorderRadius.circular(
                                //         20),
                                //   ),
                                //   child: Center(
                                //     child: Text(
                                //       "${data["status"]}",
                                //       style: TextStyle(
                                //           fontSize: 11,
                                //           color: Colors.red,
                                //           fontWeight:
                                //           FontWeight
                                //               .w500),
                                //     ),
                                //   ),
                                // )
                                //
                                // Container(
                                //   width: 60,
                                //   decoration: BoxDecoration(
                                //     color:
                                //     Colors.red.shade100,
                                //     borderRadius:
                                //     BorderRadius.circular(
                                //         20),
                                //   ),
                                //   child: Center(
                                //     child: Text(
                                //       "${data["status"]}",
                                //       style: TextStyle(
                                //           fontSize: 11,
                                //           color: Colors.red,
                                //           fontWeight:
                                //           FontWeight
                                //               .w500),
                                //     ),
                                //   ),
                                // )

                                ,




                                const Spacer(),
                                Container(
                                  child: Text(
                                    "${data["amount"]}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}