import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fabyatra/Controllers/auth.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/footer/footer.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/home/home_navigation.dart';
import 'package:fabyatra/view/splash.dart';

class Acc extends StatefulWidget {
  const Acc({super.key});

  @override
  State<Acc> createState() => _AccState();
}

class _AccState extends State<Acc> {

  final _formkey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  String country = '+977';

  int editname = 0;
  int editcontact = 0;
  int editemail = 0;

  final nameTextController = TextEditingController();
  final contactTextController = TextEditingController();
  final emailTextController = TextEditingController();

  DatabaseReference ref = FirebaseDatabase.instance.ref().child(
      "${GlobalVariable.appType}/project-backend/account/user-data/user");

  // /demo/project-backend/account/user-data/user
  String uid = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  final List<String> Amenitiesdetail = <String>[
    'Free Wifi',
    'LCD TV',
    '24X7 Security',
    'Free Toiletries',
    'Daily Housekeeping',
    '24-Hours Front Desk',
    'Mineral Water Bottel',
    'Tile/Marble Floor',
    'Wardrobe or Closet',
    'Clean Towels',
    'Clean Linen',
    'Toilet paper',
    'Wake-up Service',
    'DTH channels',
    'AC',
    'Lift',
    'Parking',
    'Conference Room',
    'Laundry Service',
    'Room Service',
    'Card Payment',
    'Smoking in Room',
    'Breakfast',
    'Fire NOC',
    'Fire Extinguishers',
    'Fire Alarm',
    'Security Guards',
    'Fire Exit',
  ];

  @override
  Widget build(BuildContext context) {
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);

