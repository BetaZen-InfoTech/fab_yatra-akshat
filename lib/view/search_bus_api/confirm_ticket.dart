import 'dart:convert';

import 'package:fabyatra/payment/web_payment/webview_android_ios.dart';
import 'package:fabyatra/payment/web_payment/webview_web.dart';
import 'package:fabyatra/view/home/home_navigation.dart';
import 'package:fabyatra/view/search_bus_api/home.dart';
import 'package:fabyatra/view/search_bus_api/policy/webview_android_ios.dart';
import 'package:fabyatra/view/search_bus_api/policy/webview_web.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';
import 'package:fabyatra/Controllers/auth.dart';
import 'package:http/http.dart' as http;

// import 'package:fabyatra/payment/khalti/khalti_payment_page.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:intl/intl.dart';
import 'package:fabyatra/utils/services/global.dart';

// import 'package:timezone/standalone.dart' as tz;
import 'package:fabyatra/view/search_bus_api/select_seat.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ConfirmTicket extends StatefulWidget {
  const ConfirmTicket({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    required this.busDetails,
    required this.selectSeatData,
    required this.myPrice,
    required this.ticketBookingData,
  });

  final String from;
  final String to;
  final String date;
  final List<dynamic> selectSeatData;
  final Map busDetails;
  final String ticketBookingData;
  final double myPrice;

  @override
  State<ConfirmTicket> createState() => _ConfirmTicketState();
}

class _ConfirmTicketState extends State<ConfirmTicket> {
  List selectSeatData = [];
  TextEditingController couponController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // TextEditingController couponController = TextEditingController();
  // TextEditingController couponController = TextEditingController();

  double baseFare = 0;
  double couponOffer = 0;
  double productOffer = 0;
  double serviceCharge = 10.00;

  String contactNumber = "";
  String name = "";
  String email = "";
  String couponCode = "";
  String couponCodeType = "";

  // var kathmandu = tz.getLocation('Asia/Kathmandu');
  Map<String, dynamic> jsonResponse ={};

  DatabaseReference ref = FirebaseDatabase.instance.ref().child(
      "${GlobalVariable.appType}/project-backend"); //Todo: change the type to Query

  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    setState(() {
      selectSeatData = widget.selectSeatData;
      serviceCharge = 10 * double.parse(selectSeatData.length.toString());

      baseFare = widget.myPrice;
      productOffer = 0;
      jsonResponse = jsonDecode(widget.ticketBookingData);
    });

