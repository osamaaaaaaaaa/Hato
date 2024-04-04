import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  String serverToken =
      'AAAAB5636Gk:APA91bF-Kx9h-DKo-s6IBmc13hrwhh4-oWwrMXLhkqR_olNofVu7E4kdG0Nahdkko62lWwuGZNsnwf68kRuxr3STYv_pjcCwCd7WOx0gNb7N4gQ1B0wc93bsgDAm7SAqIXI5HQXokfsQ';
  sendNotification(
      {required body, required title, required token, String? image}) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
            'imageUrl': image
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );
  }
}
