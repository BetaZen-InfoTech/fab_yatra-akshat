import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/footer/footer.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

// import 'package:timezone/standalone.dart' as tz;
import 'package:fabyatra/view/home/home_navigation.dart';
import 'package:fabyatra/view/loading.dart';

class TicketDetails extends StatefulWidget {
  const TicketDetails({
    super.key,
    required this.myBus,
  });

  final Map myBus;

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  String uid = "";

  // final kathmandu =  tz.getLocation('Asia/Kathmandu');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    firstData();
  }

  Map busDetails = {};

  DatabaseReference ref = FirebaseDatabase.instance
      .ref()
      .child(GlobalVariable.appType); //Todo: change the type to Query

  bool showLoading = false;

  int nowTimeStamp = DateTime.now().millisecondsSinceEpoch;

  bool cancelActive = false;
  bool refundActive = false;

  double cancellationFees = 100.0;
  double refundAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade200,
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
        title: Row(
          children: [
            SizedBox(width: 1),
            const Spacer(),
            Text(
              'Ticket Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
            const Spacer(),
            SizedBox(width: 45),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: showLoading == true
          ? LottieDialog()
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Card(
                            elevation: 10,
                            child: Container(
                              height: 615 * heightF,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.amber.shade800,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(18),
                                  bottomRight: Radius.circular(18),
                                ),
                                // borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12, top: 10),
                                    child: Container(
                                      // decoration: BoxDecoration(
                                      //   color: Colors.red,
                                      // ),
                                      height: 100 * heightF,
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                width: 140 * widthP,
                                                child: Text(
                                                  "${widget.myBus["journey-from"]}",
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 140 * widthP,
                                                child: Text(
                                                  "${widget.myBus["journey-bpoint"]}",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade200,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            children: [
                                              Container(
                                                width: 140 * widthP,
                                                child: Text(
                                                  "${widget.myBus["journey-to"]}",
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                              Container(
                                                width: 140 * widthP,
                                                child: Text(
                                                  "${widget.myBus["journey-dbdpoint"]}",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade200,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  softWrap: true,
                                                  textAlign: TextAlign.right,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: Container(
                                      // decoration: BoxDecoration(
                                      //   color: Colors.red,
                                      // ),
                                      height: 83 * heightF,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 120 * widthP,
                                                  child: Text(
                                                    "${widget.myBus["journey-btime"]}",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    softWrap: true,
                                                  ),
                                                ),
                                                Container(
                                                  width: 120 * widthP,
                                                  child: Text(
                                                    DateFormat('EEE, d MMM')
                                                        .format(
                                                      DateTime(
                                                        int.parse(widget
                                                            .myBus["journey-date"]
                                                            .split('-')[0]),
                                                        int.parse(widget
                                                            .myBus["journey-date"]
                                                            .split('-')[1]),
                                                        int.parse(widget
                                                            .myBus["journey-date"]
                                                            .split('-')[2]),
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      color: Colors.grey.shade200,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          Column(
                                            children: [
                                              Image.asset(
                                                "images/bus.png",
                                                width: 30,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "${widget.myBus["status"]}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                softWrap: true,
                                                textAlign: TextAlign.right,
                                              )
                                            ],
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 120 * widthP,
                                                  child: Text(
                                                    "${widget.myBus["journey-dbdtime"]}",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    softWrap: true,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                                Container(
                                                  width: 120 * widthP,
                                                  child: Text(
                                                    DateFormat('EEE, d MMM')
                                                        .format(
                                                      DateTime(
                                                        int.parse(widget
                                                            .myBus["journey-date"]
                                                            .split('-')[0]),
                                                        int.parse(widget
                                                            .myBus["journey-date"]
                                                            .split('-')[1]),
                                                        int.parse(widget
                                                            .myBus["journey-date"]
                                                            .split('-')[2]),
                                                      ).add(Duration(days: 1)),
                                                    ),
                                                    style: TextStyle(
                                                      color: Colors.grey.shade200,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    softWrap: true,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 420 * heightF,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 5,
                                          ),
                                          child: Text(
                                            "${widget.myBus["bus-details"]["company-name"]}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 19,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            "${widget.myBus["bus-details"]["bus-type"]} /Seater (2+2)",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: LayoutBuilder(
                                            builder: (BuildContext context,
                                                BoxConstraints constraints) {
                                              final boxWidth =
                                                  constraints.constrainWidth();
                                              final dashCount =
                                                  (boxWidth / (1.5 * 7)).floor();
                                              return Flex(
                                                children:
                                                    List.generate(dashCount, (_) {
                                                  return SizedBox(
                                                    width: 7,
                                                    height: 0.5,
                                                    child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey),
                                                    ),
                                                  );
                                                }),
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                direction: Axis.horizontal,
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15, left: 15),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Name",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color:
                                                            Colors.grey.shade700,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      "Seat",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color:
                                                            Colors.grey.shade700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (passengerList.length == 1)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      bottom: 5,
                                                      top: 7,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "${passengerList[0]["name"]}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          "(${passengerList[0]["gender"]})",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey.shade700,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          "${passengerList[0]["number"]}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                if (passengerList.length == 2)
                                                  for (int i = 0; i < 2; i++)
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "${passengerList[i]["name"]}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          "(${passengerList[i]["gender"]})",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey.shade700,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          "${passengerList[i]["number"]}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                if (passengerList.length > 2) ...[
                                                  for (int i = 0; i < 2; i++)
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "${passengerList[i]["name"]}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          "(${passengerList[i]["gender"]})",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey.shade700,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          "${passengerList[i]["number"]}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  Center(
                                                    child: TextButton(
                                                      style: TextButton.styleFrom(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      onPressed: () =>
                                                          showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          title: const Text(
                                                              'Passenger Details'),
                                                          content: Container(
                                                            height: 300 * heightF,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "Name",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade700,
                                                                      ),
                                                                    ),
                                                                    const Spacer(),
                                                                    Text(
                                                                      "Seat",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade700,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                for (int i = 0;
                                                                    i <
                                                                        passengerList
                                                                            .length;
                                                                    i++)
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "${passengerList[i]["name"]}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              15,
                                                                          color: Colors
                                                                              .black,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 3,
                                                                      ),
                                                                      Text(
                                                                        "(${passengerList[i]["gender"]})",
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade700,
                                                                        ),
                                                                      ),
                                                                      const Spacer(),
                                                                      Text(
                                                                        "${passengerList[i]["number"]}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              15,
                                                                          color: Colors
                                                                              .black,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      'OK'),
                                                              child: const Text(
                                                                  'OK'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      child: const Text(
                                                          'Other passengers'),
                                                    ),
                                                  ),
                                                ],
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      bottom: 10),
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                            BoxConstraints
                                                                constraints) {
                                                      final boxWidth = constraints
                                                          .constrainWidth();
                                                      final dashCount =
                                                          (boxWidth / (1.5 * 7))
                                                              .floor();
                                                      return Flex(
                                                        children: List.generate(
                                                            dashCount, (_) {
                                                          return SizedBox(
                                                            width: 7,
                                                            height: 0.5,
                                                            child: DecoratedBox(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                          );
                                                        }),
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        direction:
                                                            Axis.horizontal,
                                                      );
                                                    },
                                                  ),
                                                ), // Row(
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 15),
                                                  child: Text("Ticket#"),
                                                ),
                                                const Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.only(right:17),
                                                  child: Container(
                                                    height: 55 * heightF,
                                                    width: 180 * widthP,
                                                    child: Text(
                                                      "${widget.myBus["ticket-id"]}",
                                                      style: TextStyle(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Row(
                                              children:[
                                                Padding(
                                                  padding: const EdgeInsets.only(left:15),
                                                  child: Text("Office Contact"),
                                                ),
                                                const Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.only(right:10),
                                                  child: Container(
                                                    height:55*heightF,
                                                    width: 170*widthP,

                                                    child: Text("${widget.myBus["bus-details"]["office-contact-person-name"]} - ${widget.myBus["bus-details"]["office-contact-person-number"]}",style:TextStyle(

                                                    ),),),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              height: 10,
                                              thickness: 0.5,
                                              indent: 40,
                                              endIndent: 40,
                                              color: Colors.grey,
                                            ),
                                            Row(
                                              children:[
                                                Padding(
                                                  padding: const EdgeInsets.only(left:15),
                                                  child: Text("Fare", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
                                                ),
                                                const Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.only(right:115),
                                                  child: Text("रु ${widget.myBus["payable-amount"]}",style:TextStyle(
                                                    fontSize: 20,fontWeight: FontWeight.bold,

                                                  ),),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          // height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // refundActive = false;
                              // cancelActive = false;

                              cancelActive
                                  ? refundActive
                                      ? GestureDetector(
                                          onTap: () {
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible:
                                                  false, // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Cancel booking'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: const <Widget>[
                                                        Text(
                                                            "Do you want to cancel Ticket?"),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('No'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text('Yes'),
                                                      onPressed: () async {
                                                        // print(widget.myBus);
                                                        // print(widget.myBus.keys.toList());
                                                        // return;

                                                        //Todo: add cancel data to
                                                        ref
                                                            .child(
                                                                "project-backend/cancel-ticket")
                                                            .child(widget.myBus[
                                                                "ticket-id"])
                                                            .update({
                                                          "updated-at": DateTime
                                                                  .now()
                                                              .millisecondsSinceEpoch
                                                              .toString(),
                                                          "status":
                                                              "cancel-processing",
                                                          //Todo: done, cancel-processing
                                                          "payment-txn-no": widget
                                                                  .myBus[
                                                              "payment-txn-no"],
                                                          "ticket-id":
                                                              widget.myBus[
                                                                  "ticket-id"],
                                                          "journey-date": widget
                                                                  .myBus[
                                                              "journey-date"],
                                                          "note":
                                                              "Cancel by user (Refund $refundAmount % )",
                                                          "refund-per":
                                                              refundAmount
                                                                  .toString(),
                                                          "cancellation-per":
                                                              cancellationFees
                                                                  .toString(),
                                                        });

                                                        //Todo: add bus seat to bus side userId
                                                        for (var data in widget
                                                            .myBus[
                                                                "passenger-details"]
                                                            .toList()) {
                                                          print("dataaa");
                                                          print("vehicle/details/bus" +
                                                              widget.myBus[
                                                                      "bus-no"]
                                                                  .toString() +
                                                              "ticket" +
                                                              widget.myBus[
                                                                  "journey-date"] +
                                                              data["seat-id"]);

                                                          ref
                                                              .child(
                                                                  "project-backend/vehicle/details/bus")
                                                              .child(widget
                                                                  .myBus[
                                                                      "bus-no"]
                                                                  .toString())
                                                              .child("ticket")
                                                              .child(widget
                                                                      .myBus[
                                                                  "journey-date"])
                                                              .child(data[
                                                                  "seat-id"])
                                                              .remove();
                                                        }

                                                        //Todo: add bus seat data
                                                        ref
                                                            .child(
                                                                "project-backend/ticket")
                                                            .child(widget.myBus[
                                                                "journey-date"])
                                                            .child(widget.myBus[
                                                                "ticket-id"])
                                                            .update({
                                                          "updated-at": DateTime
                                                                  .now()
                                                              .millisecondsSinceEpoch
                                                              .toString(),
                                                          "status": "cancel",
                                                          //Todo: under-processing/active/
                                                        });

                                                        //Todo: add bus seat to user side
                                                        ref
                                                            .child(
                                                                "project-backend/account/user-data/user")
                                                            .child(uid)
                                                            .child("ticket")
                                                            .child(widget.myBus[
                                                                "journey-date"])
                                                            .child(widget.myBus[
                                                                "ticket-id"])
                                                            .update({
                                                          "updated-at": DateTime
                                                                  .now()
                                                              .millisecondsSinceEpoch
                                                              .toString(),
                                                          "status": "cancel",
                                                          //Todo: under-processing/active/
                                                        });

                                                        http.post(
                                                          Uri.parse(
                                                              "https://notice.fabyatra.com/seat-cancel.php"),
                                                          body: {
                                                            "date": widget
                                                                    .myBus[
                                                                "journey-date"],
                                                            "ticketId":
                                                                widget.myBus[
                                                                    "ticket-id"]
                                                          },
                                                        ).then((http.Response
                                                            response) {
                                                          if (response
                                                                  .statusCode ==
                                                              200) {}
                                                        });

                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home()));
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: 50 * heightF,
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                // color: Colors.white,
                                              color: Colors.red,
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.amber.shade800,),),
                                            child: Text(
                                              "CANCEL TICKET (Refund $refundAmount %)",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                        )
                                      : widget.myBus["view-status"] !=
                                              "complete"
                                          ? GestureDetector(
                                              onTap: () {
                                                showDialog<void>(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // user must tap button!
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      // <-- SEE HERE
                                                      title: const Text(
                                                          'Cancel booking'),
                                                      content:
                                                          const SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            Text(
                                                                'Do you want to cancel Ticket? (Refund Not Available)'),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child:
                                                              const Text('No'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child:
                                                              const Text('Yes'),
                                                          onPressed: () async {
                                                            //Todo: add cancel data to
                                                            ref
                                                                .child(
                                                                    "project-backend/cancel-ticket")
                                                                .child(widget
                                                                        .myBus[
                                                                    "ticket-id"])
                                                                .update({
                                                              "updated-at": DateTime
                                                                      .now()
                                                                  .millisecondsSinceEpoch
                                                                  .toString(),
                                                              "status":
                                                                  "cancel",
                                                              //Todo: done, cancel-processing
                                                              "payment-txn-no":
                                                                  widget.myBus[
                                                                      "payment-txn-no"],
                                                              "ticket-id": widget
                                                                      .myBus[
                                                                  "ticket-id"],
                                                              "journey-date":
                                                                  widget.myBus[
                                                                      "journey-date"],
                                                              "note":
                                                                  "Cancel by user - Refund Not Available"
                                                            });

                                                            //Todo: add bus seat to bus side userId
                                                            for (var data in widget
                                                                .myBus[
                                                                    "passenger-details"]
                                                                .toList()) {
                                                              print("dataaa");
                                                              print("vehicle/details/bus" +
                                                                  widget.myBus[
                                                                          "bus-no"]
                                                                      .toString() +
                                                                  "ticket" +
                                                                  widget.myBus[
                                                                      "journey-date"] +
                                                                  data[
                                                                      "seat-id"]);

                                                              ref
                                                                  .child(
                                                                      "project-backend/vehicle/details/bus")
                                                                  .child(widget
                                                                      .myBus[
                                                                          "bus-no"]
                                                                      .toString())
                                                                  .child(
                                                                      "ticket")
                                                                  .child(widget
                                                                          .myBus[
                                                                      "journey-date"])
                                                                  .child(data[
                                                                      "seat-id"])
                                                                  .remove();
                                                            }

                                                            //Todo: add bus seat data
                                                            ref
                                                                .child(
                                                                    "project-backend/ticket")
                                                                .child(widget
                                                                        .myBus[
                                                                    "journey-date"])
                                                                .child(widget
                                                                        .myBus[
                                                                    "ticket-id"])
                                                                .update({
                                                              "updated-at": DateTime
                                                                      .now()
                                                                  .millisecondsSinceEpoch
                                                                  .toString(),
                                                              "status":
                                                                  "cancel",
                                                              //Todo: under-processing/active/
                                                            });

                                                            //Todo: add bus seat to user side
                                                            ref
                                                                .child(
                                                                    "project-backend/account/user-data/user")
                                                                .child(uid)
                                                                .child("ticket")
                                                                .child(widget
                                                                        .myBus[
                                                                    "journey-date"])
                                                                .child(widget
                                                                        .myBus[
                                                                    "ticket-id"])
                                                                .update({
                                                              "updated-at": DateTime
                                                                      .now()
                                                                  .millisecondsSinceEpoch
                                                                  .toString(),
                                                              "status":
                                                                  "cancel",
                                                              //Todo: under-processing/active/
                                                            });

                                                            http.post(
                                                              Uri.parse(
                                                                  "https://notice.fabyatra.com/seat-cancel.php"),
                                                              body: {
                                                                "date": widget
                                                                        .myBus[
                                                                    "journey-date"],
                                                                "ticketId": widget
                                                                        .myBus[
                                                                    "ticket-id"]
                                                              },
                                                            ).then(
                                                                (http.Response
                                                                    response) {
                                                              if (response
                                                                      .statusCode ==
                                                                  200) {}
                                                            });

                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const Home()));
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                height: 50 * widthP,
                                                alignment: Alignment.center,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color:
                                                            Color(0xff7d2aff))),
                                                child: Text(
                                                  "CANCEL TICKET (Refund not available)",
                                                  style: TextStyle(
                                                      color: Color(0xff7d2aff),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            )
                                          : SizedBox()
                                  : SizedBox(),

                              // Container(
                              //         height: 50 * widthP,
                              //         alignment: Alignment.center,
                              //         width: double.infinity,
                              //         decoration: BoxDecoration(
                              //             color: Colors.white,
                              //             border:
                              //                 Border.all(color: Color(0xff7d2aff))),
                              //         child: Text(
                              //           "Cancel process not available...",
                              //           style: TextStyle(
                              //               color: Color(0xff7d2aff),
                              //               fontSize: 15,
                              //               fontWeight: FontWeight.w500),
                              //         ),
                              //       ),
                            ],
                          ),
                        ),

                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:240, ),
                      child: Container(
                        height: 40 * heightF,
                        width: 40 * widthP,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:240, left: 322),
                      child: Container(
                        height: 40 * heightF,
                        width: 40 * widthP,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:361,),
                      child: Container(
                        height: 40 * heightF,
                        width: 40 * widthP,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:361, left: 322),
                      child: Container(
                        height: 40 * heightF,
                        width: 40 * widthP,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    ));
  }

  List seatNo = [];
  List passengerList = [];

  Future<void> firstData() async {
    setState(() {
      showLoading = true;
    });

    print("widget.myBus");
    print(widget.myBus);
    print(widget.myBus.keys.toString());

    print("dataaa");
    print(widget.myBus["passenger-details"].toList());
    print(widget.myBus["passenger-details"].toList().runtimeType);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid')!;
    setState(() {});

    // /demo/app-data/cancellation-fees
    final counterSnapshot = await ref.child("app-data/cancellation-fees").get();

    if (counterSnapshot.value.runtimeType != Null) {
      setState(() {
        cancellationFees = double.parse(counterSnapshot.value.toString());
        print(cancellationFees);
        refundAmount = 100 - cancellationFees;
        print(refundAmount);
      });
    }

    for (var data in widget.myBus["passenger-details"].toList()) {
      print(data);
      setState(() {
        seatNo.add(data["number"]);
        passengerList.add({
          "number": data["number"],
          "name": data["name"],
          "gender": data["gender"],
          "age": data["age"],
        });
      });
    }

    String journeyDate = widget.myBus["journey-date"];
    String journeyBtime = widget.myBus["journey-btime"];

    int thisStampTime = DateTime(
            int.parse(journeyDate.toString().split("-")[0]),
            int.parse(journeyDate.toString().split("-")[1]),
            int.parse(journeyDate.split("-")[2]),
            int.parse(journeyBtime.split(":")[0]),
            int.parse(journeyBtime.split(":")[1]),
            0)
        .millisecondsSinceEpoch;

    String myStatus = widget.myBus["status"];

    if (myStatus == "active") {
      if ((thisStampTime - (2 * 60 * 60 * 1000)) < nowTimeStamp) {
        refundActive = false;
        cancelActive = true;
      } else if ((thisStampTime + (15 * 60 * 1000)) < nowTimeStamp) {
        refundActive = false;
        cancelActive = false;
      } else {
        refundActive = true;
        cancelActive = true;
      }
    } else {
      refundActive = false;
      cancelActive = false;
    }

    setState(() {
      showLoading = false;
    });
  }
}
