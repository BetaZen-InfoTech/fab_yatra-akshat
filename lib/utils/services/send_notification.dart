import 'package:http/http.dart' as http;


class SendNotification {
  static void  send(String title, String msg, String topic){

    Map body = {
      "data":{
        "title":title,
        "message":msg
      },
      "to":"/topic/$topic"
    };

    var headers = {
      "Authorization":"key=AAAAA5H1WlI:APA91bG1emRo2uWS97SclzVfQ02iKo8S93B-efC1w2PT8Z8o3VfzuJO6hpyvAjbY1y6P1zGaKrQiwd7tZ3S68P5cRND3igZmwD213RjAdhuqcjrCgU6ntWg6CAeQyqv198EyOSiJOzP6"
    };

    http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      body: body,
      headers: headers,
    ).then((http.Response response) async {
      if (response.statusCode == 200) {

      }

    });

  }
}