import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieDialog extends StatefulWidget {
  @override
  _LottieDialogState createState() => _LottieDialogState();
}

class _LottieDialogState extends State<LottieDialog> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );

    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Lottie.asset(
          "assets/animation.json", // Replace with the path to your Lottie animation file
          fit: BoxFit.cover,
          controller: controller,
          onLoaded: (composition) {
            controller.forward();
          },
        ),
      ),
    );
  }
}