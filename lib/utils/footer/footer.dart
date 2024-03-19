import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';

class GlobalFooter {
  static Container footer(myContext) {
    double widthP = Dimensions.myWidthThis(myContext);
    TextStyle defaultStyle =
    TextStyle(color: Colors.grey, fontSize: 20.0 * widthP);
    TextStyle linkStyle =  TextStyle(
        color: Colors.blue,
        fontSize: 14
    );

    TextStyle noLinkStyle =  TextStyle(
        color: Colors.grey,
        fontSize: 14
    );

    return Container(
      padding: const EdgeInsets.all(25.0),
      margin: const EdgeInsets.only(
          top: 15
      ),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
        child: RichText(
          text: TextSpan(
            style: defaultStyle,
            children: <TextSpan>[
              TextSpan(
                text: 'Copyright © 2023-2024',
                style: noLinkStyle,
              ),
              TextSpan(
                text: ' FabYatra',
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await launchUrl(
                      Uri.parse("http://fabyatra.com/"),
                      webOnlyWindowName: '_blank',
                    );                            },
              ),
              TextSpan(
                style: noLinkStyle,
                text: ". Designed with ❤ by",
              ),
              TextSpan(
                text: ' BetaZen InfoTech ',
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await launchUrl(
                      Uri.parse("https://betazeninfotech.com/"),
                      webOnlyWindowName: '_blank',
                    );
                  },
              ),
              TextSpan(
                  style: noLinkStyle,
                  text: "All rights reserved"
              ),
            ],
          ),
        ),
      ),
    );
  }

}