import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/loading.dart';
import 'package:fabyatra/view/search_bus/confirm_ticket.dart';

class SelectSeat extends StatefulWidget {
  const SelectSeat({
    super.key,
    required this.itemId,
    required this.from,
    required this.to,
    required this.date,
    required this.routeId,
    required this.bpoint,
    required this.dbdpoint,
    required this.btime,
    required this.dbdtime,
  });

  final String bpoint;
  final String dbdpoint;
  final String btime;
  final String dbdtime;
  final String itemId;
  final String routeId;
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

  List<Object?> upperSeat = [];
  List<Object?> lowerSeat = [];
  bool showLoading = false;

  List bookSeatId = [];

  bool _isPresseds = true;
  bool _isPressedd = false;
  int floorValue = 1;

  double seaterPrice = 0;
  double sleeperPrice = 0;
  double sleeperPriceOffer = 0;
  double seaterPriceOffer = 0;

  double myPrice = 0, myOriginalPrice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPrice();
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
                                  "Slected",
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
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _isPresseds = true;
                                  _isPressedd = false;
                                  floorValue = 1;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "Lower",
                                  style: TextStyle(
                                    color: _isPresseds
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: _isPresseds
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: _isPresseds
                                        ? Colors.amber.shade800
                                        : Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                elevation: 0,
                                backgroundColor: _isPresseds
                                    ? Colors.amber.shade800
                                    : Colors.grey.shade300,
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _isPressedd = true;
                                  _isPresseds = false;
                                  floorValue = 2;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "Upper",
                                  style: TextStyle(
                                    color: _isPressedd
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: _isPressedd
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: _isPressedd
                                        ? Colors.amber.shade800
                                        : Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                elevation: 0,
                                backgroundColor: _isPressedd
                                    ? Colors.amber.shade800
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: _isPresseds,
                          child: Container(
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
                                                : columnsSeatDate["type"] == "1"
                                                    ? _seaterSeat(
                                                        columnsSeatDate:
                                                            columnsSeatDate,
                                                        female: true,
                                                        booked: columnsSeatDate[
                                                            "isBooked"],
                                                        seatNo: columnsSeatDate[
                                                            "number"],
                                                        seatId: columnsSeatDate[
                                                            "seat-id"],
                                                        price: seaterPrice -
                                                            seaterPriceOffer,
                                                        originalPrice:
                                                            seaterPriceOffer,
                                                      )
                                                    : _sleeperSeat(
                                                        columnsSeatDate:
                                                            columnsSeatDate,
                                                        female: true,
                                                        booked: columnsSeatDate[
                                                            "isBooked"],
                                                        seatNo: columnsSeatDate[
                                                            "number"],
                                                        seatId: columnsSeatDate[
                                                            "seat-id"],
                                                        price: sleeperPrice -
                                                            sleeperPriceOffer,
                                                        originalPrice:
                                                            sleeperPriceOffer,
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
                        ),
                        Visibility(
                          visible: _isPressedd,
                          child: Container(
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
                                    for (var columns in upperSeat) ...[
                                      Column(
                                        children: [
                                          for (var columnsSeatDate
                                              in columns as List) ...[
                                            columnsSeatDate["type"] == "0"
                                                ? _blankSeat()
                                                : columnsSeatDate["type"] == "1"
                                                    ? _seaterSeat(
                                                        columnsSeatDate:
                                                            columnsSeatDate,
                                                        female: true,
                                                        booked: columnsSeatDate[
                                                            "isBooked"],
                                                        seatNo: columnsSeatDate[
                                                            "number"],
                                                        seatId: columnsSeatDate[
                                                            "seat-id"],
                                                        price: seaterPrice -
                                                            seaterPriceOffer,
                                                        originalPrice:
                                                            seaterPriceOffer,
                                                      )
                                                    : _sleeperSeat(
                                                        columnsSeatDate:
                                                            columnsSeatDate,
                                                        female: true,
                                                        booked: columnsSeatDate[
                                                            "isBooked"],
                                                        seatNo: columnsSeatDate[
                                                            "number"],
                                                        seatId: columnsSeatDate[
                                                            "seat-id"],
                                                        price: sleeperPrice -
                                                            sleeperPriceOffer,
                                                        originalPrice:
                                                            sleeperPriceOffer,
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
                        )
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
                        if (!selectSeatData.isEmpty) {
                          for (Map data in selectSeatData) {
                            final counterSnapshot = await ref
                                .child("details")
                                .child("bus")
                                .child(widget.itemId.toString())
                                .child("ticket")
                                .child(widget.date.toString())
                                .child(data["seat-id"].toString())
                                .get();
                            // print(counterSnapshot.value.runtimeType);
                            if (counterSnapshot.value.runtimeType != Null) {
                              Map myData = counterSnapshot.value as Map;
                              int myTime =
                                  int.parse(myData["created-at"].toString()) +
                                      (8 * 60 * 1000);

                              if (myData["status"] == "active") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelectSeat(
                                      bpoint: widget.bpoint,
                                      dbdpoint: widget.dbdpoint,
                                      btime: widget.btime,
                                      dbdtime: widget.dbdtime,
                                      itemId: widget.itemId,
                                      from: widget.from,
                                      to: widget.to,
                                      date: widget.date,
                                      routeId: widget.routeId,
                                    ),
                                  ),
                                );
                                return;
                              } else if (myData["status"] != "active" &&
                                  myTime <
                                      DateTime.now().millisecondsSinceEpoch) {
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelectSeat(
                                      bpoint: widget.bpoint,
                                      dbdpoint: widget.dbdpoint,
                                      btime: widget.btime,
                                      dbdtime: widget.dbdtime,
                                      itemId: widget.itemId,
                                      from: widget.from,
                                      to: widget.to,
                                      date: widget.date,
                                      routeId: widget.routeId,
                                    ),
                                  ),
                                );

                                return;
                              }
                            }
                          }

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmTicket(
                                bpoint: widget.bpoint,
                                dbdpoint: widget.dbdpoint,
                                btime: widget.btime,
                                dbdtime: widget.dbdtime,
                                itemId: widget.itemId,
                                from: widget.from,
                                to: widget.to,
                                date: widget.date,
                                routeId: widget.routeId,
                                selectSeatData: selectSeatData,
                                seaterPrice: seaterPrice,
                                sleeperPrice: sleeperPrice,
                                sleeperPriceOffer: sleeperPriceOffer,
                                seaterPriceOffer: seaterPriceOffer,
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

  int floor = 1;

  List<dynamic> selectSeatData = [];

  GestureDetector _sleeperSeat(
      {required bool female,
      required bool booked,
      required String seatNo,
      required String seatId,
      required double price,
      required double originalPrice,
      required Map columnsSeatDate}) {
    return GestureDetector(
      onTap: booked == false
          ? () {
              setState(() {
                if (selectSeatData.contains(columnsSeatDate)) {
                  selectSeatData.remove(columnsSeatDate);

                  myPrice = myPrice - price;
                  myOriginalPrice = myOriginalPrice - originalPrice;
                } else {
                  selectSeatData.add(columnsSeatDate);

                  myPrice = myPrice + price;
                  myOriginalPrice = myOriginalPrice + originalPrice;
                }
              });
            }
          : () {},
      // myVar == null ? 0 : myVar
      child: Container(
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 25,
          bottom: 25,
        ),
        height: 60,
        width: 35,
        child: SvgPicture.asset(
          // height: 70,
          // width: 35,
          fit: BoxFit.fitHeight,
          'images/sleeper.svg',
          color: booked == true
              ? Colors.grey
              : selectSeatData.contains(columnsSeatDate)
                  ? Colors.green
                  : Colors.amber.shade800,
        ),
      ),
    );
  }

  GestureDetector _seaterSeat(
      {required bool female,
      required bool booked,
      required String seatNo,
      required String seatId,
      required double price,
      required double originalPrice,
      required Map columnsSeatDate}) {
    return GestureDetector(
      onTap: booked == false
          ? () {
              setState(() {
                if (selectSeatData.contains(columnsSeatDate)) {
                  selectSeatData.remove(columnsSeatDate);

                  myPrice = myPrice - price;
                  myOriginalPrice = myOriginalPrice - originalPrice;
                } else {
                  selectSeatData.add(columnsSeatDate);

                  myPrice = myPrice + price;
                  myOriginalPrice = myOriginalPrice + originalPrice;
                }
              });
            }
          : () {},
      child: Container(
        margin: EdgeInsets.all(10),
        height: 35,
        width: 35,
        child: SvgPicture.asset(
          'images/seat.svg',
          color: booked == true
              ? Colors.grey
              : selectSeatData.contains(columnsSeatDate)
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

  Future<void> subscribeData() async {
    setState(() {
      // print("3");
      showLoading = true;
    });

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("${GlobalVariable.appType}/project-backend")
        .child("vehicle")
        .child("details")
        .child("bus")
        .child(widget.itemId); //Todo: change the type to Query

    Stream<DatabaseEvent> stream = ref
        .child("floor")
        .onValue;

    stream.listen((DatabaseEvent event) {
      setState(() {
        floor = int.parse(event.snapshot.value.toString());
      });
    });


    final stream1 = await ref
        .child("seat-data")
        .child("1")
        .get();
    // print(stream1.value.runtimeType);
    // print(stream1.value);
    if (stream1.value.runtimeType != Null) {

      // Stream<DatabaseEvent> stream1 = ref.child("seat-data").child("1").onValue;
    //
    // stream1.listen((DatabaseEvent event) async {

    List<Object?> seatData = stream1.value as List;
    lowerSeat = [];
    for (var seats in seatData) {
      if (seats != null) {
        List<Object?> seatListData = [];
        for (var seat in seats as List) {
          if (seat != null) {
            Map thisSeatData = seat as Map;

            final counterSnapshot = await ref
                .child("ticket")
                .child(widget.date.toString())
                .child(thisSeatData["seat-id"].toString())
                .get();
            if (counterSnapshot.value.runtimeType == Null) {
              thisSeatData["isBooked"] = false;
            } else {
              Map myData = counterSnapshot.value as Map;
              int myTime = int.parse(myData["created-at"].toString()) +
                  (8 * 60 * 1000);
              if (myData["status"] == "active") {
                thisSeatData["isBooked"] = true;
              } else if (myData["status"] != "active" &&
                  myTime < DateTime
                      .now()
                      .millisecondsSinceEpoch) {
                thisSeatData["isBooked"] = false;
              } else {
                thisSeatData["isBooked"] = true;
              }
            }

            seatListData.add(thisSeatData);
          }
        }
        lowerSeat.add(seatListData);
      }
    }
    setState(() {
      // print("1");
    });


    // });

  }

    final stream2 = await ref
        .child("seat-data")
        .child("2")
    .get();

    if (stream2.value.runtimeType != Null) {
      // Stream<DatabaseEvent> stream2 = ref.child("seat-data").child("2").onValue;
      //
      // stream2.listen((DatabaseEvent event) async {

      upperSeat = [];
      // if (event.snapshot.value.runtimeType != Null) {
        List<Object?> seatData = stream2.value as List;
        for (var seats in seatData) {
          if (seats != null) {
            List<Object?> seatListData = [];
            for (var seat in seats as List) {
              if (seat != null) {
                Map thisSeatData = seat as Map;
                final counterSnapshot = await ref
                    .child("ticket")
                    .child(widget.date.toString())
                    .child(thisSeatData["seat-id"].toString())
                    .get();
                if (counterSnapshot.value.runtimeType == Null) {
                  thisSeatData["isBooked"] = false;
                } else {
                  Map myData = counterSnapshot.value as Map;
                  int myTime = int.parse(myData["created-at"].toString()) +
                      (10 * 60 * 1000);
                  if (myData["status"] == "active") {
                    thisSeatData["isBooked"] = true;
                  } else if (myData["status"] != "active" &&
                      myTime < DateTime
                          .now()
                          .millisecondsSinceEpoch) {
                    thisSeatData["isBooked"] = false;
                  } else {
                    thisSeatData["isBooked"] = true;
                  }
                }
                seatListData.add(thisSeatData);
              }
            }
            upperSeat.add(seatListData);
          }
        }
      // }
      setState(() {
        // print("2");
      });
      // });
    }


    setState(() {
      // print("ggggggggggggggg");
      showLoading = false;
    });
  }

  Future<void> getPrice() async {


    setState(() {
      showLoading = true;
    });

    final counterSnapshot = await ref
        .child("details")
        .child("bus")
        .child(widget.itemId.toString())
        .child("route")
        .child(widget.routeId.toString())
        .get();

    if (counterSnapshot.value.runtimeType == Null) {
    } else {
      Map thisSeatData = counterSnapshot.value as Map;
      setState(() {
        seaterPrice = double.parse(thisSeatData["seater-price"].toString());
        sleeperPrice = double.parse(thisSeatData["sleeper-price"].toString());
        sleeperPriceOffer = double.parse(thisSeatData["sleeper-offer-price"].toString());
        seaterPriceOffer = double.parse(thisSeatData["seater-offer-price"].toString());
      });
    }

    setState(() {
      showLoading = false;
    });

    subscribeData();

  }
}
