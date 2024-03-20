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

  // get hasBookingStatusYes => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getData();
    fetchSeatLayout();
    // ticketBooking();
  }

  //  Future<void> fetchBookingRefresh(String bookingId) async {
  //   String baseUrl = 'https://diyalodev.com/customer/webresources/booking';
  //   String refreshUrl = '$baseUrl/refresh/$bookingId';
  //   final url = Uri.parse(refreshUrl);
  //   final username = 'fab_yatra';
  //   final password = 'f@BY@tra_03_03';
  //   final basicAuth =
  //       'Basic ' + base64Encode(utf8.encode('$username:$password'));

  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: <String, String>{
  //         'authorization': basicAuth,
  //         'Content-Type': 'application/json', // Set the content-type as JSON
  //       },
  //       // body: jsonEncode(requestBody), // Encode the request body as JSON
  //     );
  //     // print(response.body);

  //     if (response.statusCode == 200) {
  //       // Request was successful
  //       // print('Response body: ${response.body}');
  //       Map<String, dynamic> jsonResponse = jsonDecode(response.body);
  //       List<dynamic> seatLayout = jsonResponse['seatLayout'];
  //       List<Map<String, dynamic>> selectSeatData = List<Map<String, dynamic>>.from(seatLayout);

  //       print('***************************************Refresh API called**********************');
  //       // You can further process the response here
  //     } else {
  //       // Request failed
  //       print('Failed to fetch booking refresh: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     // An error occurred during the request
  //     print('Error fetching booking refresh: $error');
  //   }
  // }

  Future<void> fetchBookingRefresh(String bookingId) async {
    // Define the API endpoint URL
    String baseUrl = 'https://diyalodev.com/customer/webresources/booking';
    String refreshUrl = '$baseUrl/refresh/$bookingId';
    final url = Uri.parse(refreshUrl);
    final username = 'fab_yatra';
    final password = 'f@BY@tra_03_03';
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    final response = await http.get(
      url,
      headers: <String, String>{
        'authorization': basicAuth,
        'Content-Type': 'application/json', // Set the content-type as JSON
      },
      // body: jsonEncode(requestBody), // Encode the request body as JSON
    );
    print(response.body);
    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the response body
      // print(responseBody);
      Map<String, dynamic> responseBody = json.decode(response.body);
      // Print the response
      //  final List<dynamic> trips =

      final List<dynamic> seatLayout = responseBody['seatLayout'];
      ;

      // Check if any booking status is "Yes"
      final void hasBookingStatusYes = isAnyBookingStatusYes(seatLayout);
      print("**************************************************************");
      // print( hasBookingStatusYes ? 'Yes, there are seats with booking status "Yes"' : 'No seats with booking status "Yes"');
    } else {
      // If the request was not successful, print an error message
      print('Failed to load data: ${response.statusCode}');
    }
  }

  void isAnyBookingStatusYes(List<dynamic> seatLayout) async {
    // Todo: loop with my select seat
    bool isSeatAvailable = true;
    for (var selectSeatMy in selectSeatData) {
      for (var seat in seatLayout) {
        if (seat['displayName'] == selectSeatMy) {
          // return true;
          if (seat['bookingStatus'] == "Yes") {
            // Todo: seat book, refresh

            isSeatAvailable = false;

            // return;
          }

          print(seat['bookingStatus']);
          print(seat['displayName']);
        }
      }
    }

    // print("No seats found");
    // ticketBooking();
    if (isSeatAvailable) {
      ticketBooking();
    } else {
      print("Desired seat is already booked");
      // call refresh api...

      // fetchBookingRefresh()
      String baseUrl = 'https://diyalodev.com/customer/webresources/booking';
      String refreshUrl = '$baseUrl/refresh/${widget.busDetails['id']}';
      final url = Uri.parse(refreshUrl);
      final username = 'fab_yatra';
      final password = 'f@BY@tra_03_03';
      final basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));

      final response = await http.get(
        url,
        headers: <String, String>{
          'authorization': basicAuth,
          'Content-Type': 'application/json', // Set the content-type as JSON
        },
        // body: jsonEncode(requestBody), // Encode the request body as JSON
      );
      print(response.body);
      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        final List<dynamic> seatLayout = responseBody['seatLayout'];

        var seatData = responseBody["seatLayout"];
        noOfColumn = responseBody["noOfColumn"];

        print(seatData.length);
        print(noOfColumn);
        List oneRowData = [];
        int i = 1;
        oneRowData.clear();
        lowerSeat.clear();
        myPrice = 0;
        selectSeatData.clear();
        selectSeatData = [];

        for (var oneData in seatData) {
          print(oneData);

          if (i < noOfColumn) {
            oneRowData.add(oneData);
            i = i + 1;
            // print(oneDara);
            // print(oneRowData);
          } else if (i == noOfColumn) {
            oneRowData.add(oneData);
            lowerSeat.add(oneRowData);

            oneRowData = [];
            setState(() {
              i = 1;
            });
          }
        }

        print("**************************************************************");
        // print( hasBookingStatusYes ? 'Yes, there are seats with booking status "Yes"' : 'No seats with booking status "Yes"');
      } else {
        // If the request was not successful, print an error message
        print('Failed to load data: ${response.statusCode}');
      }
    }
    // return false;
  }

  Future<void> ticketBooking() async {
    // Define the API endpoint URL
    final url =
        Uri.parse('https://diyalodev.com/customer/webresources/booking/book');
    final username = 'fab_yatra';
    final password = 'f@BY@tra_03_03';
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    // Define the request body
    Map<String, dynamic> requestBody = {
      "id": widget.busDetails['id'],
      "seat": selectSeatData
    };

    // Make the POST request
    final response = await http.post(
      url,
      headers: <String, String>{
        'authorization': basicAuth,
        'Content-Type': 'application/json', // Set the content-type as JSON
      },
      body: jsonEncode(requestBody), // Encode the request body as JSON
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the response body
      // Map<String, dynamic> responseBody = json.decode(response.body);
      // return responseBody;

      print(response.body);
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
            ticketBookingData: response.body  as Map
            //   Todo: ticket book api cred...
          ),
        ),
      );
    } else {
      // If the request was not successful, throw an error
      // throw Exception('Failed to load data');
      print('Failed to load data');
    }
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

    for (var oneData in seatData) {
      print(oneData);

      if (i < noOfColumn) {
        oneRowData.add(oneData);
        i = i + 1;
        // print(oneDara);
        // print(oneRowData);
      } else if (i == noOfColumn) {
        oneRowData.add(oneData);
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
                                                  booked: selectSeatData
                                                      .contains(columnsSeatDate[
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
                          // for(final bus in busData)

                          fetchBookingRefresh(widget.busDetails['id']);

                          // for(var i in selectSeatData){
                          //   // if(i["bookingStatus"]=="Yes"){
                          //   //   print(i["bookingStatus"]);
                          //   // }
                          // }

                          // Todo: Loop for ticket chacking

                          // for(String )

                          // Todo: If any ticket is booked, then call
                          // first-> SelectSeatData list pe for loop
                          //second-> next nested for loop pe api call se jo list jo comapre krega
                          //

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
        if (bookingStatus == "Yes") {
        } else {
          if (selectSeatData.contains(displayName)) {
            selectSeatData.remove(displayName);

            myPrice = myPrice - seaterPrice;
          } else {
            selectSeatData.add(displayName);
            myPrice = myPrice + seaterPrice;
          }
        }

        setState(() {});
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
          color: (bookingStatus == "Yes")
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
