import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fabyatra/Controllers/auth.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/footer/footer.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/home/home_navigation.dart';
import 'package:fabyatra/view/splash.dart';

class SupportTeam extends StatefulWidget {
  const SupportTeam({super.key});

  @override
  State<SupportTeam> createState() => _SupportTeamState();
}

class _SupportTeamState extends State<SupportTeam> {

  DatabaseReference ref = FirebaseDatabase.instance.ref().child(
      "${GlobalVariable.appType}/project-backend/account/user-data/user");


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
            'Support  Team',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.amber.shade800,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [

                Container(
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
                                    color: Colors.amber.shade200,
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
                                                color: Colors.orange,
                                                child: ClipOval(
                                                  child: Icon(
                                                    CupertinoIcons.person_2_alt,
                                                    color: Colors.white,
                                                  ),
                                                )),
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
                                        "Customer Care",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Phone Number: +977-9817273222",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500, fontSize: 13),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Phone Number: +977-9845228174",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500, fontSize: 13),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Email: support@fabyatra.com",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500, fontSize: 13),
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


}
