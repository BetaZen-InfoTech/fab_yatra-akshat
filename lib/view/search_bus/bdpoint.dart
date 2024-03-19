import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/search_bus/select_seat.dart';

class bdPoint extends StatefulWidget {
  const bdPoint({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    required this.itemId,
    required this.routeId,
  });

  final String itemId;
  final String routeId;
  final String from;
  final String to;
  final String date;

  @override
  State<bdPoint> createState() => _bdPointState();
}

class _bdPointState extends State<bdPoint> {
  bool isPressedb = true;
  bool isPressedd = false;

  //Todo: time check...
  int nowTime = (DateTime.now().hour * 60) + (DateTime.now().minute);
  // final kathmandu = tz.getLocation('Asia/Kathmandu');

  DatabaseReference ref = FirebaseDatabase.instance
      .ref()
      .child("${GlobalVariable.appType}/project-backend")
      .child("vehicle")
      .child("details")
      .child("bus");

  String bpoint = "";
  String dbdpoint = "";
  String btime = "";
  String dbdtime = "";

  Widget listItem({required Map routes, required String types}) {
    return GestureDetector(
      onTap: () async {
        if (types == "pickup-points") {


          // int currentDate = tz.TZDateTime.now(kathmandu).millisecondsSinceEpoch;
          List<String> splitTime = routes['time'].split(':');
          int selectTIme = ((int.parse(splitTime[0]) * 60) + int.parse(splitTime[1]))*60*1000;

          int selectDate = DateTime(int.parse(widget.date.split("-")[0]), int.parse(widget.date.split("-")[1]), int.parse(widget.date.split("-")[2]), 0, 0, 0).millisecondsSinceEpoch;

          int currentDate = DateTime.now().millisecondsSinceEpoch;

          if (selectDate+selectTIme < currentDate+(0.30*3600*1000)) {
            final snackBar = SnackBar(
              content: const Text('This bus is not available for this day.'),
              action: SnackBarAction(
                label: 'dismiss',
                onPressed: () {},
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          bpoint = routes['points'];
          btime = routes['time'];
          setState(() {
            selectedb = 1;
          });

        } else {
          dbdpoint = routes['points'];
          dbdtime = routes['time'];
          setState(() {
            selecteddb = 1;
          });
        }
      },
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Text(
                    routes['points'],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      routes['time'],
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Icon(
                types == "pickup-points"
                    ? bpoint == routes['points']
                    ? Icons.album_rounded
                    : Icons.adjust_rounded
                    : dbdpoint == routes['points']
                    ? Icons.album_rounded
                    : Icons.adjust_rounded,
                // Icons.adjust_rounded,
                color: Colors.amber.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int selectedb = 0;
  int selecteddb = 0;

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
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    // "${widget.from.split(' ').map((word) => word.capitalize()).join(' ')} to ${widget.to.split(' ').map((word) => word.capitalize()).join(' ')}",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    "${widget.from} to ${widget.to}",
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Text(
                  //   "07 October, Saturday",
                  //   style: TextStyle(color: Colors.white, fontSize: 15),
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
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isPressedb = true;
                        isPressedd = false;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Boarding Point",
                        style: TextStyle(
                            color: isPressedb
                                ? Colors.black
                                : Colors.grey.shade400,
                            fontWeight: isPressedb
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isPressedd = true;
                        isPressedb = false;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Drop Point",
                        style: TextStyle(
                            color: isPressedd
                                ? Colors.black
                                : Colors.grey.shade400,
                            fontWeight: isPressedd
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
                visible: isPressedb,
                child: Expanded(
                  child: FirebaseAnimatedList(
                    query: ref
                        .child(widget.itemId)
                        .child("route")
                        .child(widget.routeId)
                        .child("pickup-points"),
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Map routes = snapshot.value as Map;
                      routes['key'] = snapshot.key;

                      return listItem(routes: routes, types: "pickup-points");
                    },
                  ),
                )),
            Visibility(
                visible: isPressedd,
                child: Expanded(
                  child: FirebaseAnimatedList(
                    query: ref
                        .child(widget.itemId)
                        .child("route")
                        .child(widget.routeId)
                        .child("drop-points"),
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Map routes = snapshot.value as Map;
                      routes['key'] = snapshot.key;

                      return listItem(routes: routes, types: "drop-points");
                    },
                  ),
                ))
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 90 * heightF,
          child: Row(
            children: [
              if (selectedb == 1 && selecteddb == 1)
                Expanded(
                    child: Container(
                      margin: EdgeInsets.all(
                          2* heightF
                      ),
                      height: 47 * heightF,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.amber.shade800,),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectSeat(
                                bpoint: bpoint,
                                dbdpoint: dbdpoint,
                                btime: btime,
                                dbdtime: dbdtime,
                                itemId: widget.itemId,
                                from: widget.from,
                                to: widget.to,
                                date: widget.date,
                                routeId: widget.routeId,
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 21 * heightF,
                            ),
                          ),
                        ),
                      ),
                    ))
              else
                Expanded(
                    child: Container(
                      height: 47 * heightF,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.amber.shade800,),
                        onPressed: () {
                          if (isPressedb == true) {
                            setState(() {
                              isPressedb = false;
                              isPressedd = true;
                            });
                          } else {
                            setState(() {
                              isPressedd = false;
                              isPressedb = true;
                            });
                          }

                          // if(selectedb==0){
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(
                          //         content:Text("Select pick up point")
                          //
                          //     ),
                          //   );
                          // }
                          // if(selecteddb==0){
                          // ScaffoldMessenger.of(context).showSnackBar(
                          // const SnackBar(
                          // content:Text("Select drop point")
                          //
                          // ),
                          // );
                          // }
                          //
                          // setState(() {
                          //   if(selecteddb==0&&selectedb==0){
                          //     selecteddb==1;
                          //     selectedb==1;
                          //   }
                          //   else{
                          //     selecteddb==0;
                          //     selectedb==0;
                          //   }
                          // });
                        },
                        child: Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 21 * heightF,
                            ),
                          ),
                        ),
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }


}
