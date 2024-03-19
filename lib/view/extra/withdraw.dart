import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/services/global.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({super.key});

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {

  final accNoTextFieldController = TextEditingController();
  final accNameTextFieldController = TextEditingController();
  final ifscTextFieldController = TextEditingController();
  final swiftTextFieldController = TextEditingController();
  final amountTextFieldController = TextEditingController();

  final _formkey =GlobalKey<FormState>();

  DatabaseReference ref = FirebaseDatabase.instance
      .ref()
      .child("${GlobalVariable.appType}/project-backend")
      .child("vehicle")
  ;


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
            title: Text('Withdraw',
              style: TextStyle(
                  color: Colors.white
              )
              ,),
            backgroundColor: Color(0xff7d2aff),
          ),
          body:SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter details';
                          }
                          return null;
                        },
                        textAlign: TextAlign.left,
                        controller:
                        accNoTextFieldController,
                        decoration: const InputDecoration(
                          labelText: "Bank Account Number",
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Change the color here
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Change the color here
                          ),
                          // border: InputBorder.none,
                        ),
                      ),
                      SizedBox(
                        height: 8 * heightF,
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter details';
                          }
                          return null;
                        },
                        textAlign: TextAlign.left,
                        controller:
                        accNameTextFieldController, //Todo: Add this here
                        decoration: const InputDecoration(
                          labelText: "Bank Account Name",
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Change the color here
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Change the color here
                          ),
                          // border: InputBorder.none,
                        ),
                      ),
                      SizedBox(
                        height: 8 * heightF,
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter details';
                          }
                          return null;
                        },
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.phone,
                        controller:
                        ifscTextFieldController, //Todo: Add this here
                        decoration: const InputDecoration(
                          labelText: "IFSC Code",
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Change the color here
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Change the color here
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8 * heightF,
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter details';
                          }
                          return null;
                        },
                        textAlign: TextAlign.left,
                        controller:
                        swiftTextFieldController, //Todo: Add this here
                        decoration: const InputDecoration(
                          labelText: "Swift Code",
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Change the color here
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Change the color here
                          ),
                        ),
                      ),
            
            
            
                      SizedBox(
                        height: 8 * heightF,
                      ),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter details';
                          }
                          return null;
                        },
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.phone,
                        controller:
                        amountTextFieldController, //Todo: Add this here
                        decoration: const InputDecoration(
                          labelText: "Amount",
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Change the color here
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey), // Change the color here
                          ),
                        ),
                      ),
            
            
                      SizedBox(
                        height: 25* heightF,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Current Amount: ₹500 ",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25 * heightF,
                      ),
                      GestureDetector(
                        onTap: (){
            
                        },
                        child: Container(
                          height:45,
                          decoration: BoxDecoration(
                            color: Color(0xff7d2aff)
                          ),
                          child: Center(
                            child: const Text(
                              "Balance",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold,
                                  fontSize: 18
                              ),
                            ),
                          ),
                        ),
                      ),
            
                    ],
                  )
              ),
            ),
          )
    )
    );
  }
}
