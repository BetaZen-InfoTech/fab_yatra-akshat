import 'package:http/http.dart' as http;


class SendSMS {

  static void nepal( String number,String msg ){



    http.post(
      Uri.parse("https://api.sparrowsms.com/v2/sms/"),
      body: <String, String>{
        "token":"v2_SsWdnv6CvFrGqphFS3KvMCmbp9L.tLe2",
        "from":"FabYatra",
        "to":number,
        "text":msg
      },
      headers: {
      },
    ).then((http.Response response) async {
      if (response.statusCode == 200){

      }
    });

  }
}