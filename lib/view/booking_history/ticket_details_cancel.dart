// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fabyatra/utils/constant/dimensions.dart';
// import 'package:fabyatra/utils/footer/footer.dart';
// import 'package:fabyatra/utils/services/global.dart';
// // import 'package:timezone/standalone.dart' as tz;
//
// class CancelTicketDetails extends StatefulWidget {
//   const CancelTicketDetails({
//     super.key,
//     required this.myBus,
//   });
//
//   final Map myBus;
//
//   @override
//   State<CancelTicketDetails> createState() => _CancelTicketDetailsState();
// }
//
// class _CancelTicketDetailsState extends State<CancelTicketDetails> {
//
//   String uid = "";
//   // final kathmandu =  tz.getLocation('Asia/Kathmandu');
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     firstData();
//
//     print("widget.myBus");
//     print(widget.myBus);
//     print(widget.myBus.keys.toList());
//   }
//
//   Map busDetails={};
//
//   DatabaseReference ref = FirebaseDatabase.instance
//       .ref()
//       .child("${GlobalVariable.appType}/project-backend"); //Todo: change the type to Query
//
//
//   @override
//   Widget build(BuildContext context) {
//     double widthP = Dimensions.myWidthThis(context);
//     double heightP = Dimensions.myHeightThis(context);
//     double heightF = Dimensions.myHeightFThis(context);
//     return SafeArea(child:
//     Scaffold(
//       appBar:  AppBar(
//         automaticallyImplyLeading: true,
//         leading: IconButton(
//           onPressed: (){
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back,
//             color: Colors.white,
//           ),
//         ),
//         title: Text('Ticket Details',
//           style: TextStyle(
//               color: Colors.white
//           )
//           ,),
//         backgroundColor: Color(0xff7d2aff),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: EdgeInsets.all(20),
//           child: Column(
//             children: [
//
//               Container(
//                 margin: const EdgeInsets.all(10),
//                 // height: 400,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   gradient: LinearGradient(
//                     colors: [Color(0xff7d2aff).withOpacity(0.6), Color(0xff7d2aff).withOpacity(0.3)], // Define your gradient colors
//                     begin: Alignment.centerLeft, // Define the start point of the gradient
//                     end: Alignment.centerRight, // Define the end point of the gradient
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       child: Column(
//
//                         children: [
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Text(
//                             "${widget.myBus["journey-from"]}",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.all(6),
//                             height: 25 ,
//                             child: VerticalDivider(
//                               color: Colors.black,
//                               thickness: 2,
//                             ),
//                           ),
//                           Text(
//                             "${widget.myBus["journey-to"]}",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       height: 3,
//                       decoration: BoxDecoration(
//                           color: Colors.grey.shade100
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       child:
//                       Column(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.all(10),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   "${widget.myBus["journey-btime"]}",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 20,
//                                 ),
//                                 Text(
//                                   "->",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 20,
//                                 ),
//                                 Text(
//                                   "${widget.myBus["journey-dbdtime"]}",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Container(
//                             margin: EdgeInsets.all(10),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   "date",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 20,
//                                 ),
//                                 Text(
//                                   "${DateFormat('EEEE d MMM yyyy').format(DateTime(int.parse(widget.myBus["journey-date"].toString().split("-")[0]), int.parse(widget.myBus["journey-date"].toString().split("-")[1]), int.parse(widget.myBus["journey-date"].split("-")[2]), 0, 0, 0))}",
//
//                                   style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.black
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Container(
//                             margin: EdgeInsets.all(10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "${widget.myBus["bus-details"]["company-name"]} - ${widget.myBus["bus-details"]["bus-type"]}",
//
//                                   style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.black
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                         ],
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white
//                       ),
//                       padding: EdgeInsets.symmetric(
//                       vertical: 10
//                       ),
//                       child:
//                       Column(
//                         children: [
//
//
//                           Divider(
//                             color: Colors.grey,
//                             thickness: 2,
//                           ),
//                           Container(
//                             padding: EdgeInsets.all(20),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Text("Ticket No",
//                                           style: TextStyle(
//                                               color: Colors.grey,
//                                               fontSize: 20
//                                           ),),
//                                       ),
//                                       Expanded(
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Flexible(
//                                                   child: Text("${widget.myBus["ticket-id"]}",
//                                                     style:
//                                                     TextStyle(
//                                                         color: Colors.black,
//                                                         fontWeight: FontWeight.bold,
//                                                         fontSize: 15
//                                                     ),),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Text("Operator Contact",
//                                           style: TextStyle(
//                                               color: Colors.grey,
//                                               fontSize: 20
//                                           ),),
//                                       ),
//                                       Expanded(
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Flexible(
//                                                   child: Text("${widget.myBus["bus-details"]["operator-contact-person-name"]} - ${widget.myBus["bus-details"]["operator-contact-person-number"]}",
//                                                     style:
//                                                     TextStyle(
//                                                         color: Colors.black,
//                                                         fontWeight: FontWeight.bold,
//                                                         fontSize: 15
//                                                     ),),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Text("Office Contact",
//                                           style: TextStyle(
//                                               color: Colors.grey,
//                                               fontSize: 20
//                                           ),),
//                                       ),
//                                       Expanded(
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Flexible(
//                                                   child: Text("${widget.myBus["bus-details"]["office-contact-person-name"]} - ${widget.myBus["bus-details"]["office-contact-person-number"]}",
//                                                     style:
//                                                     TextStyle(
//                                                         color: Colors.black,
//                                                         fontWeight: FontWeight.bold,
//                                                         fontSize: 15
//                                                     ),),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Divider(
//                             color: Colors.grey,
//                             thickness: 2,
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Text("Fare",
//                                     style: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 20
//                                     ),),
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Text(
//                                             "${widget.myBus["payable-amount"]}",
//                                             style:
//                                             TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 15
//                                             ),),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // GestureDetector(
//                     //   onTap: (){
//                     //       showDialog(
//                     //           context: context,
//                     //           builder: (BuildContext context) => AlertDialog(
//                     //             title: Container(
//                     //               child: Text(
//                     //                 "Do you want to cancel Ticket?",
//                     //                 style: TextStyle(
//                     //                     fontSize: 20,
//                     //                     fontWeight: FontWeight.bold),
//                     //               ),
//                     //             ),
//                     //             actions: [
//                     //               Expanded(
//                     //                 child: TextButton(
//                     //                   style: TextButton.styleFrom(
//                     //                       backgroundColor: Color(0xff7d2aff)),
//                     //                   child: Text(
//                     //                     "Yes",
//                     //                     style: TextStyle(color: Colors.white),
//                     //                   ),
//                     //                   onPressed: () {
//                     //
//                     //                   },
//                     //                 ),
//                     //               ),
//                     //               Expanded(
//                     //                 child: TextButton(
//                     //                     style: TextButton.styleFrom(
//                     //                         backgroundColor: Colors.grey),
//                     //                     child: Text(
//                     //                       'No',
//                     //                       style:
//                     //                       TextStyle(color: Colors.black),
//                     //                     ),
//                     //                     onPressed: () {
//                     //                       Navigator.pop(context);
//                     //                     }),
//                     //               ),
//                     //             ],
//                     //           )
//                     //       );
//                     //       },
//                     //   child: Container(
//                     //     height: 50*widthP,
//                     //     alignment: Alignment.center,
//                     //     width:double.infinity,
//                     //     decoration: BoxDecoration(
//                     //       color: Colors.white,
//                     //       border: Border.all(color: Color(0xff7d2aff))
//                     //     ),
//                     //     child: Text(
//                     //       "CANCEL TICKET",
//                     //       style: TextStyle(
//                     //         color: Color(0xff7d2aff),
//                     //         fontSize: 15,
//                     //         fontWeight: FontWeight.w500
//                     //       ),
//                     //     ),
//                     //   ),
//                     // )
//                   ],
//                 ),
//               ),
//
//               GlobalFooter.footer(context),
//
//               SizedBox(
//                 height: 25*heightF,
//               ),
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
//
//   Future<void> firstData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     uid = prefs.getString('uid')!;
//     setState(() {
//
//     });
//
//
//   }
// }