    TextStyle defaultStyle =
        TextStyle(color: Colors.grey, fontSize: 20.0 * widthP);
    TextStyle linkStyle = const TextStyle(color: Colors.blue);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile & Settings',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.amber.shade800,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                CupertinoIcons.profile_circled,
                                size: 50,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(width: 10 * widthP),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  editname == 0
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              userData["name"] == ""
                                                  ? "FabYatra User"
                                                  : userData["name"],
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  editname = 1;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Container(
                                              width: 250 * widthP,
                                              // Set your desired width
                                              child: TextFormField(
                                                textAlign: TextAlign.left,
                                                controller: nameTextController,
                                                decoration: const InputDecoration(
                                                  labelText: "Enter Name",
                                                  labelStyle: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                ref.child(uid).update({
                                                  "name": nameTextController.text
                                                      .toString()
                                                      .trim(),
                                                  "updated-at": DateTime.now()
                                                      .millisecondsSinceEpoch
                                                      .toString(),
                                                });
                                                setState(() {
                                                  editname = 0;
                                                });
                                              },
                                              child: const Text("Save"),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),


                                  editcontact == 0
                                      ? Row(
                                          children: [
                                            Text(
                                              userData["phone"].runtimeType==Null
                                                  ?"Enter your number"
                                                  :userData["phone"],
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                // setState(() {
                                                //   editcontact = 1;
                                                // });


                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return StatefulBuilder(
                                                      builder: (context, setState) {

                                                        return AlertDialog(
                                                          // <-- SEE HERE
                                                          title: const Text('Add Phone Number'),
                                                          content:  Form(
                                                            key: _formkey,
                                                            child: TextFormField(
                                                              controller: phoneController,
                                                              keyboardType: TextInputType.phone,
                                                              decoration: InputDecoration(
                                                                  labelText:
                                                                  "Enter your mobile no again.",
                                                                  prefixIcon: Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: 10 * widthP),
                                                                      height: 40 * heightF,
                                                                      width: 85 * widthP,
                                                                      child: DropdownButton<String>(
                                                                        value: country,
                                                                        items: <String>[
                                                                          '+977',
                                                                          '+91'
                                                                        ].map<DropdownMenuItem<String>>(
                                                                                (String value) {
                                                                              return DropdownMenuItem<String>(
                                                                                  value: value,
                                                                                  child: Text(
                                                                                    value,
                                                                                    style: TextStyle(
                                                                                        fontSize:
                                                                                        widthP * 15),
                                                                                  ));
                                                                            }).toList(),
                                                                        onChanged: (String? newValue) {
                                                                          setState(() {
                                                                            country = newValue!;
                                                                          });
                                                                        },
                                                                      )),
                                                                  border: OutlineInputBorder(
                                                                    borderRadius:
                                                                    BorderRadius.circular(10),
                                                                  )),
                                                              style: TextStyle(
                                                                color: Colors.grey.shade600,
                                                              ),
                                                              validator: (value) {
                                                                if (value!.length != 10) {
                                                                  return "Invalid phone no.";
                                                                } else {
                                                                  return null;
                                                                }
                                                              },
                                                            ),
                                                          ),


                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: const Text('No'),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              style: TextButton.styleFrom(
                                                                  backgroundColor: Color(0xff7d2aff)),
                                                              child: Text(
                                                                "Yes",
                                                                style: TextStyle(color: Colors.white),
                                                              ),

                                                              onPressed: () async {






                                                                String fullNumber = country+phoneController.text.toString();
                                                                if(phoneController.text.length==10){

                                                                  String uid = await Auth.uid();

                                                                  DatabaseReference ref = FirebaseDatabase
                                                                      .instance
                                                                      .ref()
                                                                      .child(
                                                                      "${GlobalVariable.appType}/project-backend")
                                                                      .child(
                                                                      "account"); //Todo: change the type to Query

                                                                  final counterSnapshot =
                                                                  await ref
                                                                      .child("user-phone")
                                                                      .child(
                                                                      fullNumber)
                                                                      .get();
                                                                  if (counterSnapshot.value
                                                                      .runtimeType ==
                                                                      Null) {
                                                                    ref.child("user-data/user").child(uid).update({
                                                                      "phone": fullNumber
                                                                          .toString()
                                                                          .trim(),
                                                                      "updated-at": DateTime.now()
                                                                          .millisecondsSinceEpoch
                                                                          .toString(),
                                                                    });
                                                                    ref.child("phone-data/user-phone-connection").child(uid).update({
                                                                      "phone": "true",
                                                                    });
                                                                    ref
                                                                        .child("user-phone")
                                                                        .child(userData["phone"])
                                                                        .remove();

                                                                    ref.child("user-phone").update({
                                                                      fullNumber
                                                                          .toString(): uid,
                                                                    });

                                                                    ref.child("all-phone/user").push().update({
                                                                      fullNumber
                                                                          .toString(): uid,
                                                                    });

                                                                    Navigator.pop(context);

                                                                  }
                                                                  else {
                                                                    ScaffoldMessenger.of(context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        content:
                                                                        Text("Phone number already exits."),
                                                                      ),
                                                                    );
                                                                  }
                                                                }

                                                                else {
                                                                  ScaffoldMessenger.of(context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      content:
                                                                      Text("Enter 10 digit mobile number"),
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



                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Container(
                                              width: 250 * widthP,
                                              // Set your desired width
                                              child: TextFormField(
                                                textAlign: TextAlign.left,
                                                controller: contactTextController,
                                                keyboardType: TextInputType.phone,
                                                decoration: const InputDecoration(
                                                  labelText:
                                                      "Enter Number with country code",
                                                  labelStyle: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                if (contactTextController.text
                                                        .startsWith('+91') ||
                                                    contactTextController.text
                                                        .startsWith('+977')) {
                                                  String uid = await Auth.uid();

                                                  DatabaseReference ref = FirebaseDatabase
                                                      .instance
                                                      .ref()
                                                      .child(
                                                          "${GlobalVariable.appType}/project-backend")
                                                      .child(
                                                          "account"); //Todo: change the type to Query

                                                  final counterSnapshot = await ref
                                                      .child("user-phone")
                                                      .child(contactTextController
                                                          .text)
                                                      .get();
                                                  if (counterSnapshot
                                                          .value.runtimeType ==
                                                      Null) {
                                                    ref
                                                        .child("user-data/user")
                                                        .child(uid)
                                                        .update({
                                                      "phone":
                                                          contactTextController
                                                              .text
                                                              .toString()
                                                              .trim(),
                                                      "updated-at": DateTime.now()
                                                          .millisecondsSinceEpoch
                                                          .toString(),
                                                    });

                                                    ref
                                                        .child("user-phone")
                                                        .update({
                                                      contactTextController.text
                                                          .toString(): uid,
                                                    });

                                                    ref
                                                        .child("user-phone")
                                                        .child(userData["phone"])
                                                        .remove();

                                                    ref
                                                        .child("all-phone/user")
                                                        .push()
                                                        .update({
                                                      contactTextController.text
                                                          .toString(): uid,
                                                    });

                                                    setState(() {
                                                      editcontact = 0;
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "Phone number already exits."),
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content:Text("Enter 10 digit numbers"),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Text("Save"),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  editemail == 0
                                      ? Row(
                                          children: [
                                            SizedBox(
                                              width: 330 * widthP,
                                              child: Text(
                                                userData["email"] == ""
                                                    ? ""
                                                    : userData["email"],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                // overflow: TextOverflow.clip,
                                                // maxLines: 1,
                                                // softWrap: false,
                                              ),
                                            ),
                                            // IconButton(
                                            //   onPressed: () {
                                            //     setState(() {
                                            //       editemail = 1;
                                            //     });
                                            //   },
                                            //   icon: Icon(
                                            //     Icons.edit,
                                            //     color: Colors.grey.shade600,
                                            //   ),
                                            // ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Container(
                                              width: 250 * widthP,
                                              // Set your desired width
                                              child: TextFormField(
                                                textAlign: TextAlign.left,
                                                controller: emailTextController,
                                                decoration: const InputDecoration(
                                                  labelText: "Enter email",
                                                  labelStyle: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                ref.child(uid).update({
                                                  "email": emailTextController
                                                      .text
                                                      .toString()
                                                      .trim(),
                                                  "updated-at": DateTime.now()
                                                      .millisecondsSinceEpoch
                                                      .toString(),
                                                });
                                                setState(() {
                                                  editemail = 0;
                                                });
                                              },
                                              child: Text("Save"),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                            const Column(
                              children: [],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),

                // Card(
                //   elevation: 0,
                //   margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           'My Bookings',
                //           style: TextStyle(fontSize: 18,
                //             color: Colors.grey.shade600,),
                //         ),
                //       ),
                //       IconButton(
                //           onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,
                //         color: Colors.grey.shade600,)),
                //     ],
                //   ),
                // ),
                // Card(
                //   elevation: 0,
                //   margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           'Wallet',
                //           style: TextStyle(fontSize: 18,
                //             color: Colors.grey.shade600,),
                //         ),
                //       ),
                //       IconButton(
                //           onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,
                //         color: Colors.grey.shade600,)),
                //     ],
                //   ),
                // ),
                // Card(
                //   elevation: 0,
                //   margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           'Cards',
                //           style: TextStyle(fontSize: 18,
                //             color: Colors.grey.shade600,),
                //         ),
                //       ),
                //       IconButton(
                //           onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,
                //         color: Colors.grey.shade600,)),
                //     ],
                //   ),
                // ),
                // Card(
                //   elevation: 0,
                //   margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           'Co-Passenger (Bus)',
                //           style: TextStyle(fontSize: 18,
                //             color: Colors.grey.shade600,),
                //         ),
                //       ),
                //       IconButton(
                //           onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,
                //         color: Colors.grey.shade600,)),
                //     ],
                //   ),
                // ),
                // Card(
                //   elevation: 0,
                //   margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           'Trending Videos',
                //           style: TextStyle(fontSize: 18,
                //             color: Colors.grey.shade600,),
                //         ),
                //       ),
                //       IconButton(
                //           onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,
                //         color: Colors.grey.shade600,)),
                //     ],
                //   ),
                // ),
                // Card(
                //   elevation: 0,
                //   margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           'Refer & Earn',
                //           style: TextStyle(fontSize: 18,
                //             color: Colors.grey.shade600,),
                //         ),
                //       ),
                //       IconButton(
                //           onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,
                //         color: Colors.grey.shade600,)),
                //     ],
                //   ),
                // ),
                // Card(
                //   elevation: 0,
                //   margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           'Offers',
                //           style: TextStyle(fontSize: 18,
                //             color: Colors.grey.shade600,),
                //         ),
                //       ),
                //       IconButton(
                //           onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,
                //         color: Colors.grey.shade600,)),
                //     ],
                //   ),
                // ),
                // Card(
                //   elevation: 0,
                //   margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           'Help',
                //           style: TextStyle(fontSize: 18,
                //             color: Colors.grey.shade600,),
                //         ),
                //       ),
                //       IconButton(
                //           onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,
                //         color: Colors.grey.shade600,)),
                //     ],
                //   ),
                // ),
                // Card(
                //   elevation: 0,
                //   margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           'Call Support',
                //           style: TextStyle(fontSize: 18,
                //             color: Colors.grey.shade600,),
                //         ),
                //       ),
                //       IconButton(
                //           onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,
                //         color: Colors.grey.shade600,)),
                //     ],
                //   ),
                // ),
                // Card(
                //   elevation: 0,
                //   margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           'About Us',
                //           style: TextStyle(fontSize: 18,
                //             color: Colors.grey.shade600,),
                //         ),
                //       ),
                //       IconButton(
                //           onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,
                //         color: Colors.grey.shade600,)),
                //     ],
                //   ),
                // ),
                // Card(
                //   elevation: 0,
                //   margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           'Settings',
                //           style: TextStyle(fontSize: 18,
                //             color: Colors.grey.shade600,),
                //         ),
                //       ),
                //       IconButton(
                //           onPressed: () {}, icon: Icon(Icons.arrow_forward_ios,
                //         color: Colors.grey.shade600,)),
                //     ],
                //   ),
                // ),
                // Card(
                //   elevation: 0,
                //   margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(left: 10),
                //         child: Text(
                //           'Feedback',
                //           style: TextStyle(fontSize: 18,
                //             color: Colors.grey.shade600,),
                //         ),
                //       ),
                //       IconButton(
                //           onPressed: () {}, icon: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade600,)),
                //     ],
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.only(left: 5 * widthP, right: 5 * widthP),
                  child: Card(
                    elevation: 10 * widthP,
                    child: GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: uid));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Userid copied."),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 80 * heightF,
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'User Id: $uid',
                                style: TextStyle(
                                  fontSize: 18 * widthP,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                "Tap or Copy",
                                style: TextStyle(
                                  fontSize: 13 * heightF,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey.shade500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          Auth.logOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const SplashScreen()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 10, top: 20, bottom: 20),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.amber.shade800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                SizedBox(
                  height: 15 * heightF,
                ),
                GlobalFooter.footer(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map userData = {
    "email": "",
    "phone": "",
    "name": "",
  };

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid')!;
    setState(() {
      uid = prefs.getString('uid')!;
    });
    if (uid == "") {
      return;
    }
    print(uid);

    Stream<DatabaseEvent> stream1 = ref.child(uid).onValue;

    stream1.listen((DatabaseEvent event) {
      print(event.snapshot.value);
      setState(() {
        userData = event.snapshot.value as Map;
        emailTextController.text = userData["email"].toString().length > 6
            ? userData["email"].toString()
            : "";
        nameTextController.text = userData["name"];
        contactTextController.text = userData["phone"].runtimeType==Null
            ?"Enter your number"
            :userData["phone"];
      });
    });
  }
}
