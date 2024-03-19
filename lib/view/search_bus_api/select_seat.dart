import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/loading.dart';
import 'package:fabyatra/view/search_bus/confirm_ticket.dart';
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


  List<Object?> lowerSeat = [];
  bool showLoading = false;


  List bookSeatId = [];



  double seaterPrice = 0;


  double myPrice = 0, myOriginalPrice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getData();
    fetchSeatLayout();
  }


  Future<void> fetchSeatLayout() async {
    
    var seatLayout = widget.busDetails["seatLayout"];
    var noOfColumn = widget.busDetails["noOfColumn"];

    print(seatLayout);
    print(noOfColumn);

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
          body: showLoading==true
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
                                fontSize: 13*widthP,
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
                              child: Row(
                                children: [
                                  for (var columns in lowerSeat) ...[
                                    Column(
                                      children: [
                                        for (var columnsSeatDate
                                            in columns as List) ...[
                                          columnsSeatDate["type"] == "0"
                                              ? _blankSeat()
                                              : _seaterSeat(
                                                      displayName:
                                                          columnsSeatDate,
                                                      bookingStatus: true,
                                                      bookedByCustomer: columnsSeatDate[
                                                          "isBooked"],
                                                          booked: selectSeatSearch(columnsSeatDate)
                                                      
                                                    )
                                                  
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
                    "",
                    // "Seat: ${selectSeatData.length}",
                    style: TextStyle(color: Colors.black, fontSize: 20*heightF,fontWeight: FontWeight.w600,),
                  ),
                ),
                SizedBox(
                  width: 50*widthP,
                ),
                Expanded(
                    child: Container(
                  // margin: EdgeInsets.all(5),
                  height: 50*heightF,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.amber.shade800),
                      onPressed: () async {



                        // if (!selectSeatData.isEmpty) {
                        //   for (Map data in selectSeatData) {
                        //     final counterSnapshot = await ref
                        //         .child("details")
                        //         .child("bus")
                        //         .child(widget.itemId.toString())
                        //         .child("ticket")
                        //         .child(widget.date.toString())
                        //         .child(data["seat-id"].toString())
                        //         .get();
                        //     // print(counterSnapshot.value.runtimeType);
                        //     if (counterSnapshot.value.runtimeType != Null) {
                        //       Map myData = counterSnapshot.value as Map;
                        //       int myTime =
                        //           int.parse(myData["created-at"].toString()) +
                        //               (8 * 60 * 1000);

                        //       if (myData["status"] == "active") {
                        //         Navigator.pushReplacement(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => SelectSeat(
                        //               bpoint: widget.bpoint,
                        //               dbdpoint: widget.dbdpoint,
                        //               btime: widget.btime,
                        //               dbdtime: widget.dbdtime,
                        //               itemId: widget.itemId,
                        //               from: widget.from,
                        //               to: widget.to,
                        //               date: widget.date,
                        //               routeId: widget.routeId,
                        //             ),
                        //           ),
                        //         );
                        //         return;
                        //       } else if (myData["status"] != "active" &&
                        //           myTime <
                        //               DateTime.now().millisecondsSinceEpoch) {
                        //       } else {
                        //         Navigator.pushReplacement(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => SelectSeat(
                        //               bpoint: widget.bpoint,
                        //               dbdpoint: widget.dbdpoint,
                        //               btime: widget.btime,
                        //               dbdtime: widget.dbdtime,
                        //               itemId: widget.itemId,
                        //               from: widget.from,
                        //               to: widget.to,
                        //               date: widget.date,
                        //               routeId: widget.routeId,
                        //             ),
                        //           ),
                        //         );

                        //         return;
                        //       }
                        //     }
                        //   }

                        //   // Navigator.pushReplacement(
                        //   //   context,
                        //   //   MaterialPageRoute(
                        //   //     builder: (context) => ConfirmTicket(
                        //   //       bpoint: widget.bpoint,
                        //   //       dbdpoint: widget.dbdpoint,
                        //   //       btime: widget.btime,
                        //   //       dbdtime: widget.dbdtime,
                        //   //       itemId: widget.itemId,
                        //   //       from: widget.from,
                        //   //       to: widget.to,
                        //   //       date: widget.date,
                        //   //       routeId: widget.routeId,
                        //   //       selectSeatData: selectSeatData,
                        //   //       seaterPrice: seaterPrice,
                        //   //       sleeperPrice: sleeperPrice,
                        //   //       sleeperPriceOffer: sleeperPriceOffer,
                        //   //       seaterPriceOffer: seaterPriceOffer,
                        //   //     ),
                        //   //   ),
                        //   // );
                        // }


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
                                fontSize: 25*heightF,
                              ),
                            ),
                            Text(
                              "Next Step",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 21*heightF,
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

 bool selectSeatSearch(displayName){
  return false;
 }
 
  GestureDetector _seaterSeat(
      {required String displayName,
      required bool bookingStatus,
      required String bookedByCustomer,
      required bool booked,
      }) {
    return GestureDetector(
      onTap: (){},
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
          color:( bookedByCustomer =="Yes" && bookingStatus =="No")
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
