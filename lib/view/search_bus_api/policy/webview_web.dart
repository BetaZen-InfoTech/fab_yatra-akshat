import 'dart:async';
import 'dart:typed_data';

import 'package:fabyatra/view/home/home_navigation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
// import 'package:webview_flutter_web/webview_flutter_web.dart';


class WebViewPolicy extends StatefulWidget {
  const WebViewPolicy({
    super.key,
    required this.policyUrl,
  });
  final String policyUrl;
  @override
  _WebViewPolicyState createState() => _WebViewPolicyState();
}

class _WebViewPolicyState extends State<WebViewPolicy> {
  late PlatformWebViewController _controller ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = PlatformWebViewController(
      const PlatformWebViewControllerCreationParams(),
    )..loadRequest(
      LoadRequestParams(
        uri: Uri.parse(widget.policyUrl),
      ),
    );
  }

  int _thisPage = 1;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
      oneSec,
          (Timer timer) {
      if (!_controller.currentUrl().toString().contains("https://notice.fabyatra.com/secqure-bussewa-api-policy.php?url=")   ) {
        Navigator.pop(context);
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

