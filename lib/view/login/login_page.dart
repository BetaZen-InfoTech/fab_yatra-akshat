import 'dart:async';

import 'package:fabyatra/view/login/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fabyatra/Controllers/auth.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/home/home_navigation.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // late User _user;

  // bool gAuth = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _formkey1 = GlobalKey<FormState>();
  int currentIndex = 0;
  int start = 30;
  bool wait = false;
  bool resend = false;
  bool edit = false;
  bool otpSend = false; // Todo: Code customize and otp add in same page...
  // String plus ="+";;
  String country = '+977';

  String number1 = "";
  String number2 = "";

  //Todo +977 => Nepal or +91 => India
  // Country country= Country(
  //     phoneCode: "977",
  //     countryCode: "NP",
  //     e164Sc: 0,
  //     geographic: true,
  //     level: 1,
  //     name: "Nepal",
  //     example: "Nepal",
  //     displayName: "Nepal",
  //     displayNameNoCountryCode: "NP",
  //     e164Key: "");
  @override
  void startTimer() {
    const onesec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onesec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          resend = true;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Future<void> initialize() async {
    bool authSuccess = await Auth.isLoggedIn();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    if (uid != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => const Home()));
    }

    // _auth.authStateChanges().listen((event) async {
    //   _user = event!;
    //   if (_user.uid != "") {
    //     setState(() {
    //       gAuth = true;
    //     });
    //
    //     DatabaseReference ref = FirebaseDatabase.instance
    //         .ref()
    //         .child("${GlobalVariable.appType}/project-backend")
    //         .child("account"); //Todo: change the type to Query
    //
    //     final counterSnapshot = await ref
    //         .child("user-data/user")
    //         .child(_auth.currentUser!.uid.toString())
    //         .child("phone")
    //         .get();
    //     if (counterSnapshot.value.runtimeType != Null) {
    //       String uid = await Auth.uid();
    //
    //       Auth.saveData(number2);
    //
    //       SharedPreferences prefs = await SharedPreferences.getInstance();
    //       prefs.setString('uid', uid);
    //
    //       Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(
    //           builder: (BuildContext context) => const Home(),
    //         ),
    //       );
    //     }
    //     else {
    //       String uid = await Auth.uid();
    //
    //       DatabaseReference ref = FirebaseDatabase.instance
    //           .ref()
    //           .child("${GlobalVariable.appType}/project-backend")
    //           .child("account"); //Todo: change the type to Query
    //
    //       final counterSnapshot =
    //           await ref.child("user-phone").child(number1.toString()).get();
    //       if (counterSnapshot.value.runtimeType == Null) {
    //         Auth.saveData(number2);
    //
    //         SharedPreferences prefs = await SharedPreferences.getInstance();
    //         prefs.setString('uid', uid);
    //
    //         Navigator.of(context).pushReplacement(MaterialPageRoute(
    //             builder: (BuildContext context) => const Home()));
    //       } else {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           const SnackBar(
    //             content: Text("Number already registered."),
    //           ),
    //         );
    //       }
    //     }
    //   }
    // });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  // _signInWithGoogle() async {
  //   final GoogleSignIn _googleSignIn = GoogleSignIn();
  //
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //         await _googleSignIn.signIn();
  //
  //     if (googleSignInAccount != null) {
  //       final GoogleSignInAuthentication googleSignInAuthentication =
  //           await googleSignInAccount.authentication;
  //
  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         idToken: googleSignInAuthentication.idToken,
  //         accessToken: googleSignInAuthentication.accessToken,
  //       );
  //
  //       await _auth.signInWithCredential(credential);
  //       // Navigator.pushNamed(context, "/home");
  //     }
  //   } catch (e) {
  //     // showToast(message: "some error occured $e");
  //     print(e);
  //   }
  // }

  Widget build(BuildContext context) {
    // Todo: Add this code to every page ⤵️⤵️⤵️⤵️⤵️
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);
    // Todo: Add this code to every page ⤴️⤴️⤴️⤴️⤴️

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            // Todo: Add this code to every page with Container ⤵️⤵️⤵️⤵️⤵️
            width: 411.42 * widthP, //Todo: widthP for all width
            // height: 876.57 * heightF, //Todo: heightP only for this line
            // Todo: Add this code to every page ⤴️⤴️⤴️⤴️⤴️

            child: Column(
              children: [
                SizedBox(
                  height: 20 * heightF,
                ), //Todo: heightF for all height
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        // height: 50,
                        ),
                    Image.asset(
                      "images/fabyatra_b.png",
                      height: 70 * heightF,
                      width: 300 * widthP,
                    ),
                  ],
                ),
                CarouselSlider(
                  items: [
                    //1st Image of Slider
                    for (int i = 1; i < 5; i++)
                      Container(
                        width: 411.42 * widthP, //Todo: widthP for all width
                        height: 870.57 * heightP,
                        margin: EdgeInsets.only(right: 20.0 * widthP),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage("images/loginscroll$i.jpg"),
                            fit: BoxFit.cover,
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
                    height: 500.0 * heightF,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 2,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 200),
                    viewportFraction: 0.9,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 1; i < 5; i++)
                      Row(
                        children: [
                          Container(
                            height: 8 * heightF,
                            width: 10 * widthP,
                            decoration: BoxDecoration(
                                color: currentIndex == (i - 1)
                                    ? const Color(0xff7d2aff)
                                    : Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: .5,
                                      blurRadius: 1,
                                      offset: Offset(2, 2))
                                ]),
                          ),
                          SizedBox(
                            width: 5 * widthP,
                          )
                        ],
                      ),
                  ],
                ),
                SizedBox(
                  height: 10 * heightF,
                ),

                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "LogIn with",
                      style: TextStyle(
                          color: Color(0xFF273671),
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    gestureDetectorButton()
                  ],
                ),

                // gAuth
                //     ? otpSend == false
                //         ? Container(
                //             height: 270 * heightF,
                //             padding: EdgeInsets.symmetric(
                //                 horizontal: 20 * widthP,
                //                 vertical: 20 * heightF),
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.only(
                //                 topRight: Radius.circular(15 * heightF),
                //                 topLeft: Radius.circular(15 * heightF),
                //               ),
                //               border: Border.all(
                //                 color: Colors.grey,
                //                 width: 1,
                //               ),
                //             ),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 SizedBox(
                //                   height: 5 * heightF,
                //                 ),
                //                 Text(
                //                   "Welcome to FabYatra",
                //                   style: TextStyle(
                //                       fontWeight: FontWeight.bold,
                //                       fontSize: widthP * 18 * widthP),
                //                 ), //Todo: widthP for all fontSize
                //                 SizedBox(
                //                   height: 10 * heightF,
                //                 ),
                //                 Text(
                //                   "We will send message to this mobile number",
                //                   style: TextStyle(
                //                       fontWeight: FontWeight.normal,
                //                       fontSize: widthP * 13 * heightF,
                //                       color: Colors.grey.shade500),
                //                 ),
                //                 SizedBox(
                //                   height: 15 * heightF,
                //                 ),
                //                 Form(
                //                   key: _formkey,
                //                   child: TextFormField(
                //                     controller: phoneController,
                //                     keyboardType: TextInputType.phone,
                //                     decoration: InputDecoration(
                //                         labelText: "Enter your mobile no.",
                //                         prefixIcon: Container(
                //                             padding: EdgeInsets.symmetric(
                //                                 horizontal: 10 * widthP),
                //                             height: 40 * heightF,
                //                             width: 85 * widthP,
                //                             child: DropdownButton<String>(
                //                               value: country,
                //                               items: <String>[
                //                                 '+977',
                //                                 '+91'
                //                               ].map<DropdownMenuItem<String>>(
                //                                   (String value) {
                //                                 return DropdownMenuItem<String>(
                //                                     value: value,
                //                                     child: Text(
                //                                       value,
                //                                       style: TextStyle(
                //                                           fontSize:
                //                                               widthP * 15),
                //                                     ));
                //                               }).toList(),
                //                               onChanged: (String? newValue) {
                //                                 setState(() {
                //                                   country = newValue!;
                //                                 });
                //                               },
                //                             )),
                //                         border: OutlineInputBorder(
                //                           borderRadius:
                //                               BorderRadius.circular(10),
                //                         )),
                //                     style: TextStyle(
                //                       color: Colors.grey.shade600,
                //                     ),
                //                     validator: (value) {
                //                       if (value!.length != 10) {
                //                         return "Invalid phone no.";
                //                       } else {
                //                         return null;
                //                       }
                //                     },
                //                   ),
                //                 ),
                //                 SizedBox(
                //                   height: 10 * heightF,
                //                 ),
                //                 SizedBox(
                //                   width: double.infinity,
                //                   child: ElevatedButton(
                //                     onPressed: () {
                //                       // print(country+phoneController.text);
                //                       if (_formkey.currentState!.validate()) {
                //                         // Assuming `Auth.sendOtp` is an asynchronous function, you should wait for its completion using `await`.
                //
                //                         number1 =
                //                             country + phoneController.text;
                //                         setState(() {
                //                           phoneController.text = "";
                //                           otpSend = true;
                //                           startTimer();
                //                         });
                //
                //                         // Auth.sendOtp(
                //                         //   countryCode: country,
                //                         //   phone: phoneController.text,
                //                         //   errorStep: () {
                //                         //     // Show a snackbar if there's an error during OTP sending.
                //                         //     ScaffoldMessenger.of(context)
                //                         //         .showSnackBar(
                //                         //       const SnackBar(
                //                         //         content: Text("OTP not sent"),
                //                         //       ),
                //                         //     );
                //                         //   },
                //                         //   nextStep: () {
                //                         //     setState(() {
                //                         //       otpSend = true;
                //                         //       startTimer();
                //                         //     });
                //                         //   },
                //                         // );
                //                       }
                //                     },
                //                     style: ElevatedButton.styleFrom(
                //                       backgroundColor: const Color(0xff7d2aff),
                //                       foregroundColor: Colors.white,
                //                     ),
                //                     child: const Text("PROCEED"),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           )
                //         : Container(
                //             height: 270 * heightF,
                //             padding: EdgeInsets.symmetric(
                //                 horizontal: 20 * widthP,
                //                 vertical: 20 * heightF),
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.only(
                //                 topRight: Radius.circular(15 * heightF),
                //                 topLeft: Radius.circular(15 * heightF),
                //               ),
                //               border: Border.all(
                //                 color: Colors.grey,
                //                 width: 1,
                //               ),
                //             ),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 SizedBox(
                //                   height: 5 * heightF,
                //                 ),
                //                 Text(
                //                   "Welcome to FabYatra",
                //                   style: TextStyle(
                //                       fontWeight: FontWeight.bold,
                //                       fontSize: widthP * 18 * widthP),
                //                 ),
                //                 //Todo: widthP for all fontSize
                //                 SizedBox(
                //                   height: 5 * heightF,
                //                 ),
                //                 Container(
                //                   height: 40 * heightF,
                //                   child: Row(
                //                     children: [
                //                       Text(
                //                         "Enter mobile number again",
                //                         style: TextStyle(
                //                             fontWeight: FontWeight.normal,
                //                             fontSize: widthP * 13 * heightF,
                //                             color: Colors.grey.shade500),
                //                       ),
                //                       TextButton(
                //                           onPressed: () {
                //                             setState(() {
                //                               otpSend = false;
                //                             });
                //                           },
                //                           child: Text(
                //                             "Edit number.",
                //                             style: TextStyle(
                //                                 color: Color(0xff7d2aff),
                //                                 decoration:
                //                                     TextDecoration.underline,
                //                                 decorationColor:
                //                                     Color(0xff7d2aff)),
                //                           ))
                //                     ],
                //                   ),
                //                 ),
                //
                //                 // Form(
                //                 //   key: _formkey1,
                //                 //   child: TextFormField(
                //                 //     keyboardType: TextInputType.number,
                //                 //     controller: otpController,
                //                 //     decoration: InputDecoration(
                //                 //       labelText: "Enter OTP.",
                //                 //       border: OutlineInputBorder(
                //                 //         borderRadius: BorderRadius.circular(10),
                //                 //       ),
                //                 //     ),
                //                 //     style: TextStyle(
                //                 //       color: Colors.grey.shade600,
                //                 //     ),
                //                 //     validator: (value) {
                //                 //       if (value!.length != 6) {
                //                 //         return "Invalid OTP";
                //                 //       } else {
                //                 //         return null;
                //                 //       }
                //                 //     },
                //                 //   ),
                //                 // ),
                //
                //                 Form(
                //                   key: _formkey,
                //                   child: TextFormField(
                //                     controller: phoneController,
                //                     keyboardType: TextInputType.phone,
                //                     decoration: InputDecoration(
                //                         labelText:
                //                             "Enter your mobile no again.",
                //                         prefixIcon: Container(
                //                             padding: EdgeInsets.symmetric(
                //                                 horizontal: 10 * widthP),
                //                             height: 40 * heightF,
                //                             width: 85 * widthP,
                //                             child: DropdownButton<String>(
                //                               value: country,
                //                               items: <String>[
                //                                 '+977',
                //                                 '+91'
                //                               ].map<DropdownMenuItem<String>>(
                //                                   (String value) {
                //                                 return DropdownMenuItem<String>(
                //                                     value: value,
                //                                     child: Text(
                //                                       value,
                //                                       style: TextStyle(
                //                                           fontSize:
                //                                               widthP * 15),
                //                                     ));
                //                               }).toList(),
                //                               onChanged: (String? newValue) {
                //                                 setState(() {
                //                                   country = newValue!;
                //                                 });
                //                               },
                //                             )),
                //                         border: OutlineInputBorder(
                //                           borderRadius:
                //                               BorderRadius.circular(10),
                //                         )),
                //                     style: TextStyle(
                //                       color: Colors.grey.shade600,
                //                     ),
                //                     validator: (value) {
                //                       if (value!.length != 10) {
                //                         return "Invalid phone no.";
                //                       } else {
                //                         return null;
                //                       }
                //                     },
                //                   ),
                //                 ),
                //
                //                 // Container(
                //                 //   height: 40 * heightF,
                //                 //   child: Row(
                //                 //     mainAxisAlignment: MainAxisAlignment.center,
                //                 //     children: [
                //                 //       Text("Didn't recieve OTP?  ",
                //                 //           style: TextStyle(
                //                 //               color: Colors.grey.shade700,
                //                 //               fontSize: widthP * 14)),
                //                 //       resend
                //                 //           ? SizedBox(
                //                 //         child: TextButton(
                //                 //           onPressed: () {
                //                 //             resend = false;
                //                 //             start = 60;
                //                 //             if (_formkey.currentState!
                //                 //                 .validate()) {
                //                 //               // Assuming `Auth.sendOtp` is an asynchronous function, you should wait for its completion using `await`.
                //                 //               Auth.sendOtp(
                //                 //                 countryCode: country,
                //                 //                 phone: phoneController.text,
                //                 //                 errorStep: () {
                //                 //                   // Show a snackbar if there's an error during OTP sending.
                //                 //                   ScaffoldMessenger.of(
                //                 //                       context)
                //                 //                       .showSnackBar(
                //                 //                     const SnackBar(
                //                 //                       content: Text(
                //                 //                           "OTP not sent"),
                //                 //                     ),
                //                 //                   );
                //                 //                 },
                //                 //                 nextStep: () {
                //                 //                   setState(() {
                //                 //                     otpSend = true;
                //                 //                     startTimer();
                //                 //                   });
                //                 //                 },
                //                 //               );
                //                 //             }
                //                 //             resend = false;
                //                 //           },
                //                 //           child: Text("Resend",
                //                 //               style: TextStyle(
                //                 //                   fontSize: widthP * 14,
                //                 //                   color: Color(0xff7d2aff))),
                //                 //         ),
                //                 //       )
                //                 //           : Text("resend in 00:$start ",
                //                 //           style: TextStyle(
                //                 //               color: Colors.grey.shade700,
                //                 //               fontSize: widthP * 14)),
                //                 //     ],
                //                 //   ),
                //                 // ),
                //
                //                 // Container(
                //                 //   height: 40 * heightF,
                //                 //   child: Row(
                //                 //     mainAxisAlignment: MainAxisAlignment.center,
                //                 //     children: [
                //                 //       Text("Both number not match or number already registered.",
                //                 //           style: TextStyle(
                //                 //               color: Colors.grey.shade700,
                //                 //               fontSize: widthP * 14)),
                //                 //     ],
                //                 //   ),
                //                 // ),
                //
                //                 SizedBox(
                //                   height: 5,
                //                 ),
                //                 SizedBox(
                //                     height: 35,
                //                     width: double.infinity,
                //                     child: TextButton(
                //                       onPressed: () async {
                //                         if (_formkey.currentState!.validate()) {
                //                           number2 = country +
                //                               phoneController.text.toString();
                //
                //                           if (number1 == number2) {
                //                             String uid = await Auth.uid();
                //
                //                             DatabaseReference ref = FirebaseDatabase
                //                                 .instance
                //                                 .ref()
                //                                 .child(
                //                                     "${GlobalVariable.appType}/project-backend")
                //                                 .child(
                //                                     "account"); //Todo: change the type to Query
                //
                //                             final counterSnapshot = await ref
                //                                 .child("user-phone")
                //                                 .child(number1.toString())
                //                                 .get();
                //                             if (counterSnapshot
                //                                     .value.runtimeType ==
                //                                 Null) {
                //                               await Auth.saveData(number2);
                //
                //                               SharedPreferences prefs =
                //                                   await SharedPreferences
                //                                       .getInstance();
                //                               prefs.setString('uid', uid);
                //
                //                               Navigator.of(context)
                //                                   .pushReplacement(
                //                                       MaterialPageRoute(
                //                                           builder: (BuildContext
                //                                                   context) =>
                //                                               const Home()));
                //                             } else {
                //                               ScaffoldMessenger.of(context)
                //                                   .showSnackBar(
                //                                 const SnackBar(
                //                                   content: Text(
                //                                       "Number already registered."),
                //                                 ),
                //                               );
                //                             }
                //                           } else {
                //                             ScaffoldMessenger.of(context)
                //                                 .showSnackBar(
                //                               const SnackBar(
                //                                 content: Text(
                //                                     "Both number not match"),
                //                               ),
                //                             );
                //                           }
                //
                //                           // Auth.loginWithOtp(otp: otpController.text)
                //                           //     .then((value) async {
                //                           //   String uid = await Auth.uid();
                //                           //
                //                           //   Auth.saveData(country +
                //                           //       phoneController.text.toString());
                //                           //
                //                           //   SharedPreferences prefs =
                //                           //   await SharedPreferences
                //                           //       .getInstance();
                //                           //   prefs.setString('uid', uid);
                //                           //
                //                           //   if (value == "Success") {
                //                           //     Navigator.of(context).pushReplacement(
                //                           //         MaterialPageRoute(
                //                           //             builder:
                //                           //                 (BuildContext context) =>
                //                           //             const Home()));
                //                           //   }
                //                           // });
                //                         } else {
                //                           ScaffoldMessenger.of(context)
                //                               .showSnackBar(
                //                             const SnackBar(
                //                               content:
                //                                   Text("Enter number again"),
                //                             ),
                //                           );
                //                         }
                //                       },
                //                       style: TextButton.styleFrom(
                //                         backgroundColor:
                //                             const Color(0xff7d2aff),
                //                         foregroundColor: Colors.white,
                //                       ),
                //                       child: const Text("LOGIN"),
                //                     )),
                //               ],
                //             ),
                //           )
                //     : Column(
                //       children: [
                //
                //         Center(
                //             child: SizedBox(
                //               height: 50,
                //               child: SignInButton(
                //                 Buttons.google,
                //                 text: "Sign up with Google",
                //                 onPressed: _signInWithGoogle,
                //               ),
                //             ),
                //           ),
                //
                //
                //         Text(
                //           "or LogIn with",
                //           style: TextStyle(
                //               color: Color(0xFF273671),
                //               fontSize: 22.0,
                //               fontWeight: FontWeight.w500),
                //         ),
                //         SizedBox(
                //           height: 30.0,
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             GestureDetector(
                //               onTap: (){
                //                 AuthMethods().signInWithGoogle(context);
                //               },
                //               child: Image.asset(
                //                 "images/google.png",
                //                 height: 45,
                //                 width: 45,
                //                 fit: BoxFit.cover,
                //               ),
                //             ),
                //             SizedBox(
                //               width: 30.0,
                //             ),
                //             GestureDetector(
                //               onTap: (){
                //                 AuthMethods().signInWithApple();
                //               },
                //               child: Image.asset(
                //                 "images/apple1.png",
                //                 height: 50,
                //                 width: 50,
                //                 fit: BoxFit.cover,
                //               ),
                //             )
                //           ],
                //         ),
                //
                //
                //         Center(
                //           child: SizedBox(
                //             height: 50,
                //             child: SignInButton(
                //               Buttons.google,
                //               text: "Sign up with Google",
                //               onPressed: _signInWithGoogle,
                //             ),
                //           ),
                //         )
                //       ],
                //     ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  StatelessWidget gestureDetectorButton() {
    if (kIsWeb) {
      return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        child: GestureDetector(
          onTap: () {
            AuthMethods().signInWithGoogle(context);
          },
          child: Image.asset(
            "images/googlesignin.png",
            height: 45,
            width: 250,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (Platform.isAndroid) {
      return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        child: GestureDetector(
          onTap: () {
            AuthMethods().signInWithGoogle(context);
          },
          child: Image.asset(
            "images/googlesignin.png",
            height: 45,
            width: 250,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (Platform.isIOS) {
      return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        child: GestureDetector(
          onTap: () {
            AuthMethods().signInWithApple(context);
          },
          child: Image.asset(
            "images/applesignin.png",
            height: 45,
            width: 250,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        child: GestureDetector(
          onTap: () {
            // AuthMethods().signInWithGoogle(context);
          },
          child: Image.asset(
            "images/googlesignin.png",
            height: 45,
            width: 250,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