    getUserId();
  }

  List<dynamic> passengerInfo = [];

  //  Map<String, dynamic> jsonResponse ={};

  Future<void> fetchPassengerInfo() async {
    final url = Uri.parse(GlobalVariable.busSewaDomain +
        '/customer/webresources/booking/passengerInfo');
    // final username = 'test'; // Replace with your username
    // final password = 'test@123'; // Replace with your password


    final Map<String, String> requestData = {
      "id": widget.busDetails['id'],
      "name": name,
      "contactNumber": contactNumber,
      "email": "hasmat151@gmail.com",
      "boardingPoint": "",
      "ticketSrlNo": jsonResponse["ticketSrlNo"]
    };

    try {
      final response = await http.post(
        url,
        body: json.encode(requestData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ' +
            base64Encode(utf8.encode(
                '${GlobalVariable.busSewaUserName}:${GlobalVariable.busSewaPassword}')),
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        if (jsonResponse["status"] == 1) {
          print("Payment Successful");
          String tempTicketId = const Uuid().v4().toString().trim();
          Map<String, dynamic> jsonResponse =
              jsonDecode(widget.ticketBookingData);
          print(jsonResponse);

          ref
              .child("ticket-api-busSewa")
              // .child("date")
              .child(jsonResponse["ticketSrlNo"])
              .update({
            "status": "active",
            "budId": widget.busDetails['id'],
            "date": widget.date.toString(),
            "payment-id": "under-processing",
            // "ticket-id": tempTicketId,

            "ticketSrlno": jsonResponse["ticketSrlNo"],
            "boardingPoints": jsonResponse["boardingPoints"],
            "userId": userId,
            "from": widget.from,
            "to": widget.to,
            "date": widget.date,
            "busDetails": widget.busDetails,
            "selectSeatData": widget.selectSeatData,
            "myPrice": widget.myPrice,
            "ticketBookingData": widget.ticketBookingData

            //Todo: under-processing/active/
          });

          ref
              .child("account/user-data/user/")
              // .child("date")
              .child(userId)
              .child("ticket-api-busSewa")
              .child(widget.date.toString() + "/" + jsonResponse["ticketSrlNo"])
              .update({
            "status": "active",
            "budId": widget.busDetails['id'],
            "date": widget.date.toString(),
            "payment-id": "under-processing",
            // "ticket-id": tempTicketId,
            "ticketSrlno": jsonResponse["ticketSrlNo"],
            "boardingPoints": jsonResponse["boardingPoints"],
            "userId": userId,
            "from": widget.from,
            "to": widget.to,
            "date": widget.date,
            "busDetails": widget.busDetails,
            "selectSeatData": widget.selectSeatData,
            "myPrice": widget.myPrice,
            "ticketBookingData": widget.ticketBookingData

            //Todo: under-processing/active/
          });

          ref
              .child("web-payment/ticket-api-busSewa")
              // .child("date")
              .child(jsonResponse["ticketSrlNo"])
              .update({
            "status": "active",
            "budId": widget.busDetails['id'],
            "date": widget.date.toString(),
            "payment-id": "under-processing",
            // "ticket-id": tempTicketId,
            "ticketSrlno": jsonResponse["ticketSrlNo"],
            "boardingPoints": jsonResponse["boardingPoints"],
            "userId": userId,
            "from": widget.from,
            "to": widget.to,
            "date": widget.date,
            "busDetails": widget.busDetails,
            "selectSeatData": widget.selectSeatData,
            "myPrice": widget.myPrice,
            "ticketBookingData": widget.ticketBookingData

            //Todo: under-processing/active/
          });
          print("object");
          paymentConfirm();
        }
        // setState(() {
        //   // passengerInfo = jsonDecode(response.body);
        // });
      } else {
        throw Exception(
            'Failed to load passenger info. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load passenger info. Error: $e');
    }
  }

  void paymentConfirm() async {
    // Define your request data
    Map<String, dynamic> requestData = {
      "id": widget.busDetails['id'],
      "refId": "30064",
      "ticketSrlNo": jsonResponse["ticketSrlNo"]
    };

    // Convert request data to JSON
    String requestBody = jsonEncode(requestData);

    // Define the API URL
    String apiUrl =
        '${GlobalVariable.busSewaDomain}/customer/webresources/booking/paymentConfirm';

    // Make the API call with basic authentication
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Basic ' +
            base64Encode(utf8.encode(
                '${GlobalVariable.busSewaUserName}:${GlobalVariable.busSewaPassword}')),
      },
      body: requestBody,
    );
    print("****************************");

    print(response.body);
    ticketQuery();
    // Decode the response JSON
    Map<String, dynamic> responseData = jsonDecode(response.body);

    // print(responseData);
  }

  void ticketQuery() async {
    // Define your request data
    Map<String, dynamic> requestData = {
      "id": widget.busDetails['id'],
      // "refId": "30064",
      "ticketSrlNo":jsonResponse["ticketSrlNo"]
    };

    // Convert request data to JSON
    String requestBody = jsonEncode(requestData);

    // Define the API URL
    String apiUrl =
        '${GlobalVariable.busSewaDomain}/customer/webresources/booking/queryTicket';

    // Make the API call with basic authentication
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Basic ' +
            base64Encode(utf8.encode(
                '${GlobalVariable.busSewaUserName}:${GlobalVariable.busSewaPassword}')),
      },
      body: requestBody,
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    print("****************************");
    print(response.body);
    // Decode the response JSON
    Map<String, dynamic> responseData = jsonDecode(response.body);

    // print(responseData);
  }

//   Future<void> fetchPassengerInfo() async {
//   final String apiUrl = 'https://diyalodev.com/customer/webresources/booking/passengerInfo';
//   final String username = 'test'; // Replace with your username
//   final String password = 'test@123'; // Replace with your password

//   final Map<String, dynamic> requestData = {
//     "id":  "MTA2NTI5ODowOjA=",
//     "name": name,
//     "contactNumber": contactNumber,
//     "email": "hasmat151@gmail.com",
//     "boardingPoint": "",
//     "ticketSrlNo": "3791863-B"
//   };

//   try {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       body: json.encode(requestData),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Basic ' + base64Encode(utf8.encode('$username:$password')),
//       },
//     );

//     print(response.body);

