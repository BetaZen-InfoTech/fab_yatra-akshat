import 'package:fabyatra/view/home/home_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebsite extends StatefulWidget {
  const MyWebsite({
    super.key,
    required this.paymentUrl,
  });
  final String paymentUrl;

  @override
  State<MyWebsite> createState() => _MyWebsiteState();
}

class _MyWebsiteState extends State<MyWebsite> {

  // late  WebViewController _controller;
  String myUrl = "";

  var controller =   WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller
      .loadRequest(Uri.parse(widget.paymentUrl));
    controller
      .setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            if (url.toString()=="https://fabyatra.com/booking/" || url.toString()=="http://fabyatra.com/booking/" || url.toString()=="https://fabyatra.com/booking" || url.toString()=="http://fabyatra.com/booking" || url.toString()=="http://m.fabyatra.com/booking" || url.toString().contains("http://fabyatra.com") || url.toString().contains("https://fabyatra.com") || url.toString().contains("http://m.fabyatra.com") || url.toString().contains("https://m.fabyatra.com")  ) {
              Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home())
                        );
            }
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            if (url.toString()=="https://fabyatra.com/booking/" || url.toString()=="http://fabyatra.com/booking/" || url.toString()=="https://fabyatra.com/booking" || url.toString()=="http://fabyatra.com/booking" || url.toString()=="http://m.fabyatra.com/booking" || url.toString().contains("http://fabyatra.com") || url.toString().contains("https://fabyatra.com") || url.toString().contains("http://m.fabyatra.com") || url.toString().contains("https://m.fabyatra.com")  ) {
              Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home())
                        );
            }
            debugPrint('Page finished loading: $url');
          },
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     debugPrint('blocking navigation to ${request.url}');
          //     return NavigationDecision.prevent;
          //   }
          //   debugPrint('allowing navigation to ${request.url}');
          //   return NavigationDecision.navigate;
          // },
          onUrlChange: (UrlChange change) {
            if (change.url.toString()=="https://fabyatra.com/booking/" || change.url.toString()=="http://fabyatra.com/booking/" || change.url.toString()=="https://fabyatra.com/booking" || change.url.toString()=="http://fabyatra.com/booking" || change.url.toString()=="http://m.fabyatra.com/booking" || change.url.toString().contains("http://fabyatra.com") || change.url.toString().contains("https://fabyatra.com") || change.url.toString().contains("http://m.fabyatra.com") || change.url.toString().contains("https://m.fabyatra.com")  ) {
              Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home())
                        );
            }
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            // openDialog(request);
          },
        ),
      );
  }



  @override
  Widget build(BuildContext context) {


    var _controller =   WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.paymentUrl))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            if (url.toString()=="https://fabyatra.com/booking/" || url.toString()=="http://fabyatra.com/booking/" || url.toString()=="https://fabyatra.com/booking" || url.toString()=="http://fabyatra.com/booking" || url.toString()=="http://m.fabyatra.com/booking" || url.toString().contains("http://fabyatra.com") || url.toString().contains("https://fabyatra.com") || url.toString().contains("http://m.fabyatra.com") || url.toString().contains("https://m.fabyatra.com")  ) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home())
              );
            }
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            if (url.toString()=="https://fabyatra.com/booking/" || url.toString()=="http://fabyatra.com/booking/" || url.toString()=="https://fabyatra.com/booking" || url.toString()=="http://fabyatra.com/booking" || url.toString()=="http://m.fabyatra.com/booking" || url.toString().contains("http://fabyatra.com") || url.toString().contains("https://fabyatra.com") || url.toString().contains("http://m.fabyatra.com") || url.toString().contains("https://m.fabyatra.com")  ) {
              Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home())
                        );
            }
            debugPrint('Page finished loading: $url');
          },
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     debugPrint('blocking navigation to ${request.url}');
          //     return NavigationDecision.prevent;
          //   }
          //   debugPrint('allowing navigation to ${request.url}');
          //   return NavigationDecision.navigate;
          // },
          onUrlChange: (UrlChange change) {
            if (change.url.toString()=="https://fabyatra.com/booking/" || change.url.toString()=="http://fabyatra.com/booking/" || change.url.toString()=="https://fabyatra.com/booking" || change.url.toString()=="http://fabyatra.com/booking" || change.url.toString()=="http://m.fabyatra.com/booking" || change.url.toString().contains("http://fabyatra.com") || change.url.toString().contains("https://fabyatra.com") || change.url.toString().contains("http://m.fabyatra.com") || change.url.toString().contains("https://m.fabyatra.com")  ) {
              Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home())
                        );
            }
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            // openDialog(request);
          },
        ),
      );

    return SafeArea(
        child: Scaffold(
          body: WebViewWidget(controller: controller,),
        )
    );
  }
}