import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomDialog {

  static showCustomDialog(
      BuildContext context,
      bool outTouchCancel
      ){

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog( // <-- SEE HERE
          title: const Text('Cancel booking'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want to cancel booking?'),
              ],
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
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );


    showDialog(
      barrierDismissible: outTouchCancel,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            child: Lottie.asset(
              "assets/animation.json",
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

}
