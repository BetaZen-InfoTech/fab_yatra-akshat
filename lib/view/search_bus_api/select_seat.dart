import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/loading.dart';
import 'package:fabyatra/view/search_bus_api/confirm_ticket.dart';
import 'package:http/http.dart' as http;

class SelectSeat extends StatefulWidget {
  const SelectSeat({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    required this.busDetails,
  });

  final Map busDetails;
  final String from;
  final String to;
  final String date;

  @override
  State<SelectSeat> createState() => _SelectSeatState();
}

class _SelectSeatState extends State<SelectSeat> {
  DatabaseReference ref = FirebaseDatabase.instance
      .ref()
      .child("${GlobalVariable.appType}/project-backend")
      .child("vehicle"); //Todo: change the type to Query

  List lowerSeat = [];
  bool showLoading = false;

  List selectSeatData = [];

  double seaterPrice = 0;
  int noOfColumn = 0;
  double myPrice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getData();
    fetchSeatLayout();
  }

  Future<void> fetchSeatLayout() async {
    var seatData = widget.busDetails["seatLayout"];
    noOfColumn = widget.busDetails["noOfColumn"];
    seaterPrice = widget.busDetails["ticketPrice"];

    print(seatData.length);
    print(noOfColumn);
    List oneRowData = [];
    int i = 1;
    oneRowData.clear();
    lowerSeat.clear();

    for (var oneDara in seatData) {
      print(oneDara);

      if (i < noOfColumn) {
        oneRowData.add(oneDara);
        i = i + 1;
        // print(oneDara);
        // print(oneRowData);
      } else if (i == noOfColumn) {
        oneRowData.add(oneDara);
        lowerSeat.add(oneRowData);

        oneRowData = [];
        setState(() {
          i = 1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Select Seat',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.amber.shade800,
          ),
          body: showLoading == true
              ? LottieDialog()
              : SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Important: Sometimes bus company is subject to change depending upon number of passengers and amount will be adjusted accordingly.",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 13 * widthP,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    // border: Border.all(color: Colors.grey),
                                    color: Colors.amber.shade800,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Available",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Selected",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Booked",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        Container(
                          // height: 550,
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: [
                                  for (var columns in lowerSeat) ...[
                                    Row(
                                      children: [
                                        for (var columnsSeatDate
                                            in columns) ...[
                                          columnsSeatDate["bookingStatus"] ==
                                                  "na"
                                              ? _blankSeat()
                                              : _seaterSeat(
                                                  displayName: columnsSeatDate[
                                                      "displayName"],
                                                  bookingStatus:
                                                      columnsSeatDate[
                                                          "bookingStatus"],
                                                  bookedByCustomer:
                                                      columnsSeatDate[
                                                          "bookedByCustomer"],
                                                  booked: selectSeatData.contains(columnsSeatDate[
                                                  "displayName"]),
                                                ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: BottomAppBar(
            height: 90 * heightF,
            child: Row(
              children: [
                Container(
                  // margin: EdgeInsets.all(5),
                  child: Text(
                    "Seat: ${selectSeatData.length}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20 * heightF,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50 * widthP,
                ),
                Expanded(
                    child: Container(
                  // margin: EdgeInsets.all(5),
                  height: 50 * heightF,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.amber.shade800),
                      onPressed: () async {
                        if (!selectSeatData.isEmpty) {

                          // Todo: Refresh API Call


                          // Todo: Loop for ticket chacking

                          // Todo: If any ticket is booked, then call

                          // Navigator.pushReplacement(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) => SelectSeat(
                              //             from: widget.from,
                              //             to: widget.to,
                              //             date: widget.date,
                              //             busDetails: widget.busDetails,
                              //           ),
                              //         ),
                              //       );
                          // Todo: or go to next

                          // Todo: ticket booking api cal





                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmTicket(
                                from: widget.from,
                                to: widget.to,
                                date: widget.date,
                                busDetails: widget.busDetails,
                                selectSeatData: selectSeatData,
                                myPrice: myPrice,
                              //   Todo: ticket book api cred...

                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹ ${myPrice}",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25 * heightF,
                              ),
                            ),
                            Text(
                              "Next Step",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 21 * heightF,
                              ),
                            ),
                          ],
                        ),
                      )),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool selectSeatSearch(displayName) {
    return false;
  }

  GestureDetector _seaterSeat({
    required String displayName,
    required String bookingStatus,
    required String bookedByCustomer,
    required bool booked,
  }) {
    return GestureDetector(
      onTap: () {
        print(displayName);
        if ((bookedByCustomer == "Yes" && bookingStatus == "Yes") ||
            bookingStatus == "No") {
        } else {
          if (selectSeatData.contains(displayName)) {
            selectSeatData.remove(displayName);

            myPrice = myPrice - seaterPrice;
          } else {
            selectSeatData.add(displayName);
            myPrice = myPrice + seaterPrice;
          }
        }

        setState(() {

        });
      },
      // booked == false
      //     ? () {
      //         setState(() {
      //           if (selectSeatData.contains(columnsSeatDate)) {
      //             selectSeatData.remove(columnsSeatDate);

      //             myPrice = myPrice - price;
      //             myOriginalPrice = myOriginalPrice - originalPrice;
      //           } else {
      //             selectSeatData.add(columnsSeatDate);

      //             myPrice = myPrice + price;
      //             myOriginalPrice = myOriginalPrice + originalPrice;
      //           }
      //         });
      //       }
      //     : () {},
      child: Container(
        margin: EdgeInsets.all(10),
        height: 35,
        width: 35,
        child: SvgPicture.asset(
          'images/seat.svg',
          color: ((bookedByCustomer == "Yes" && bookingStatus == "Yes") ||
                  bookingStatus == "No")
              ? Colors.grey
              : booked
                  ? Colors.green
                  : Colors.amber.shade800,
        ),
      ),
    );
  }

  Container _blankSeat() {
    return Container(
      margin: EdgeInsets.all(10),
      height: 35,
      width: 35,
    );
  }
}
