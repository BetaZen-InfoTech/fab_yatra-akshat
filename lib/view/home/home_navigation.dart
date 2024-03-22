//Todo: change from clint
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fabyatra/view/extra/wallet.dart';
import 'package:fabyatra/view/search_bus_api/home.dart';
import 'package:fabyatra/view/support/support.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/view/account/account.dart';
import 'package:fabyatra/view/booking_history/booking.dart';

import '../search_bus/home.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  int myIndex = 0;

  List<Widget> widgetList = [

    const home2(),
    const booking(),
    const Wallet(),
    const SupportTeam(),
    const Acc(),
  ];

  @override
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

    return Scaffold(
      body: Center(
        child: widgetList[myIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(

          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          unselectedLabelStyle:TextStyle(
            color: Colors.black,
          ),
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          currentIndex: myIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Ionicons.ticket,
              ),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Ionicons.wallet,
              ),
              label: 'Wallet',
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.support_agent,
              ),
              label: 'Support',
            ),

            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.wallet,
            //     color: Colors.grey,
            //   ),
            //   activeIcon: Icon(
            //     Icons.wallet,
            //       color: Color(0xff7d2aff)
            //   ),
            //   label: 'Wallet',
            // ),
            BottomNavigationBarItem(
              icon: Icon(
                Ionicons.person,
              ),
              label: 'Profile',
            ),
          ]),
    );
  }
}