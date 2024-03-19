import 'dart:async';
import 'dart:typed_data';

import 'package:fabyatra/view/home/home_navigation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
// import 'package:webview_flutter_web/webview_flutter_web.dart';


class WebViewExample extends StatefulWidget {
  const WebViewExample({
    super.key,
    required this.paymentUrl,
  });
  final String paymentUrl;
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late PlatformWebViewController _controller ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = PlatformWebViewController(
      const PlatformWebViewControllerCreationParams(),
    )..loadRequest(
      LoadRequestParams(
        uri: Uri.parse(widget.paymentUrl),
      ),
    );
  }

  int _thisPage = 1;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
      oneSec,
          (Timer timer) {
      if (_controller.currentUrl().toString()=="https://fabyatra.com/booking/" || _controller.currentUrl().toString()=="http://fabyatra.com/booking/" || _controller.currentUrl().toString()=="https://fabyatra.com/booking" || _controller.currentUrl().toString()=="http://fabyatra.com/booking" || _controller.currentUrl().toString()=="http://m.fabyatra.com/booking" || _controller.currentUrl().toString().contains("http://fabyatra.com") || _controller.currentUrl().toString().contains("https://fabyatra.com") || _controller.currentUrl().toString().contains("http://m.fabyatra.com") || _controller.currentUrl().toString().contains("https://m.fabyatra.com")  ) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home())
        );
      }else{
        startTimer();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: PlatformWebViewWidget(
          PlatformWebViewWidgetCreationParams(controller: _controller),
        ).build(context),
      ),
    );
  }
}