//     if (response.statusCode == 200) {
//       setState(() {
//         // passengerInfo = jsonDecode(response.body);
//       });
//     } else {
//       throw Exception('Failed to load passenger info. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     throw Exception('Failed to load passenger info. Error: $e');
//   }
// }

  @override
  Widget build(BuildContext context) {
    // Todo: Add this code to every page ⤵️⤵️⤵️⤵️⤵️
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);
    // Todo: Add this code to every page ⤴️⤴️⤴️⤴️⤴️



    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80 * heightP),
          child: AppBar(
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
            backgroundColor: Colors.black,
            title: Container(
              padding: EdgeInsets.only(top: 15 * heightP),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${widget.from} to ${widget.to}",
                      style: TextStyle(color: Colors.white)),
                  // SizedBox(height: 5*heightP),
                  // Text("${widget.btime}", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade300,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.from}",
                            style: TextStyle(
                                fontSize: widthP * 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "${DateFormat('EEEE d MMM yyyy').format(DateTime(int.parse(widget.date.split("-")[0]), int.parse(widget.date.split("-")[1]), int.parse(widget.date.split("-")[2]), 0, 0, 0))}",
                                style: TextStyle(
                                  fontSize: widthP * 15,
                                ),
                              ),
                              Container(
                                height: 15,
                                child: VerticalDivider(
                                  color: Colors.black,
                                  thickness: 2,
                                ),
                              ),
                              // Text("${widget.btime}",
                              //     style: TextStyle(fontSize: widthP * 15)),
                            ],
                          )
                        ],
                      ),
                      Icon(Icons.forward),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${widget.to}",
                            style: TextStyle(
                              fontSize: widthP * 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // SizedBox(height: 15),
                          // Row(
                          //   children: [
                          //     Text("${widget.date}", style: TextStyle(fontSize:  widthP * 15)),
                          //     Container(
                          //       height: 10,
                          //       child: VerticalDivider(
                          //         color: Colors.black,
                          //         thickness: 2,
                          //       ),
                          //     ),
                          //     Text("${widget.dbdtime}", style: TextStyle(fontSize:  widthP * 15)),
                          //   ],
                          // )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    // height: 180,
                    // alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 10),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textAlign: TextAlign.left,
                          "Boarding Points",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widthP * 22),
                        ),
                        SizedBox(height: 10),

                        if(jsonResponse["boardingPoints"]!= null && jsonResponse["boardingPoints"].length>0)...[
                          ListView.builder(
                              padding: const EdgeInsets.all(4),
                              itemCount: jsonResponse["boardingPoints"].length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 30,
                                  child: Text(jsonResponse["boardingPoints"]
                                  [index]
                                      .toString()),
                                );
                              }),

                        ],
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Details Of Passenger",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: widthP * 22),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Name",
                        style: TextStyle(fontSize: widthP * 18),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 411 * widthP,
                        child: TextField(
                          controller: nameController,
                          onChanged: (text) {
                            setState(() {
                              name = text;
                            });
                          },
                          // keyboardType: TextInputType,
                          decoration: InputDecoration(
                              labelText: 'Name of the Passenger',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Contact Number",
                        style: TextStyle(fontSize: widthP * 18),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 411 * widthP,
                        child: TextField(
                          controller: phoneController,
                          onChanged: (text) {
                            setState(() {
                              contactNumber = text;
                            });
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: '+91XXXXXXXXX',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Email",
                        style: TextStyle(fontSize: widthP * 18),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 411 * widthP,
                        child: TextField(
                          controller: emailController,
                          onChanged: (text) {
                            setState(() {
                              email = text;
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email', border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Offers & Benifits",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: widthP * 22),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Coupon",
                        style: TextStyle(fontSize: widthP * 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 411 * widthP,
                        child: TextField(
                          controller: couponController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Coupon No.',
                              border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 411 * widthP,
                        child: TextButton(
                          onPressed: () async {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ViewList()
                            //     )
                            // );
                            String newCoupon = couponController.text.toString();

                            if (newCoupon == "") {
                              setState(() {
                                couponOffer = 0;
                                couponCode = "";
                                couponCodeType = "";
                              });

                              final snackBar = SnackBar(
                                content: const Text('Coupon code not found.'),
                                action: SnackBarAction(
                                  label: 'dismiss',
                                  onPressed: () {},
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            }
                            final userCoupon = await ref
                                .child("coupon/user")
                                .child(newCoupon)
                                .get();
                            print(userCoupon.value.runtimeType);
                            print(userCoupon.value);
                            if (userCoupon.value.runtimeType != Null) {
                              Map couponMap = userCoupon.value as Map;
                              int nowTime =
                                  DateTime.now().millisecondsSinceEpoch;
                              if ((nowTime <
                                      int.parse(couponMap["valid-till"]
                                          .toString())) &&
                                  (userId == couponMap["userid"].toString()) &&
                                  ("active" ==
                                      couponMap["status"].toString())) {
                                setState(() {
                                  couponOffer = double.parse(
                                      couponMap["amount"].toString());
                                  couponCode = newCoupon;
                                  couponCodeType = "user";
                                });

                                return;
                              }
                            }

                            final allCoupon = await ref
                                .child("coupon/all")
                                .child(newCoupon)
                                .get();
                            print(allCoupon.value.runtimeType);
                            print(allCoupon.value);
                            if (allCoupon.value.runtimeType != Null) {
                              Map couponMap = allCoupon.value as Map;
                              List claimedList = [];
                              if (couponMap["already-claimed"] != null) {
                                Map claimedMap =
                                    couponMap["already-claimed"] as Map;
                                claimedList = claimedMap.keys.toList();
                              }
                              print(claimedList);
                              int nowTime =
                                  DateTime.now().millisecondsSinceEpoch;
                              if ((nowTime <
                                      int.parse(couponMap["valid-till"]
                                          .toString())) &&
                                  (!(claimedList.contains(userId))) &&
                                  ("active" ==
                                      couponMap["status"].toString())) {
                                setState(() {
                                  couponOffer = double.parse(
                                      couponMap["amount"].toString());
                                  couponCode = newCoupon;
                                  couponCodeType = "all";
                                });

                                return;
                              }
                            }

                            setState(() {
                              couponOffer = 0;
                              couponCode = "";
                              couponCodeType = "";
                            });

                            final snackBar = SnackBar(
                              content: const Text('Coupon code not found.'),
                              action: SnackBarAction(
                                label: 'dismiss',
                                onPressed: () {},
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                color: Colors.amber.shade800,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                "Verify",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: widthP * 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade200)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Fare Breakup",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: widthP * 20,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      String url =
                                          'https://notice.fabyatra.com/secqure-bussewa-api-policy.php?url=${GlobalVariable.busSewaDomain}/customer/webresources/v3/booking/tab/${widget.busDetails['id']}';


                                      // print("url");
                                      // print(url);

                                      if (kIsWeb) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WebViewPolicy(
                                                  policyUrl: url,
                                            ),
                                          ),
                                        );
                                      }

                                      if (Platform.isAndroid) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyWebsitePolicy(
                                              policyUrl: url,
                                            ),
                                          ),
                                        );
                                      } else if (Platform.isIOS) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyWebsitePolicy(
                                              policyUrl: url,
                                            ),
                                          ),
                                        );
                                      }

                                      // showDialog(
                                      //   context: context,
                                      //   builder: (context) {
                                      //     return StatefulBuilder(
                                      //       builder: (context, setState) {
                                      //         return AlertDialog(
                                      //           // <-- SEE HERE
                                      //           title: const Text(
                                      //               'Cancellation Policy'),
                                      //           content: Column(
                                      //             children: [
                                      //               Text(
                                      //                   '1. $refundAmount% of the amount will be refunded if cancelled before 24 hours of departure.'),
                                      //               Text(
                                      //                   '2. Contact customer services for more further requests and query.'),
                                      //               Text(
                                      //                   '3. If wrong ticket is booked, please ensure contacting us within 3-5 hrs to get full refund.'),
                                      //               Text(
                                      //                   '4. full refund will be processed if ticket is cancelled by Bus operator/FabYatra.'),
                                      //             ],
                                      //           ),
                                      //
                                      //           actions: <Widget>[
                                      //             TextButton(
                                      //               style: TextButton.styleFrom(
                                      //                   backgroundColor:
                                      //                       Color(
                                      //                           0xff7d2aff)),
                                      //               child: Text(
                                      //                 "Yes",
                                      //                 style: TextStyle(
                                      //                     color:
                                      //                         Colors.white),
                                      //               ),
                                      //               onPressed: () {
                                      //                 Navigator.of(context)
                                      //                     .pop();
                                      //               },
                                      //             ),
                                      //           ],
                                      //         );
                                      //       },
                                      //     );
                                      //   },
                                      // );
                                    },
                                    child: Text(
                                      "Cancellation Policy",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: widthP * 15),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                                // You can customize the color of the divider
                                thickness:
                                    1.0, // You can customize the thickness of the divider
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Base Fare",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: widthP * 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "₹ ${baseFare}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: widthP * 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Coupon Discount",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: widthP * 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "-₹ ${couponOffer}",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: widthP * 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Fare",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: widthP * 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "₹ ${baseFare - couponOffer}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: widthP * 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Operator Discount",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: widthP * 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "- ₹ ${productOffer}",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: widthP * 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                color: Colors.grey,
                                // You can customize the color of the divider
                                thickness:
                                    1.0, // You can customize the thickness of the divider
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Service Charge",
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: widthP * 20),
                                  ),
                                  Text(
                                    "₹ ${serviceCharge}",
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: widthP * 20),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "NET AMOUNT",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: widthP * 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "₹ ${baseFare - couponOffer - productOffer}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: widthP * 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 90 * heightP,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Net Amount",
                      style: TextStyle(fontSize: widthP * 16),
                    ),
                    SizedBox(
                      height: 2 * heightP,
                    ),
                    Row(
                      children: [
                        Text(
                          "₹ ${baseFare - couponOffer - productOffer + serviceCharge}",
                          style: TextStyle(
                              fontSize: widthP * 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " for ${selectSeatData.length} seat",
                          style: TextStyle(fontSize: widthP * 15),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {
                    fetchPassengerInfo();

                    // print("hhhhhhhhhhhhhhhh 1");

                    //   for (Map data in selectSeatData) {
                    //     final counterSnapshot = await ref
                    //         .child("vehicle/details")
                    //         .child("bus")
                    //     // .child(widget.itemId.toString())
                    //         .child("ticket")
                    //         .child(widget.date.toString())
                    //         .child(data["seat-id"].toString())
                    //         .get();
                    //     print(counterSnapshot.value.runtimeType);
                    //     print(ref.path);
                    //     print(counterSnapshot.key);
                    //     if (counterSnapshot.value.runtimeType != Null) {
                    //       Map myData = counterSnapshot.value as Map;
                    //       int myTime = int.parse(myData["created-at"].toString()) +
                    //           (8 * 60 * 1000);
                    //       print(myTime);
                    //       print(DateTime.now().millisecondsSinceEpoch);

                    //       print("hhhhhhhhhhhhhhhh" + myData["status"]);
                    //       if (myData["status"] == "active") {
                    //         print("hhhhhhhhhhhhhhhh run 1");

                    //         Navigator.pushReplacement(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => SelectSeat(
                    //               from: widget.from,
                    //               to: widget.to,
                    //               date: widget.date,
                    //               busDetails: widget.busDetails,
                    //             ),
                    //           ),
                    //         );
                    //         return;
                    //       } else if (myData["status"] != "active" &&
                    //           myTime < DateTime.now().millisecondsSinceEpoch) {
                    //         print("hhhhhhhhhhhhhhhh run 2");
                    //       } else {
                    //         print("hhhhhhhhhhhhhhhh run 2");

                    //         Navigator.pushReplacement(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => SelectSeat(
                    //               from: widget.from,
                    //               to: widget.to,
                    //               date: widget.date,
                    //               busDetails: widget.busDetails,
                    //             ),
                    //           ),
                    //         );

                    //         return;
                    //       }
                    //     }
                    //     // else{
                    //     //   Navigator.pushReplacement(
                    //     //     context,
                    //     //     MaterialPageRoute(
                    //     //       builder: (context) => SelectSeat(
                    //     //         bpoint: widget.bpoint,
                    //     //         dbdpoint: widget.dbdpoint,
                    //     //         btime: widget.btime,
                    //     //         dbdtime: widget.dbdtime,
                    //     //         itemId: widget.itemId,
                    //     //         from: widget.from,
                    //     //         to: widget.to,
                    //     //         date: widget.date,
                    //     //         routeId: widget.routeId,
                    //     //       ),
                    //     //     ),
                    //     //   );
                    //     //
                    //     //   return;
                    //     // }
                    //   }

                    //   for (int i = 0; i < selectSeatData.length; i++) {
                    //     if (selectSeatData[i]["name"] == "" ||
                    //         selectSeatData[i]["age"] == "") {
                    //       return;
                    //     }
                    //   }

                    //   if (contactNumber.length < 10) {
                    //     final snackBar = SnackBar(
                    //       content: const Text('Enter correct phone number '),
                    //       action: SnackBarAction(
                    //         label: 'dismiss',
                    //         onPressed: () {},
                    //       ),
                    //     );
                    //     ScaffoldMessenger.of(context)
                    //         .showSnackBar(snackBar);
                    //     return;
                    //   }

                    //   if (!(couponCode == "")) {
                    //     print(couponCode);
                    //     final userCoupon =
                    //     await ref.child("coupon/user").child(couponCode).get();
                    //     print(userCoupon.value.runtimeType);
                    //     print(userCoupon.value);
                    //     if (userCoupon.value.runtimeType != Null) {
                    //       Map couponMap = userCoupon.value as Map;
                    //       int nowTime = DateTime.now().millisecondsSinceEpoch;
                    //       if ((nowTime <
                    //           int.parse(couponMap["valid-till"].toString())) &&
                    //           (userId == couponMap["userid"].toString()) &&
                    //           ("active" == couponMap["status"].toString())) {
                    //         setState(() {
                    //           couponOffer =
                    //               double.parse(couponMap["amount"].toString());
                    //         });
                    //       }
                    //     }

                    //     final allCoupon =
                    //     await ref.child("coupon/all").child(couponCode).get();
                    //     print(allCoupon.value.runtimeType);
                    //     print(allCoupon.value);
                    //     if (allCoupon.value.runtimeType != Null) {
                    //       Map couponMap = allCoupon.value as Map;
                    //       List claimedList = [];
                    //       if (couponMap["already-claimed"] != null) {
                    //         Map claimedMap = couponMap["already-claimed"] as Map;
                    //         claimedList = claimedMap.keys.toList();
                    //       }
                    //       print(claimedList);
                    //       int nowTime = DateTime.now().millisecondsSinceEpoch;
                    //       if ((nowTime <
                    //           int.parse(couponMap["valid-till"].toString())) &&
                    //           (!(claimedList.contains(userId))) &&
                    //           ("active" == couponMap["status"].toString())) {
                    //         setState(() {
                    //           couponOffer =
                    //               double.parse(couponMap["amount"].toString());
                    //         });
                    //       } else {
                    //         final snackBar = SnackBar(
                    //           content: const Text('Coupon code not found.'),
                    //           action: SnackBarAction(
                    //             label: 'dismiss',
                    //             onPressed: () {},
                    //           ),
                    //         );
                    //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    //         return;
                    //       }
                    //     }
                    //   }

                    //   String tempTicketId = const Uuid().v4().toString().trim();

                    //   //Todo: add bus seat to bus side userId
                    //   for (int i = 0; i < selectSeatData.length; i++) {
                    //     ref
                    //         .child("vehicle/details/bus")
                    //     // .child(widget.itemId)
                    //         .child("ticket")
                    //         .child(widget.date.toString())
                    //         .child(selectSeatData[i]["seat-id"])
                    //         .update({
                    //       "ticket-id": tempTicketId,
                    //       "journey-date": widget.date.toString(),
                    //       "created-at":
                    //       DateTime.now().millisecondsSinceEpoch.toString(),
                    //       "updated-at":
                    //       DateTime.now().millisecondsSinceEpoch.toString(),
                    //       "status": "incomplete"
                    //       //Todo: incomplete/active/cancel/refund
                    //     });
                    //   }

                    //   //Todo: add bus seat to user side
                    //   ref
                    //       .child("account/user-data/user")
                    //       .child(userId)
                    //       .child("ticket")
                    //       .child(widget.date.toString())
                    //       .child(tempTicketId)
                    //       .update({
                    //     "ticket-id": tempTicketId,
                    //     "journey-date": widget.date.toString(),
                    //     "created-at":
                    //     DateTime.now().millisecondsSinceEpoch.toString(),
                    //     "updated-at":
                    //     DateTime.now().millisecondsSinceEpoch.toString(),
                    //     "status": "incomplete"
                    //     //Todo: under-processing/active/
                    //   });

                    //   //Todo: add bus seat data
                    //   ref
                    //       .child("ticket")
                    //       .child(widget.date.toString())
                    //       .child(tempTicketId)
                    //       .update({
                    //     "booking-type": "online",
                    //     "ticket-id": tempTicketId,
                    //     "journey-date": widget.date.toString(),
                    //     // "bus-no": widget.itemId.toString(),
                    //     "user-id": userId,
                    //     "journey-from": widget.from.toString(),
                    //     "journey-to": widget.to.toString(),
                    //     // "journey-routeId": widget.routeId.toString(),
                    //     // "journey-bpoint": widget.bpoint.toString(),
                    //     // "journey-dbdpoint": widget.dbdpoint.toString(),
                    //     // "journey-btime": widget.btime.toString(),
                    //     // "journey-dbdtime": widget.dbdtime.toString(),
                    //     // "journey-seaterPrice": widget.seaterPrice.toString(),
                    //     // "journey-sleeperPrice": widget.sleeperPrice.toString(),
                    //     // "journey-sleeperPriceOffer":
                    //     //     widget.sleeperPriceOffer.toString(),
                    //     // "journey-seaterPriceOffer":
                    //     //     widget.seaterPriceOffer.toString(),
                    //     "serviceCharge": serviceCharge.toString(),
                    //     "baseFare": baseFare.toString(),
                    //     "couponOffer": couponOffer.toString(),
                    //     "productOffer": productOffer.toString(),
                    //     // "wallet":walletAmount.toString(),
                    //     "payable-amount":
                    //     (baseFare - couponOffer - productOffer + serviceCharge)
                    //         .toString(),
                    //     "online-pay":
                    //     (baseFare - couponOffer - productOffer + serviceCharge)
                    //         .toString(),
                    //     "contactNumber": contactNumber.toString(),
                    //     "couponCode": couponCode.toString(),
                    //     "couponCodeType": couponCodeType.toString(),
                    //     "created-at":
                    //     DateTime.now().millisecondsSinceEpoch.toString(),
                    //     "updated-at":
                    //     DateTime.now().millisecondsSinceEpoch.toString(),
                    //     "status": "incomplete"
                    //     //Todo: under-processing/active/
                    //   });

                    //   for (int i = 0; i < selectSeatData.length; i++) {
                    //     ref
                    //         .child("ticket")
                    //         .child(widget.date.toString())
                    //         .child(tempTicketId)
                    //         .child("passenger-details")
                    //         .child(i.toString())
                    //         .update({
                    //       "name": selectSeatData[i]["name"],
                    //       "number": selectSeatData[i]["number"],
                    //       "seat-id": selectSeatData[i]["seat-id"],
                    //       "gender": selectSeatData[i]["gender"],
                    //       "floor": selectSeatData[i]["floor"],
                    //       "age": selectSeatData[i]["age"],
                    //       "updated-at":
                    //       DateTime.now().millisecondsSinceEpoch.toString(),
                    //     });
                    //   }
                    //   String publicId = const Uuid().v4().toString().trim();

                    //   ref
                    //       .child("web-payment/public")
                    //       .child(widget.date.toString())
                    //       .child(publicId)
                    //       .update({
                    //     "amount":
                    //     (baseFare - couponOffer - productOffer).toString(),
                    //     // "itemId": widget.itemId.toString(),
                    //     "userId": userId,
                    //     "ticket-id": tempTicketId,
                    //     "journey-date": widget.date.toString(),
                    //     "created-at":
                    //     DateTime.now().millisecondsSinceEpoch.toString(),
                    //     "updated-at":
                    //     DateTime.now().millisecondsSinceEpoch.toString(),
                    //     "status": "incomplete"
                    //   });
                    //   //                 window.open( 'http://localhost/payment.fabyatra.com/payment.php?publicid=' + publicId + "&date=" + date, '_self' );

                    //   String url =
                    //       'https://payment.fabyatra.com/payment.php?publicid=' +
                    //           publicId +
                    //           "&date=" +
                    //           widget.date.toString();

                    //   SharedPreferences prefs =
                    //   await SharedPreferences.getInstance();
                    //   prefs.setString('paymentUrl', url);
                    //   print(url);
                    //   if (kIsWeb) {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => WebViewExample(
                    //           paymentUrl: url,
                    //         ),
                    //       ),
                    //     );
                    //   }

                    //   if (Platform.isAndroid) {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => MyWebsite(
                    //           paymentUrl: url,
                    //         ),
                    //       ),
                    //     );
                    //   } else if (Platform.isIOS) {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => MyWebsite(
                    //           paymentUrl: url,
                    //         ),
                    //       ),
                    //     );
                    //   }
                    // },
                    // print("Payment Successful");
                    // String tempTicketId = const Uuid().v4().toString().trim();
                    // Map<String, dynamic> jsonResponse =
                    //     jsonDecode(widget.ticketBookingData);
                    // print(jsonResponse);

                    // ref
                    //     .child("ticket-api-busSewa")
                    //     // .child("date")
                    //     .child(jsonResponse["ticketSrlNo"])
                    //     .update({
                    //   "budId": widget.busDetails['id'],
                    //   "date": widget.date.toString(),
                    //   "payment-id": "under-processing",
                    //   // "ticket-id": tempTicketId,
                    //   "ticketSrlno": jsonResponse["ticketSrlNo"],
                    //   "boardingPoints": jsonResponse["boardingPoints"],
                    //   "userId": userId,

                    //   //Todo: under-processing/active/
                    // });

                    // ref
                    //     .child("account/user-data/user/")
                    //     // .child("date")
                    //     .child(userId)
                    //     .child("ticket-api-busSewa")
                    //     .child(widget.date.toString() +
                    //         "/" +
                    //         jsonResponse["ticketSrlNo"])
                    //     .update({
                    //   "budId": widget.busDetails['id'],
                    //   "date": widget.date.toString(),
                    //   "payment-id": "under-processing",
                    //   // "ticket-id": tempTicketId,
                    //   "ticketSrlno": jsonResponse["ticketSrlNo"],
                    //   "boardingPoints": jsonResponse["boardingPoints"],
                    //   "userId": userId,

                    //   //Todo: under-processing/active/
                    // });

                    // ref
                    //     .child("web-payment/ticket-api-busSewa")
                    //     // .child("date")
                    //     .child(jsonResponse["ticketSrlNo"])
                    //     .update({
                    //   "budId": widget.busDetails['id'],
                    //   "date": widget.date.toString(),
                    //   "payment-id": "under-processing",
                    //   // "ticket-id": tempTicketId,
                    //   "ticketSrlno": jsonResponse["ticketSrlNo"],
                    //   "boardingPoints": jsonResponse["boardingPoints"],
                    //   "userId": userId,

                    //   //Todo: under-processing/active/
                    // });
                    // print("object");
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: 75 * heightP,
                    width: 100 * widthP,
                    decoration: BoxDecoration(
                        color: Colors.amber.shade800,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        "Pay Now",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: heightF * 19),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _passengerDetail(
      int i, Map seatData, double widthP, double heightP, double heightF) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Passenger ${i + 1}| Seat ${seatData["number"]}"),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    height: 60,
                    width: double.infinity,
                    child: TextField(
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        setState(() {
                          seatData["name"] = value;
                        });
                      },
                      decoration: const InputDecoration(
                          labelText: "Enter Full Name",
                          border: OutlineInputBorder()),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Age"),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        height: 60,
                        width: 150 * widthP,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              seatData["age"] = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Enter Age",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Gender"),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                seatData["gender"] = 'male';
                              });
                            },
                            child: Container(
                              child: Text(
                                "M",
                                style: TextStyle(
                                  color: seatData["gender"] == 'Male'
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              // Icon(Icons.male,
                              //     color: seatData["gender"] == 'male'
                              //         ? Colors.white
                              //         : Colors.black),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: seatData["gender"] == 'male'
                                      ? Colors.amber.shade800
                                      : Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              elevation: 0,
                              backgroundColor: seatData["gender"] == 'male'
                                  ? Colors.amber.shade800
                                  : Colors.grey.shade300,
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                seatData["gender"] = 'female';
                              });
                            },
                            child: Container(
                              child: Text(
                                "F",
                                style: TextStyle(
                                  color: seatData["gender"] == 'female'
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              // Icon(Icons.female,
                              //     color: seatData["gender"] == 'female'
                              //         ? Colors.white
                              //         : Colors.black),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: seatData["gender"] == 'female'
                                      ? Colors.amber.shade800
                                      : Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              elevation: 0,
                              backgroundColor: seatData["gender"] == 'female'
                                  ? Colors.amber.shade800
                                  : Colors.grey.shade300,
                              fixedSize: Size(20.0 * widthP, 10.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String userId = "";

  Future<void> getUserId() async {
    userId = await Auth.uid();
    print(userId);

    if (userId == "") {
      Navigator.pop(context);
    } else {
      getPolicy();
    }
  }

  Future<void> getPolicy() async {
    try {
      final response = await http.get(
        Uri.parse(GlobalVariable.busSewaDomain +
            '/customer/webresources/v3/booking/tab/' +
            widget.busDetails['id']),
        // body: json.encode(requestData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ' +
              base64Encode(utf8.encode(
                  '${GlobalVariable.busSewaUserName}:${GlobalVariable.busSewaPassword}')),
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        print("jjjjjjjjjjjjjjjjj");
        print(response.body);
        Map<String, dynamic> jsonResponseT = jsonDecode(response.body);
        jsonResponse["boardingPoints"] = (jsonResponseT["boardingPoints"]!= null)?jsonResponseT["boardingPoints"]:[];
        setState(() {
        });
      } else {
        throw Exception(
            'Failed to load passenger info. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load passenger info. Error: $e');
    }
  }
}
