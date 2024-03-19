import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fabyatra/utils/services/global.dart';

import '../utils/constant/dimensions.dart';

class RouteDataPoints extends StatefulWidget {
  const RouteDataPoints({super.key, required this.itemId, required this.routeId});

  final String itemId;
  final String routeId;

  @override
  State<RouteDataPoints> createState() => _RouteDataPointsState();
}

class _RouteDataPointsState extends State<RouteDataPoints> {

  bool isPressedb= true;
  bool isPressedd= false;

  DatabaseReference  ref = FirebaseDatabase.instance.ref().child("${GlobalVariable.appType}/project-backend").child("vehicle").child("details").child("bus");    //Todo: change the type to Query

  @override
  Widget build(BuildContext context) {

    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    "Route POINTS Data",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: 5,),
                  // Text(
                  //   "07 October, Saturday",
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 15
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: TextButton(onPressed: (){
                    setState((){
                      isPressedb= true;
                      isPressedd=false;
                    });
                  },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Boarding Point",
                        style: TextStyle(
                            color: isPressedb?Colors.black:Colors.grey.shade400,
                            fontWeight: isPressedb?FontWeight.bold:FontWeight.normal,
                            fontSize: 20
                        ),),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: TextButton(onPressed: (){
                    setState((){
                      isPressedd= true;
                      isPressedb=false;
                    });
                  },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Drop Point",
                        style: TextStyle(
                            color: isPressedd?Colors.black:Colors.grey.shade400,
                            fontWeight: isPressedd?FontWeight.bold:FontWeight.normal,
                            fontSize: 20
                        ),),
                    ),
                  ),
                ),
              ],
            ),

            Visibility(
                visible: isPressedb,
                child: Expanded(
                  child:   FirebaseAnimatedList(
                    query: ref.child(widget.itemId).child("route").child(widget.routeId).child("pickup-points"),
                    itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

                      Map routes = snapshot.value as Map;
                      routes['key'] = snapshot.key;

                      return listItem(
                          routes: routes,
                        types: "pickup-points"
                      );

                    },
                  ),




                )
            ),
            
            Visibility(
                visible: isPressedd,
                child: Expanded(
                  child:   FirebaseAnimatedList(
                    query: ref.child(widget.itemId).child("route").child(widget.routeId).child("drop-points"),
                    itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

                      Map routes = snapshot.value as Map;
                      routes['key'] = snapshot.key;

                      return listItem(
                          routes: routes,
                          types: "drop-points"
                      );

                    },
                  ),




                )
            )
          ],
        ),
      ),
    );
  }

  Widget listItem({required Map routes, required String types}) {

    return Container(
      color: Colors.white,
      margin:  const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8,),
                child: Text(
                  routes['points'],
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(width: 10,),
                  Text(
                    routes['time'],
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 10,)
            ],
          ),

          Container(alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: (){
                ref.child(widget.itemId).child("route").child(widget.routeId).child(types).child(routes['key']).remove();
              },
              child: Icon(
                Icons.delete,
                color: Color(0xff7d2aff),
              ),
            ),
          ),
        ],
      ),
    );


  }

}
