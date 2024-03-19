import 'package:fabyatra/Controllers/auth.dart';
import 'package:fabyatra/utils/footer/footer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fabyatra/utils/constant/index.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/loading.dart';
import 'package:fabyatra/view/search_bus/bdpoint.dart';
import 'package:fabyatra/view/search_bus/image.dart';
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
    getData1();
  }

  DatabaseReference ref = FirebaseDatabase.instance
      .ref()
      .child("${GlobalVariable.appType}/project-backend")
      .child("vehicle");

  List busData = [];

  List fromList = [];
  List toList = [];
  Map commonList = {};
  String uid = "";

  // var kathmandu = tz.getLocation('Asia/Kathmandu');

  Future<void> getData1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid')!;

    setState(() {
      showLoading = true;
    });

    Stream<DatabaseEvent> stream1 =
        ref.child("places").child(widget.from).onValue;

    stream1.listen((DatabaseEvent event1) {
      Map fromMap = event1.snapshot.value as Map;
      // print(fromMap);
      // print("fromMap");
      fromList = fromMap.keys.toList();
      Stream<DatabaseEvent> stream2 =
          ref.child("places").child(widget.to).onValue;
      stream2.listen((DatabaseEvent event2) {
        Map toMap = event2.snapshot.value as Map;
        toList = toMap.keys.toList();

        // print(fromList);
        // print(fromList.runtimeType);
        for (final e1 in fromList) {
          for (final e2 in toList) {
            if (e1 == e2) {
              // var key = toMap.keys.firstWhere((k) => toMap[k] == e1, orElse: () => null);

              commonList[e1] = toMap[e1];
            }
          }
        }

        setState(() {});
        getData2();
      });
    });
    setState(() {
      showLoading = false;
    });
  }

  Future<void> getData2() async {
    busData.clear();
    print("myBusData");
    print(commonList.values);

    List checkBusId = [];

    print("commonList.values");
    print(commonList);
    print(commonList.keys);
    print(commonList.values);

    // commonList.forEach((key, value) async {

    for (MapEntry<dynamic, dynamic> myData in commonList.entries) {
      String keyS = myData.key.toString(); // Todo: route id
      String valueS = myData.value.toString(); // Todo: bus id
      // String mycommonid = value.toString();

      print("valueSlll");
      print(valueS);
      print(keyS);

      // if (!checkBusId.contains(valueS)) {
      checkBusId.add(valueS);

      final counterSnapshot =
          await ref.child("details").child("bus").child(valueS).get();

      if (counterSnapshot.value.runtimeType != Null) {
        Map myBusData = counterSnapshot.value as Map;
        print(myBusData);
        print(valueS);

        if (myBusData["status"] == "active") {
          myBusData["this-route-id"] = keyS;

          myBusData["all-amenities"] = [];

          // if (myBusData["amenities"] != null) {
          //   Map amenities = myBusData["amenities"] as Map;
          //   myBusData["all-amenities"] = amenities.keys.toList();
          // }

          if (myBusData["amenities"] != null) {
            List amenities = myBusData["amenities"] as List;
            myBusData["all-amenities"] = amenities;
          }

          List holidayList = [];

          if (myBusData["holiday"] != null) {
            Map holidays = myBusData["holiday"] as Map;
            holidayList = holidays.values.toList();
          }

          print("holidayList");
          print(holidayList);
          print(holidayList);
          print(holidayList);
          print(holidayList);

          myBusData["all-images"] = [];

          if (myBusData["images"] != null) {
            Map images = myBusData["images"] as Map;
            myBusData["all-images"] = images.values.toList();
          }

          print("object");
          print(myBusData["route"][myBusData["this-route-id"]]);
          try {
            print(
                myBusData["route"][myBusData["this-route-id"]]["pickup-city"]);
            print(myBusData["route"][myBusData["this-route-id"]]["drop-city"]);
          } catch (error) {
            print(error);
          }
          // print(object);
          // print(object);
          // print(object);
          // print(object);
          // print(object);
          // print(object);
          // print(object);
          // print(object);
          if (myBusData["route"][myBusData["this-route-id"]] != null) {
            if (myBusData["route"][myBusData["this-route-id"]]["pickup-city"] !=
                    null &&
                myBusData["route"][myBusData["this-route-id"]]["drop-city"] !=
                    null) {
              if (myBusData["route"][myBusData["this-route-id"]]["pickup-city"]
                          .toString()
                          .toLowerCase() ==
                      widget.from.toString().toLowerCase() &&
                  myBusData["route"][myBusData["this-route-id"]]["drop-city"]
                          .toString()
                          .toLowerCase() ==
                      widget.to.toString().toLowerCase()) {
                if (!holidayList.contains(widget.date)) {
                  print("myBusDatamyBusData");
                  print(myBusData);
                  setState(() {
                    busData.add(myBusData);
                  });
                }
              }
            }
          }
        }
      }
      // }
    }

    setState(() {
      print(busData);
      showLoading = false;
    });
    // Navigator.pop(context);
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
        body: showLoading == true
            ? Container(child: LottieDialog())
            : SingleChildScrollView(
                child: Container(
                  color: Colors.grey.shade200,
                  child: Column(
                    children: [
                      if(busData.isNotEmpty)...[
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          bus["source"].toString(),
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
                                          bus["destinations"].toString(),
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
                                      "${bus["company-name"].toString()} - ${bus["bus-type"].toString()}",
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
                                          // Spacer(),
                                          SizedBox(
                                            height: 25 * heightF,
                                            width: 60 * widthP,
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "₹. ${int.parse(bus["route"][bus["this-route-id"]]["seater-price"].toString())}",
                                                    style: TextStyle(
                                                      fontSize: 16 * widthP,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    height: 2 * heightF,
                                                    width: 50 * widthP,
                                                    color: Colors.red.shade300,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5 * widthP,
                                          ),
                                          Icon(
                                            Icons.currency_rupee,
                                            size: 15 * widthP,
                                          ),
                                          Text(
                                            "${int.parse(bus["route"][bus["this-route-id"]]["seater-price"].toString()) - int.parse(bus["route"][bus["this-route-id"]]["seater-offer-price"].toString())}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19 * widthP),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 25 * heightF,
                                        width: 80 * widthP,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                height: 20 * heightF,
                                                width: 70 * widthP,
                                                color: Colors.green,
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "OFF ₹ ${bus["route"][bus["this-route-id"]]["seater-offer-price"].toString()}",
                                                style: TextStyle(
                                                  fontSize: 12 * widthP,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5 * heightF,
                                      ),
                                      SizedBox(
                                        height: 5 * heightF,
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          DatabaseReference ref1 = FirebaseDatabase
                                              .instance
                                              .ref()
                                              .child(
                                                  "${GlobalVariable.appType}/project-backend")
                                              .child("account");

                                          final counterSnapshot = await ref1
                                              .child(
                                                  "phone-data/user-phone-connection")
                                              .child(uid.toString())
                                              .child("phone")
                                              .get();
                                          if (counterSnapshot.value == "true") {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => bdPoint(
                                                  from: widget.from,
                                                  to: widget.to,
                                                  date: widget.date,
                                                  itemId:
                                                      bus["item-id"].toString(),
                                                  routeId: bus["this-route-id"]
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Please add your phone number from account."),
                                              ),
                                            );

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return AlertDialog(
                                                      // <-- SEE HERE
                                                      title: const Text(
                                                          'Add Phone Number'),
                                                      content: Form(
                                                        key: _formkey,
                                                        child: TextFormField(
                                                          controller:
                                                              phoneController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .phone,
                                                          decoration: InputDecoration(
                                                              labelText: "Enter your mobile no again.",
                                                              prefixIcon: Container(
                                                                  padding: EdgeInsets.symmetric(horizontal: 10 * widthP),
                                                                  height: 40 * heightF,
                                                                  width: 85 * widthP,
                                                                  child: DropdownButton<String>(
                                                                    value:
                                                                        country,
                                                                    items: <String>[
                                                                      '+977',
                                                                      '+91'
                                                                    ].map<
                                                                        DropdownMenuItem<
                                                                            String>>((String
                                                                        value) {
                                                                      return DropdownMenuItem<
                                                                              String>(
                                                                          value:
                                                                              value,
                                                                          child:
                                                                              Text(
                                                                            value,
                                                                            style:
                                                                                TextStyle(fontSize: widthP * 15),
                                                                          ));
                                                                    }).toList(),
                                                                    onChanged:
                                                                        (String?
                                                                            newValue) {
                                                                      setState(
                                                                          () {
                                                                        country =
                                                                            newValue!;
                                                                      });
                                                                    },
                                                                  )),
                                                              border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              )),
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade600,
                                                          ),
                                                          validator: (value) {
                                                            if (value!.length !=
                                                                10) {
                                                              return "Invalid phone no.";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
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
                                                          style: TextButton.styleFrom(
                                                              backgroundColor:
                                                                  Color(
                                                                      0xff7d2aff)),
                                                          child: Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onPressed: () async {
                                                            String fullNumber =
                                                                country +
                                                                    phoneController
                                                                        .text
                                                                        .toString();

                                                            if (phoneController
                                                                    .text
                                                                    .length ==
                                                                10) {
                                                              String uid =
                                                                  await Auth
                                                                      .uid();

                                                              DatabaseReference
                                                                  ref =
                                                                  FirebaseDatabase
                                                                      .instance
                                                                      .ref()
                                                                      .child(
                                                                          "${GlobalVariable.appType}/project-backend")
                                                                      .child(
                                                                          "account"); //Todo: change the type to Query

                                                              final counterSnapshot =
                                                                  await ref
                                                                      .child(
                                                                          "user-phone")
                                                                      .child(
                                                                          fullNumber)
                                                                      .get();
                                                              if (counterSnapshot
                                                                      .value
                                                                      .runtimeType ==
                                                                  Null) {
                                                                ref
                                                                    .child(
                                                                        "user-data/user")
                                                                    .child(uid)
                                                                    .update({
                                                                  "phone": fullNumber
                                                                      .toString()
                                                                      .trim(),
                                                                  "updated-at": DateTime
                                                                          .now()
                                                                      .millisecondsSinceEpoch
                                                                      .toString(),
                                                                });
                                                                ref
                                                                    .child(
                                                                        "phone-data/user-phone-connection")
                                                                    .child(uid)
                                                                    .update({
                                                                  "phone":
                                                                      "true",
                                                                });
                                                                ref
                                                                    .child(
                                                                        "user-phone")
                                                                    .update({
                                                                  fullNumber
                                                                          .toString():
                                                                      uid,
                                                                });

                                                                ref
                                                                    .child(
                                                                        "all-phone/user")
                                                                    .push()
                                                                    .update({
                                                                  fullNumber
                                                                          .toString():
                                                                      uid,
                                                                });

                                                                Navigator.pop(
                                                                    context);
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                        "Phone number already exits."),
                                                                  ),
                                                                );
                                                              }
                                                            } else {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                      "Enter 10 digit numbers"),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          }
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
                                          backgroundColor:
                                              Colors.amber.shade800,
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10 * widthP),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: Icon(Icons
                                                                .cancel_outlined)),
                                                      ),
                                                      for (String value in bus[
                                                          "all-amenities"]) ...[
                                                        ListTile(
                                                          subtitle: Text(
                                                              value.toString()),
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
                                        Map imageMap = bus["images"] as Map;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Images(imageMap: imageMap),
                                          ),
                                        );
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
