//Todo: change from clint
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/footer/footer.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/booking_history/ticket_details.dart';
import 'package:fabyatra/view/loading.dart';
import 'package:http/http.dart' as http;

class booking extends StatefulWidget {
  const booking({super.key});

  @override
  State<booking> createState() => _bookingState();
}

class _bookingState extends State<booking> with SingleTickerProviderStateMixin {
  DatabaseReference ref = FirebaseDatabase.instance
      .ref()
      .child("${GlobalVariable.appType}/project-backend");
  String uid = "";
  List allTicketData = [];
  List fullTicketDataUpcoming = [];
  List fullTicketDataComplete = [];
  List fullTicketDataCancel = [];

  int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;

  // var kathmandu = tz.getLocation('Asia/Kathmandu');

  Map busDetails = {};

  bool showLoading = false;

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Upcoming'),
    Tab(text: 'Completed'),
    Tab(text: 'Canceled'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    firstData();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget listItem(myBus, context) {
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);
    print("myBus");
    print(myBus.keys.toList());
    print(myBus["busDetails"]);
    print(myBus);
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TicketDetails(myBus: myBus),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.60),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 0.0),
                )
              ],
            ),
            child: Container(
              // margin: const EdgeInsets.all(10),
              // height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade800,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Container(
                            child: Column(
                              children: [
                                ClipOval(
                                  child: Container(
                                      width: 45,
                                      height: 45,
                                      padding: EdgeInsets.all(5),
                                      color: Colors.white,
                                      child: ClipOval(
                                        child: Image.asset(
                                          "images/bus.png",
                                          width: 20,
                                          color: Colors.amber.shade800,
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  myBus["journey-date-date-only"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                ),
                                Text(
                                  myBus["journey-date-day-only"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12*heightF),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Divider(
                                  height: 3,
                                  thickness: 1,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  myBus["journey-date-month-only"] +
                                      " " +
                                      myBus["journey-date-year-only"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12*heightF),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ticket No: ${myBus["ticketSrlno"]}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 13*heightF),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    myBus["from"].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15*heightF),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  SizedBox(
                                    width: 8,
                                    child: Divider(
                                      height: 3,
                                      thickness: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    myBus["to"].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15*heightF),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                ((myBus["busDetails"]["operator"]
                                                .toString()
                                                .length +
                                            myBus["busDetails"]["busType"]
                                                .toString()
                                                .length) >=
                                        5)
                                    ? (myBus["busDetails"]["operator"]
                                            .toString() +
                                        " - " +
                                        myBus["busDetails"]["busType"]
                                            .toString())
                                    : myBus["busDetails"]["operator"]
                                            .toString() +
                                        "...",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 13*heightF),
                              ),
                              SizedBox(
                                height: 20*heightF,
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ScratchCardDialog();
                                    },
                                  );
                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Color.fromARGB(255, 212, 246, 229),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0, bottom: 2.0),
                                      child: Text(
                                        "Points available",
                                        style: TextStyle(
                                            fontSize: 16*heightF,
                                            color:
                                                Color.fromARGB(255, 0, 255, 8),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            ),
          ),
        ),

        //   Todo: Add Card

        SizedBox(
          height: 5,
          width: 0,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'My Bookings',
              style: TextStyle(
                color: Colors.black,
                fontSize: 19*heightF,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          backgroundColor: Colors.amber.shade200,
          bottom: TabBar(
            indicatorColor: Colors.amber.shade800,
            labelColor: Colors.amber.shade800,
            unselectedLabelColor: Colors.grey.shade500,
            controller: _tabController,
            tabs: myTabs,
          ),
        ),
        body: showLoading == true
            ? Container(
                child: LottieDialog(),
              )
            : Container(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              for (Map myBus in fullTicketDataUpcoming) ...[
                                listItem(myBus, context)
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              for (Map myBus in fullTicketDataComplete) ...[
                                listItem(myBus, context)
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              for (Map myBus in fullTicketDataCancel) ...[
                                listItem(myBus, context)
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
    );
  }

  Future<void> firstData() async {
    setState(() {
      showLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid')!;
    setState(() {});
    Stream<DatabaseEvent> stream = ref
        .child("account/user-data/user")
        .child(uid)
        .child("ticket-api-busSewa")
        .onValue;

    stream.listen((DatabaseEvent event) async {
      // allTicketData.clear();
      // fullTicketDataCancel.clear();
      // fullTicketDataComplete.clear();
      // fullTicketDataUpcoming.clear();
      if (event.snapshot.value != null) {
        Map dataM = event.snapshot.value as Map;
        List dataL = dataM.keys.toList();
        for (var data1 in dataL) {
          Map data1M = dataM[data1] as Map;
          List data1L = data1M.keys.toList();

          for (var data2 in data1L) {
            Map data2M = dataM[data1][data2] as Map;
            print(data2M);
            if (data2M["status"] != "incomplete") {
              allTicketData.add(data2M);
            }
          }
        }

        allTicketData.sort((a, b) => a["date"].compareTo(b["date"]));

        for (var ticketData in allTicketData) {
          final counterSnapshot1 = await ref
              .child("ticket-api-busSewa")
              .child(ticketData["ticketSrlno"].toString())
              .get();
          //call ticket

          if (counterSnapshot1.value.runtimeType != Null) {
            Map thisData = counterSnapshot1.value as Map;

            Map<String, dynamic> requestData = {
              "id": thisData['budId'],
              // "refId": "30064",
              "ticketSrlNo": thisData["ticketSrlNo"]
            };

            // // Convert request data to JSON
            // String requestBody = jsonEncode(requestData);
            //
            // String apiUrl =
            //     'https://diyalodev.com/customer/webresources/booking/queryTicket';
            //
            // // Make the API call with basic authentication
            // final username = 'fab_yatra';
            // final password = 'f@BY@tra_03_03';
            // final response = await http.post(
            //   Uri.parse(apiUrl),
            //   headers: <String, String>{
            //     'Content-Type': 'application/json; charset=UTF-8',
            //     'Authorization':
            //         'Basic ' + base64Encode(utf8.encode('$username:$password')),
            //   },
            //   body: requestBody,
            // );

            final counterSnapshot2 = await ref
                .child("vehicle/details/bus")
                .child(thisData["bus-no"].toString())
                .get();

            String journeyDate = thisData["date"];
            // String journeyBtime = thisData["journey-btime"];

            int thisStampTime = DateTime(
              int.parse(journeyDate.toString().split("-")[0]),
              int.parse(journeyDate.toString().split("-")[1]),
              int.parse(journeyDate.split("-")[2]),
              // int.parse(journeyBtime.split(":")[0]),
              // int.parse(journeyBtime.split(":")[1]),
              // 0
            ).millisecondsSinceEpoch;

            DateTime date = DateTime.fromMillisecondsSinceEpoch(thisStampTime);

            switch (date.month) {
              case 1:
                thisData["journey-date-month-only"] = "Jan";
                break;
              case 2:
                thisData["journey-date-month-only"] = "Feb";
                break;
              case 3:
                thisData["journey-date-month-only"] = "Mar";
                break;
              case 4:
                thisData["journey-date-month-only"] = "Apr";
                break;
              case 5:
                thisData["journey-date-month-only"] = "May";
                break;
              case 6:
                thisData["journey-date-month-only"] = "Jun";
                break;
              case 7:
                thisData["journey-date-month-only"] = "Jul";
                break;
              case 8:
                thisData["journey-date-month-only"] = "Aug";
                break;
              case 9:
                thisData["journey-date-month-only"] = "Sep";
                break;
              case 10:
                thisData["journey-date-month-only"] = "Oct";
                break;
              case 11:
                thisData["journey-date-month-only"] = "Nov";
                break;
              case 12:
                thisData["journey-date-month-only"] = "Dec";
                break;
            }

            switch (date.weekday) {
              case 1:
                thisData["journey-date-day-only"] = "Monday";
                break;
              case 2:
                thisData["journey-date-day-only"] = "Tuesday";
                break;
              case 3:
                thisData["journey-date-day-only"] = "Wednesday";
                break;
              case 4:
                thisData["journey-date-day-only"] = "Thursday";
                break;
              case 5:
                thisData["journey-date-day-only"] = "Friday";
                break;
              case 6:
                thisData["journey-date-day-only"] = "Saturday";
                break;
              case 7:
                thisData["journey-date-day-only"] = "Sunday";
                break;
            }

            thisData["journey-date-date-only"] = journeyDate.split("-")[2];
            thisData["journey-date-year-only"] = journeyDate.split("-")[0];

            print(thisData["journey-date-month-only"]);
            print(thisData["journey-date-day-only"]);
            print(thisData["journey-date-date-only"]);
            print(thisData["journey-date-year-only"]);
            print("earonly");

            String myStatus = thisData["status"];
            print(myStatus);
            print("thisData");

            if (myStatus == "active") {
              if ((thisStampTime - (20 * 60 * 1000)) < nowTimeStamp) {
                thisData["view-status"] = "complete";
                thisData["status-no"] = "2";
              } else {
                thisData["view-status"] = "upcoming";
                thisData["status-no"] = "1";
              }
            } else if (myStatus == "cancel" || myStatus == "refund") {
              thisData["view-status"] = myStatus;
              thisData["status-no"] = "3";
            }
            if (thisData["status-no"] == "1") {
              fullTicketDataUpcoming.add(thisData);
            } else if (thisData["status-no"] == "2") {
              fullTicketDataComplete.add(thisData);
            } else if (thisData["status-no"] == "3") {
              fullTicketDataCancel.add(thisData);
            }
            setState(() {});
          }
        }

        print("fullTicketDataUpcoming");
        print(fullTicketDataUpcoming.length);
        print(fullTicketDataUpcoming);
        print("fullTicketDataUpcoming");

        print("fullTicketDataComplete");
        print(fullTicketDataComplete.length);
        print(fullTicketDataComplete);
        print("fullTicketDataComplete");

        print("fullTicketDataCancel");
        print(fullTicketDataCancel.length);
        print(fullTicketDataCancel);
        print("fullTicketDataCancel");

        setState(() {});
        // setState(() {
        //   fullTicketDataCancel.sort((b, a) => a['journey-date']
        //       .toString()
        //       .compareTo(b['journey-date'].toString()));

        //   fullTicketDataCancel.sort((a, b) => a['view-status']
        //       .toString()
        //       .compareTo(b['view-status'].toString()));

        //   fullTicketDataCancel.sort((a, b) =>
        //       a['status-no'].toString().compareTo(b['status-no'].toString()));

        //   fullTicketDataUpcoming.sort((a, b) => a['journey-date']
        //       .toString()
        //       .compareTo(b['journey-date'].toString()));
        // });
      }
    });
    setState(() {
      showLoading = false;
    });
  }
}

class ScratchCardDialog extends StatefulWidget {
  @override
  State<ScratchCardDialog> createState() => _ScratchCardDialogState();
}

class _ScratchCardDialogState extends State<ScratchCardDialog> {
  GlobalKey<ScratcherState> _scratcherKey = GlobalKey();
  bool _isAutoReveal = false;
  bool _isScratched = false;

  @override
  Widget build(BuildContext context) {
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Scratcher(
          key: _scratcherKey,
          color: Colors.orangeAccent,
          accuracy: ScratchAccuracy.low,
          brushSize: 40,
          threshold: 40,
          onThreshold: () {
            setState(() {
              _isScratched = true;
            });

            _scratcherKey.currentState?.reveal();
          },
          child: Container(
              // decoration: ,
              alignment: Alignment.center,
              height: 200 * heightP,
              width: 300 * widthP,
              color: Color.fromARGB(255, 244, 239, 239),
              child: _isScratched
                  ? Text(
                      'Revealed Content',
                      style: TextStyle(
                        fontSize: 20*heightF,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      'Scratch Here!',
                      style: TextStyle(
                        fontSize: 20*heightF,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
        ),
      ),
    );
  }
}



