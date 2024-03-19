import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/footer/footer.dart';
import 'package:fabyatra/view/search_bus/search_city.dart';
import 'package:fabyatra/view/search_bus/select_bus.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
// import 'package:timezone/standalone.dart' as tz;


class home1 extends StatefulWidget {
  const home1({super.key});

  @override
  State<home1> createState() => _home1State();
}

class _home1State extends State<home1> {
  String toCity = "";
  String fromCity = "";
  DateTime date= DateTime.now();
  bool _ispressedtod = true;
  bool _ispressedtom = false;
  bool _ispressedtd2 = false;
  bool _ispressedtd3 = false;
  bool _ispressedtd4 = false;
  bool _ispressedtd5 = false;
  bool _ispressedtd6 = false;
  bool showLoading = false;

  // final kathmandu =  tz.getLocation('Asia/Kathmandu');

  @override
  Widget build(BuildContext context) {
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);
    int currentIndex = 0;
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 5,),
                const Spacer(),
                Container(
                  height: 50 * heightF,
                  child: Image.asset("images/fabyatra_b.png"),
                ),
                const Spacer(),
                SizedBox(width: 5,),
                // Row(
                //   children: [
                //     ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //           elevation: 0, primary: Colors.white),
                //       onPressed: () {},
                //       child: Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.all(Radius.circular(10)),
                //           color: Colors.purple.shade200,
                //         ),
                //         child: Row(
                //           children: [
                //             Icon(
                //               Icons.currency_bitcoin,
                //               color: Colors.yellow,
                //             ),
                //             Text("0"),
                //             Icon(
                //               Icons.arrow_forward_ios,
                //               color: Color(0xff7d2aff),
                //             )
                //           ],
                //         ),
                //       ),
                //     ),
                //     IconButton(
                //       icon: Icon(
                //         Icons.person,
                //         color: Color(0xff7d2aff),
                //       ),
                //       tooltip: 'Comment Icon',
                //       onPressed: () {},
                //     ),
                //   ],
                // )
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin:
                      const EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(0),
                            child: InkWell(
                              onTap: () async {
                                fromCity = await Navigator.push(
                                  context,
                                  // Create the SelectionScreen in the next step.
                                  MaterialPageRoute(builder: (context) => SearchCity()),
                                );

                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(

                                    ),
                                child: Row(
                                  children: [
                                    Icon(Ionicons.paper_plane),
                                    SizedBox(
                                      width: 20 * widthP,
                                    ),
                                    Text(
                                      fromCity == "" ? "Leaving from" : fromCity,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: fromCity == ""
                                            ? Colors.grey.shade600
                                            : Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Divider(
                            height: 4,
                            thickness: 1,
                            indent: 55,
                            endIndent: 55,
                            color: Colors.grey,
                          ),

                          // Container(
                          //   height: 48 * heightF,
                          //   width: 48.0 * widthP,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.all(Radius.circular(10)),
                          //       border: Border.all(color: Colors.white)),
                          //   child: FittedBox(
                          //     child: FloatingActionButton(
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.all(Radius.circular(10)),
                          //       ),
                          //       backgroundColor: Colors.white,
                          //       elevation: 0,
                          //       onPressed: () {
                          //
                          //         String mmm = fromCity;
                          //         fromCity=toCity;
                          //         toCity=mmm;
                          //
                          //         setState(() {
                          //
                          //         });
                          //       },
                          //       child: Transform.rotate(
                          //         angle: 90 * math.pi / 180,
                          //         child: IconButton(
                          //           onPressed: () {
                          //             String mmm = fromCity;
                          //             fromCity=toCity;
                          //             toCity=mmm;
                          //
                          //             setState(() {
                          //
                          //             });
                          //           },
                          //           icon: Icon(
                          //             CupertinoIcons.arrow_right_arrow_left,
                          //             weight: 100,
                          //             size: 27,
                          //             color: Color(0xff7d2aff),
                          //           ),
                          //           style: IconButton.styleFrom(
                          //             side: BorderSide(
                          //               color: Colors.grey.shade600,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          Container(
                            padding: EdgeInsets.all(0),
                            child: InkWell(
                              onTap: () async {
                                toCity = await Navigator.push(
                                  context,
                                  // Create the SelectionScreen in the next step.
                                  MaterialPageRoute(builder: (context) => SearchCity()),
                                );

                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    ),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    SizedBox(
                                      width: 20 * widthP,
                                    ),
                                    Text(
                                      toCity == "" ? "Going to" : toCity,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: toCity == ""
                                            ? Colors.grey.shade600
                                            : Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),


                          Container(
                            padding: EdgeInsets.all(8),
                            child: InkWell(
                              onTap: () async {
                                DateTime? newdate=await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: DateTime.timestamp(),
                                  lastDate: DateTime(2100),
                                );
                                if(newdate==null)
                                  return ;
                                setState(() {
                                  date=newdate;
                                  _ispressedtod=false;
                                  _ispressedtom=false;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.date_range_rounded,
                                        color: Colors.grey.shade600,
                                      ),
                                      SizedBox(
                                        width: 14 * widthP,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Journey Date",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3 * heightF,
                                          ),
                                          Text(
                                            "${date.day}/${date.month}/${date.year}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15 * widthP),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        height: 40 * heightF,
                                        width: 75 * widthP,
                                        decoration: BoxDecoration(
                                            color: _ispressedtod?Colors.amber[800]:Colors.amber.withOpacity(0.6),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))
                                          // border: Border.all(
                                          //   color: Colors.grey.shade500,
                                          // ),
                                        ),
                                        child: TextButton(
                                          onPressed: () {

                                            setState(() {
                                              _ispressedtod=true;
                                              _ispressedtom=false;
                                              _ispressedtd2=false;
                                              _ispressedtd3=false;
                                              _ispressedtd4=false;
                                              _ispressedtd5=false;
                                              _ispressedtd6=false;
                                              date=DateTime.now();
                                            });
                                          },
                                          child: Text(
                                            "Today",
                                            style: TextStyle(
                                                fontSize: 14 * widthP,
                                                color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15 * widthP,
                                      ),
                                      Container(
                                        height: 40 * heightF,
                                        width: 95 * widthP,
                                        decoration: BoxDecoration(
                                            color: _ispressedtom?Colors.amber[800]:Colors.amber.withOpacity(0.6),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))
                                          // border: Border.all(
                                          //   color: Colors.grey.shade500,
                                          // ),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            _ispressedtod=false;
                                            _ispressedtom=true;
                                            _ispressedtd2=false;
                                            _ispressedtd3=false;
                                            _ispressedtd4=false;
                                            _ispressedtd5=false;
                                            _ispressedtd6=false;
                                            date=DateTime.now().add(Duration(days: 1));
                                            setState(() {

                                            });
                                          },
                                          child: Text(
                                            "Tomorrow",
                                            style: TextStyle(
                                              fontSize: 14 * widthP,
                                                color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),

                                Text("Quick Dates",style: TextStyle(fontWeight: FontWeight.w500)),

                                SizedBox(
                                  height: 10,
                                ),


                                Row(
                                  children: [
                                    Card(
                                      elevation:0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        //set border radius more than 50% of height and width to make circle
                                      ),
                                      child: Container(
                                        height:80 *heightF,
                                        width: 60 *widthP,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            // _ispressedtod=false;
                                            // _ispressedtom=false;
                                            // date=DateTime.now().add(Duration(days: 2));
                                            setState(() {
                                              _ispressedtod=false;
                                              _ispressedtom=false;
                                              _ispressedtd2=true;
                                              _ispressedtd3=false;
                                              _ispressedtd4=false;
                                              _ispressedtd5=false;
                                              _ispressedtd6=false;
                                              date=DateTime.now().add(Duration(days: 2));
                                            });//
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:_ispressedtd2?Colors.amber[800]:Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    DateFormat('d').format(DateTime.now().add(Duration(days: 2))).toString(),
                                                    style: TextStyle(
                                                      fontSize: 17 * widthP,
                                                      color: _ispressedtd2?Colors.white:Colors.grey.shade800,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                DateFormat('EEE').format(DateTime.now().add(Duration(days: 2))).toString(),
                                                style: TextStyle(
                                                  fontSize: 14 * widthP,
                                                  fontWeight: FontWeight.w900,
                                                  color:Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),

                                    Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        //set border radius more than 50% of height and width to make circle
                                      ),
                                      child: Container(
                                        height:80 *heightF,
                                        width: 60 *widthP,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _ispressedtod=false;
                                              _ispressedtom=false;
                                              _ispressedtd2=false;
                                              _ispressedtd3=true;
                                              _ispressedtd4=false;
                                              _ispressedtd5=false;
                                              _ispressedtd6=false;
                                              date=DateTime.now().add(Duration(days: 3));
                                            });//
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:_ispressedtd3?Colors.amber[800]:Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    DateFormat('d').format(DateTime.now().add(Duration(days: 3))).toString(),
                                                    style: TextStyle(
                                                      fontSize: 17 * widthP,
                                                      color: _ispressedtd3?Colors.white:Colors.grey.shade800,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                DateFormat('EEE').format(DateTime.now().add(Duration(days: 3))).toString(),
                                                style: TextStyle(
                                                  fontSize: 14 * widthP,
                                                  fontWeight: FontWeight.w900,
                                                  color:Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),

                                    Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        //set border radius more than 50% of height and width to make circle
                                      ),
                                      child: Container(
                                        height:80 *heightF,
                                        width: 60 *widthP,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            // _ispressedtod=false;
                                            // _ispressedtom=false;
                                            // date=DateTime.now().add(Duration(days: 2));
                                            setState(() {
                                              _ispressedtod=false;
                                              _ispressedtom=false;
                                              _ispressedtd2=false;
                                              _ispressedtd3=false;
                                              _ispressedtd4=true;
                                              _ispressedtd5=false;
                                              _ispressedtd6=false;
                                              date=DateTime.now().add(Duration(days: 4));
                                            });//
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:_ispressedtd4?Colors.amber[800]:Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    DateFormat('d').format(DateTime.now().add(Duration(days: 4))).toString(),
                                                    style: TextStyle(
                                                      fontSize: 17* widthP,
                                                      color:_ispressedtd4?Colors.white:Colors.grey.shade800,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                DateFormat('EEE').format(DateTime.now().add(Duration(days: 4))).toString(),
                                                style: TextStyle(
                                                  fontSize: 14* widthP,
                                                  fontWeight: FontWeight.w900,
                                                  color:Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),

                                    Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        //set border radius more than 50% of height and width to make circle
                                      ),
                                      child: Container(
                                        height:80 *heightF,
                                        width: 60 *widthP,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            // _ispressedtod=false;
                                            // _ispressedtom=false;
                                            // date=DateTime.now().add(Duration(days: 2));
                                            setState(() {
                                              _ispressedtod=false;
                                              _ispressedtom=false;
                                              _ispressedtd2=false;
                                              _ispressedtd3=false;
                                              _ispressedtd4=false;
                                              _ispressedtd5=true;
                                              _ispressedtd6=false;
                                              date=DateTime.now().add(Duration(days: 5));
                                            });//
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:_ispressedtd5?Colors.amber[800]:Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    DateFormat('d').format(DateTime.now().add(Duration(days: 5))).toString(),
                                                    style: TextStyle(
                                                      fontSize: 17* widthP,
                                                      color:  _ispressedtd5?Colors.white:Colors.grey.shade800,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                DateFormat('EEE').format(DateTime.now().add(Duration(days: 5))).toString(),
                                                style: TextStyle(
                                                  fontSize: 14* widthP,
                                                  fontWeight: FontWeight.w900,
                                                  color:Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),

                                    Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        //set border radius more than 50% of height and width to make circle
                                      ),
                                      child: Container(
                                        height:80 *heightF,
                                        width: 60 *widthP,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            // _ispressedtod=false;
                                            // _ispressedtom=false;
                                            // date=DateTime.now().add(Duration(days: 2));
                                            setState(() {
                                              _ispressedtod=false;
                                              _ispressedtom=false;
                                              _ispressedtd2=false;
                                              _ispressedtd3=false;
                                              _ispressedtd4=false;
                                              _ispressedtd5=false;
                                              _ispressedtd6=true;
                                              date=DateTime.now().add(Duration(days: 6));
                                            });//
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:_ispressedtd6?Colors.amber[800]:Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4),
                                                  child: Text(
                                                    DateFormat('d').format(DateTime.now().add(Duration(days: 6))).toString(),
                                                    style: TextStyle(
                                                      fontSize: 17* widthP,
                                                      color: _ispressedtd6?Colors.white:Colors.grey.shade800,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                DateFormat('EEE').format(DateTime.now().add(Duration(days: 6))).toString(),
                                                style: TextStyle(
                                                  fontSize: 14* widthP,
                                                  fontWeight: FontWeight.w900,
                                                  color:Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),


                          SizedBox(
                            height: 10 * heightF,
                          ),

                          Card(
                            elevation: 10,
                            child: Container(
                              height: 45 * heightF,
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.amber[800],
                                  borderRadius: BorderRadius.all(Radius.circular(8))
                                // border: Border.all(
                                //   color: Colors.grey.shade500,
                                // ),
                              ),

                              child: TextButton(
                                onPressed: () async {
                                  if(toCity!="" && fromCity!="") {


                                    String selectTime = "${date.year}-${date.month}-${date.day}";

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SelectBus(
                                                from: fromCity,
                                                to: toCity,
                                                date: selectTime,
                                            ),
                                      ),
                                    );
                                  }
                                  else
                                    SnackBar(
                                      content: Text(
                                          "Enter Cities to Search"),
                                    );
                                },
                                child: Text(
                                  "Find buses",
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    //////inter changing is being done here
                    Padding(
                      padding:  EdgeInsets.fromLTRB(290, 45, 20, 0),
                      child: Container(
                        height: 48 * heightF,
                        width: 48.0 * widthP,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.white)),
                        child: FittedBox(
                          child: FloatingActionButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 0,
                            onPressed: () {

                              String mmm = fromCity;
                              fromCity=toCity;
                              toCity=mmm;

                              setState(() {

                              });
                            },
                            child: Transform.rotate(
                              angle: 90 * math.pi / 180,
                              child: IconButton(
                                onPressed: () {
                                  String mmm = fromCity;
                                  fromCity=toCity;
                                  toCity=mmm;

                                  setState(() {

                                  });
                                },
                                icon: Icon(
                                  CupertinoIcons.arrow_right_arrow_left,
                                  weight: 100,
                                  size: 40,
                                  color: Colors.amber[800],
                                ),
                                style: IconButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(
                  height: 10 * heightF,
                ),
                CarouselSlider(
                  items: [
                    //1st Image of Slider
                    for (int i = 1; i < 3; i++) //Todo: change from clint
                      Container(
                        height: 250 * heightF,
                        margin: EdgeInsets.only(right: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage("images/banner$i.jpg"),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                  ],

                  //Slider Container properties
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                      fontSize:  widthP *(index);
                      fontSize:  widthP *(currentIndex);
                    },
                    height: 200.0 * heightF,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 2,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 200),
                    viewportFraction: 0.9,
                  ),
                ),
                SizedBox(
                  height: 15 * heightF,
                ),


                SizedBox(
                  height: 15 * heightF,
                ),

                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.amber.shade600, Colors.white]),
                  ),
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 360 * heightF,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 14 * heightF,
                        ),
                        Text(
                          "FabYatra Gaurantee",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20 * widthP),
                        ),
                        SizedBox(
                          height: 11 * heightF,
                        ),
                        CarouselSlider(
                          items: [
                            //1st Image of Slider
                            for (int i = 1; i < 3; i++)
                              InkWell(
                                child: Container(
                                  height: 400 * heightF,
                                  margin: EdgeInsets.only(right: 20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: AssetImage("images/homec2$i.webp"),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                          ],

                          //Slider Container properties
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            height: 300.0 * heightF,
                            enlargeCenterPage: false,
                            autoPlay: true,
                            aspectRatio: 16 / 2,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration: Duration(milliseconds: 200),
                            viewportFraction: 0.9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 15 * heightF,
                ),
                GlobalFooter.footer(context),

              ],
            ),
          ),
        ),
    );
  }
}
