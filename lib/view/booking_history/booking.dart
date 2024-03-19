//Todo: change from clint
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/footer/footer.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/booking_history/ticket_details.dart';
import 'package:fabyatra/view/loading.dart';

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

  Widget listItem(myBus) {
    // print("myBus");
    // print(myBus);
    return InkWell(
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
              offset: Offset(1.0, 1.0),
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
                                  fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                            Text(
                              myBus["journey-date-day-only"],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 12),
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
                                  fontWeight: FontWeight.w300, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bus Ticket",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              myBus["journey-from"].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
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
                              myBus["journey-to"].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          myBus["bus-details"]["company-name"].toString() +
                              " - " +
                              myBus["bus-details"]["bus-type"].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w200, fontSize: 13),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "FabYatra",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
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
                fontSize: 19,
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
                                listItem(myBus)
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
                                listItem(myBus)
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
                                listItem(myBus)
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
    Stream<DatabaseEvent> stream =
        ref.child("account/user-data/user").child(uid).child("ticket").onValue;

    stream.listen((DatabaseEvent event) async {
      allTicketData.clear();
      fullTicketDataCancel.clear();
      fullTicketDataComplete.clear();
      fullTicketDataUpcoming.clear();
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

        allTicketData
            .sort((a, b) => a["journey-date"].compareTo(b["journey-date"]));

        for (var ticketData in allTicketData) {
          final counterSnapshot1 = await ref
              .child("ticket")
              .child(ticketData["journey-date"].toString())
              .child(ticketData["ticket-id"].toString())
              .get();

          if (counterSnapshot1.value.runtimeType != Null) {
            Map thisData = counterSnapshot1.value as Map;

            final counterSnapshot2 = await ref
                .child("vehicle/details/bus")
                .child(thisData["bus-no"].toString())
                .get();
            thisData["bus-details"] = {};

            if (counterSnapshot2.value.runtimeType != Null) {
              Map thisData2 = counterSnapshot2.value as Map;

              thisData2.forEach((k, v) => thisData["bus-details"][k] = v);
            }

            String journeyDate = thisData["journey-date"];
            String journeyBtime = thisData["journey-btime"];

            int thisStampTime = DateTime(
                    int.parse(journeyDate.toString().split("-")[0]),
                    int.parse(journeyDate.toString().split("-")[1]),
                    int.parse(journeyDate.split("-")[2]),
                    int.parse(journeyBtime.split(":")[0]),
                    int.parse(journeyBtime.split(":")[1]),
                    0)
                .millisecondsSinceEpoch;

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
            print(thisData["bus-details"]);
            print("thisData");

            if (myStatus == "active") {
              if ((thisStampTime - (20 * 60 * 1000)) < nowTimeStamp) {
                thisData["view-status"] = "complete";
                thisData["status-no"] = "2";
              } else {
                thisData["view-status"] = "upcoming";
                thisData["status-no"] = "1";
              }
            } else {
              thisData["view-status"] = myStatus;
              thisData["status-no"] = "3";
            }

            setState(() {
              if (thisData["view-status"] == "upcoming") {
                fullTicketDataUpcoming.add(thisData);
              } else if (thisData["view-status"] == "complete") {
                fullTicketDataComplete.add(thisData);
              } else {
                fullTicketDataCancel.add(thisData);
              }
            });
          }
        }

        setState(() {
          fullTicketDataCancel.sort((b, a) => a['journey-date']
              .toString()
              .compareTo(b['journey-date'].toString()));

          fullTicketDataCancel.sort((a, b) => a['view-status']
              .toString()
              .compareTo(b['view-status'].toString()));

          fullTicketDataCancel.sort((a, b) =>
              a['status-no'].toString().compareTo(b['status-no'].toString()));

          fullTicketDataUpcoming.sort((a, b) => a['journey-date']
              .toString()
              .compareTo(b['journey-date'].toString()));
        });
      }
    });
    setState(() {
      showLoading = false;
    });
  }
}
