import 'dart:convert';

import 'package:fabyatra/Controllers/auth.dart';
import 'package:fabyatra/utils/footer/footer.dart';
import 'package:fabyatra/view/search_bus_api/select_seat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:fabyatra/utils/constant/index.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/loading.dart';
// import 'package:fabyatra/view/search_bus_api/bdpoint.dart';
import 'package:fabyatra/view/search_bus_api/image.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timezone/standalone.dart' as tz;

class SelectBus extends StatefulWidget {
  const SelectBus(
      {super.key, required this.from, required this.to, required this.date});

  final String from;
  final String to;
  final String date;

  @override
  State<SelectBus> createState() => _SelectBusState();
}

class _SelectBusState extends State<SelectBus> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  String country = '+977';

  String selectedImagePath = '';
  bool showLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTrips();
    // fetchBookingRefresh('MTA2NTI4NzowOjA=');
  }

  List<Map> busData = [];

  String uid = "";

  List trips = [];

  // Future<void> fetchTrips() async {
  //    String username = 'fab_yatra';
  //   String password = 'f@BY@tra_03_03';
  //   String basicAuth =
  //       'Basic ' + base64.encode(utf8.encode('$username:$password'));
  //   print(basicAuth);
  //   final url = Uri.parse('https://diyalodev.com/customer/webresources/booking/trips');
  //   final Map<String, String> params = {
  //     'from': 'kathmandu',
  //     'to': 'kakadvitta',
  //     'date': '2024-03-21',
  //     'shift': 'day',
  //   };

  //   final response = await http.get(url.replace(queryParameters: params),
  //   headers: <String, String>{'authorization': basicAuth}
  //   );

  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     setState(() {
  //       trips = jsonDecode(response.body)['trips']??[];
  //     });
  //   } else {
  //     throw Exception('Failed to load trips');
  //   }

  // }

  Future<void> fetchBookingRefresh(String bookingId) async {
    String baseUrl = 'https://diyalodev.com/customer/webresources/booking';
    String refreshUrl = '$baseUrl/refresh/$bookingId';
    final url = Uri.parse(refreshUrl);
    final username = 'fab_yatra';
    final password = 'f@BY@tra_03_03';
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'authorization': basicAuth,
          'Content-Type': 'application/json', // Set the content-type as JSON
        },
        // body: jsonEncode(requestBody), // Encode the request body as JSON
      );
      // print(response.body);

      if (response.statusCode == 200) {
        // Request was successful
        print('Response body: ${response.body}');
        // You can further process the response here
      } else {
        // Request failed
        print('Failed to fetch booking refresh: ${response.statusCode}');
      }
    } catch (error) {
      // An error occurred during the request
      print('Error fetching booking refresh: $error');
    }
  }

  Future<void> fetchTrips() async {
    final url =
        Uri.parse('https://diyalodev.com/customer/webresources/booking/trips');
    final username = 'fab_yatra';
    final password = 'f@BY@tra_03_03';
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    final requestBody = {
      'from': widget.from,
      'to': widget.to,
      'date': '2024-03-21',
      'shift': 'both',
    };

    final response = await http.post(
      url,
      headers: <String, String>{
        'authorization': basicAuth,
        'Content-Type': 'application/json', // Set the content-type as JSON
      },
      body: jsonEncode(requestBody), // Encode the request body as JSON
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);
      // print(responseBody);
      if (responseBody != null && responseBody['trips'] != null) {
        trips = List<dynamic>.from(responseBody['trips']);

        for (var myThisBus in trips) {
          if (myThisBus["inputTypeCode"] == 1) {
            busData.add(myThisBus as Map);
            setState(() {});
          }
        }
      } else {
        // Handle the case where the 'trips' key is not present in the response
        throw Exception('Failed to load trips: Trips data is null or missing');
      }
    } else {
      // Handle the case where the response status code is not 200
      throw Exception('Failed to load trips: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);
    return SafeArea(
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
          backgroundColor: Colors.black,
          title: Row(
            children: [
              SizedBox(
                width: 38 * widthP,
              ),
              Column(
                children: [
                  Text(
                    // "${widget.from.split(' ').map((word) => word.capitalize()).join(' ')} to ${widget.to.split(' ').map((word) => word.capitalize()).join(' ')}",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    "${widget.from} to ${widget.to}",
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${DateFormat('EEEE d MMM yyyy').format(DateTime(int.parse(widget.date.split("-")[0]), int.parse(widget.date.split("-")[1]), int.parse(widget.date.split("-")[2]), 0, 0, 0))}",
                    // "07 October, Saturday",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              )
            ],
          ),
        ),
        body:
            // showLoading == true
            //     ? Container(child: LottieDialog())
            //     :
            SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade200,
            child: Column(
              children: [
                if (busData.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.percent_outlined,
                            size: 15,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Upto 60% OFF applied.",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "No bus available.",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                for (final bus in busData) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10 * widthP,
                      vertical: 10 * heightF,
                    ),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    // bus[""].toString(),
                                    widget.from,
                                    style: TextStyle(
                                      fontSize: 15 * widthP,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 6 * widthP,
                                      vertical: 6 * heightF,
                                    ),
                                    height: 25 * heightF,
                                    child: VerticalDivider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "National",
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 8 * widthP),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 6 * widthP,
                                      vertical: 6 * heightF,
                                    ),
                                    height: 25 * heightF,
                                    child: VerticalDivider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    // bus["destinations"].toString(),
                                    widget.to,
                                    style: TextStyle(
                                      fontSize: 15 * widthP,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 175 * widthP,
                              child: Text(
                                "${bus["operator"].toString()} - ${bus["busType"].toString()}",
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16 * widthP,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [

                                    Text(
                                      "₹. ${bus["ticketPrice"].toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19 * widthP),
                                    ),

                                    SizedBox(height: 0,width: 5*widthP,)
                                  ],
                                ),
                                // SizedBox(
                                //   height: 25 * heightF,
                                //   width: 80 * widthP,
                                //   child: Stack(
                                //     children: [
                                //       Align(
                                //         alignment: Alignment.center,
                                //         child: Container(
                                //           height: 20 * heightF,
                                //           width: 70 * widthP,
                                //           color: Colors.green,
                                //         ),
                                //       ),
                                //       Center(
                                //         child: Text(
                                //           "OFF ₹. ${bus["ticketPrice"].toString()}",
                                //           style: TextStyle(
                                //             fontSize: 12 * widthP,
                                //             fontWeight: FontWeight.bold,
                                //             color: Colors.white,
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                SizedBox(
                                  height: 5 * heightF,
                                ),
                                SizedBox(
                                  height: 5 * heightF,
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SelectSeat(
                                            from: widget.from,
                                            to: widget.to,
                                            date: widget.date,
                                            busDetails: bus),
                                      ),
                                    );
                                    // DatabaseReference ref1 = FirebaseDatabase
                                    //     .instance
                                    //     .ref()
                                    //     .child(
                                    //         "${GlobalVariable.appType}/project-backend")
                                    //     .child("account");

                                    // final counterSnapshot = await ref1
                                    //     .child(
                                    //         "phone-data/user-phone-connection")
                                    //     .child(uid.toString())
                                    //     .child("phone")
                                    //     .get();
                                    // if (counterSnapshot.value == "true") {
                                    //   Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => bdPoint(
                                    //         from: widget.from,
                                    //         to: widget.to,
                                    //         date: widget.date,
                                    //         itemId:
                                    //             bus["item-id"].toString(),
                                    //         routeId: bus["this-route-id"]
                                    //             .toString(),
                                    //       ),
                                    //     ),
                                    //   );
                                    // }
                                    // else {
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(
                                    //     const SnackBar(
                                    //       content: Text(
                                    //           "Please add your phone number from account."),
                                    //     ),
                                    //   );

                                    //   showDialog(
                                    //     context: context,
                                    //     builder: (context) {
                                    //       return StatefulBuilder(
                                    //         builder: (context, setState) {
                                    //           return AlertDialog(
                                    //             // <-- SEE HERE
                                    //             title: const Text(
                                    //                 'Add Phone Number'),
                                    //             content: Form(
                                    //               key: _formkey,
                                    //               child: TextFormField(
                                    //                 controller:
                                    //                     phoneController,
                                    //                 keyboardType:
                                    //                     TextInputType
                                    //                         .phone,
                                    //                 decoration: InputDecoration(
                                    //                     labelText: "Enter your mobile no again.",
                                    //                     prefixIcon: Container(
                                    //                         padding: EdgeInsets.symmetric(horizontal: 10 * widthP),
                                    //                         height: 40 * heightF,
                                    //                         width: 85 * widthP,
                                    //                         child: DropdownButton<String>(
                                    //                           value:
                                    //                               country,
                                    //                           items: <String>[
                                    //                             '+977',
                                    //                             '+91'
                                    //                           ].map<
                                    //                               DropdownMenuItem<
                                    //                                   String>>((String
                                    //                               value) {
                                    //                             return DropdownMenuItem<
                                    //                                     String>(
                                    //                                 value:
                                    //                                     value,
                                    //                                 child:
                                    //                                     Text(
                                    //                                   value,
                                    //                                   style:
                                    //                                       TextStyle(fontSize: widthP * 15),
                                    //                                 ));
                                    //                           }).toList(),
                                    //                           onChanged:
                                    //                               (String?
                                    //                                   newValue) {
                                    //                             setState(
                                    //                                 () {
                                    //                               country =
                                    //                                   newValue!;
                                    //                             });
                                    //                           },
                                    //                         )),
                                    //                     border: OutlineInputBorder(
                                    //                       borderRadius:
                                    //                           BorderRadius
                                    //                               .circular(
                                    //                                   10),
                                    //                     )),
                                    //                 style: TextStyle(
                                    //                   color: Colors
                                    //                       .grey.shade600,
                                    //                 ),
                                    //                 validator: (value) {
                                    //                   if (value!.length !=
                                    //                       10) {
                                    //                     return "Invalid phone no.";
                                    //                   } else {
                                    //                     return null;
                                    //                   }
                                    //                 },
                                    //               ),
                                    //             ),

                                    //             actions: <Widget>[
                                    //               TextButton(
                                    //                 child:
                                    //                     const Text('No'),
                                    //                 onPressed: () {
                                    //                   Navigator.of(
                                    //                           context)
                                    //                       .pop();
                                    //                 },
                                    //               ),
                                    //               TextButton(
                                    //                 style: TextButton.styleFrom(
                                    //                     backgroundColor:
                                    //                         Color(
                                    //                             0xff7d2aff)),
                                    //                 child: Text(
                                    //                   "Yes",
                                    //                   style: TextStyle(
                                    //                       color: Colors
                                    //                           .white),
                                    //                 ),
                                    //                 onPressed: () async {
                                    //                   String fullNumber =
                                    //                       country +
                                    //                           phoneController
                                    //                               .text
                                    //                               .toString();

                                    //                   if (phoneController
                                    //                           .text
                                    //                           .length ==
                                    //                       10) {
                                    //                     String uid =
                                    //                         await Auth
                                    //                             .uid();

                                    //                     DatabaseReference
                                    //                         ref =
                                    //                         FirebaseDatabase
                                    //                             .instance
                                    //                             .ref()
                                    //                             .child(
                                    //                                 "${GlobalVariable.appType}/project-backend")
                                    //                             .child(
                                    //                                 "account"); //Todo: change the type to Query

                                    //                     final counterSnapshot =
                                    //                         await ref
                                    //                             .child(
                                    //                                 "user-phone")
                                    //                             .child(
                                    //                                 fullNumber)
                                    //                             .get();
                                    //                     if (counterSnapshot
                                    //                             .value
                                    //                             .runtimeType ==
                                    //                         Null) {
                                    //                       ref
                                    //                           .child(
                                    //                               "user-data/user")
                                    //                           .child(uid)
                                    //                           .update({
                                    //                         "phone": fullNumber
                                    //                             .toString()
                                    //                             .trim(),
                                    //                         "updated-at": DateTime
                                    //                                 .now()
                                    //                             .millisecondsSinceEpoch
                                    //                             .toString(),
                                    //                       });
                                    //                       ref
                                    //                           .child(
                                    //                               "phone-data/user-phone-connection")
                                    //                           .child(uid)
                                    //                           .update({
                                    //                         "phone":
                                    //                             "true",
                                    //                       });
                                    //                       ref
                                    //                           .child(
                                    //                               "user-phone")
                                    //                           .update({
                                    //                         fullNumber
                                    //                                 .toString():
                                    //                             uid,
                                    //                       });

                                    //                       ref
                                    //                           .child(
                                    //                               "all-phone/user")
                                    //                           .push()
                                    //                           .update({
                                    //                         fullNumber
                                    //                                 .toString():
                                    //                             uid,
                                    //                       });

                                    //                       Navigator.pop(
                                    //                           context);
                                    //                     } else {
                                    //                       ScaffoldMessenger.of(
                                    //                               context)
                                    //                           .showSnackBar(
                                    //                         const SnackBar(
                                    //                           content: Text(
                                    //                               "Phone number already exits."),
                                    //                         ),
                                    //                       );
                                    //                     }
                                    //                   } else {
                                    //                     ScaffoldMessenger
                                    //                             .of(context)
                                    //                         .showSnackBar(
                                    //                       const SnackBar(
                                    //                         content: Text(
                                    //                             "Enter 10 digit numbers"),
                                    //                       ),
                                    //                     );
                                    //                   }
                                    //                 },
                                    //               ),
                                    //             ],
                                    //           );
                                    //         },
                                    //       );
                                    //     },
                                    //   );
                                    // }
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1 * widthP),
                                      child: Text(
                                        "Select Seat",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16 * widthP,
                                        ),
                                      )),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.amber.shade800,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10 * widthP),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Amenities'),
                                          content: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16 * widthP,
                                              // vertical: 16 * heightF,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Icon(Icons
                                                          .cancel_outlined)),
                                                ),
                                                for (String value
                                                    in bus["amenities"]) ...[
                                                  ListTile(
                                                    subtitle:
                                                        Text(value.toString()),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    "Amenities",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber.shade800,
                                    ),
                                  )),
                              GestureDetector(
                                onTap: () {
                                  // Map imageMap = bus["images"] as Map;
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (BuildContext context) =>
                                  //         Images(imageMap: imageMap),
                                  //   ),
                                  // );
                                },
                                child: Text(
                                  "Bus Pictures",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
                SizedBox(
                  height: 15 * heightF,
                ),
                GlobalFooter.footer(context),
                SizedBox(
                  height: 15 * heightF,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
