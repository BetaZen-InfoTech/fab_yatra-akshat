import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/loading.dart';

import '../../utils/constant/dimensions.dart';

// import 'package:fabyatra/view/home.dart';
// import 'package:fabyatra/view/home_navigation.dart';

class SearchCity extends StatefulWidget {
  const SearchCity({super.key});

  // Search({this.app});
  // final FirebaseApp app;

  @override
  State<SearchCity> createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  String searchData = "";
  bool showLoading = false;

  //Search({super.key});
  final auth = FirebaseAuth.instance;
  final searchFilter = TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instance
      .ref()
      .child("${GlobalVariable.appType}/project-backend")
      .child("vehicle")
      .child("places"); //Todo: change the type to Query
  String to = "";

  @override
  Widget build(BuildContext context) {
    // Todo: Add this code to every page ⤵️⤵️⤵️⤵️⤵️
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);
    // Todo: Add this code to every page ⤴️⤴️⤴️⤴️⤴️

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
        title: Text(
          'Enter city',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.amber.shade800,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.amber.shade800,
                  )),
              child: TextField(
                onChanged: (String text) {
                  setState(() {
                    searchData = text.toString();
                  });

                  temp(); //Todo: Full List Read...
                },
                decoration: InputDecoration(
                    hintText: "   Search",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                    )),
              ),
            ),
            Expanded(
                child: FirebaseAnimatedList(
                    query: ref,
                    itemBuilder: (context, snapshot, animation, index) {
                      if (snapshot.key
                          .toString()
                          .toLowerCase()
                          .contains(searchData.toLowerCase())) {
                        return ListTile(
                            title: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              height: 55 * heightF,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 1,
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      size: 19,
                                      color: Colors.grey.shade600,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      snapshot.key.toString(),
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Todo: update with key

                            onTap: () {
                              Navigator.pop(context, snapshot.key.toString());
                            });
                      }
                      return const SizedBox(
                        height: 0,
                        width: 0,
                      );
                    }))
          ],
        ),
      ),
    ));
  }

  Future<void> temp() async {
    // Todo: Code for get data from firebase realtime database as map ...
    ref.onValue.listen((DatabaseEvent data) {
      // print(data.snapshot.value.runtimeType);
      // print(data.snapshot.value);
    });
  }
}
