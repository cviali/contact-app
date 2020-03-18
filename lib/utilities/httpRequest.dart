import 'dart:convert';

import 'package:http/http.dart';

const baseUrl = "http://dev.bounche.com/bounche-rsvp/public/api";

class API {
  static Future<Map<String, dynamic>> postLogin(String body) async {
    var url = baseUrl + '/login';

    Map<String, String> headers = {"Content-Type": "application/json"};

    Response response = await post(url, headers: headers, body: body);

    var result = json.decode(response.body);

    if(result['status'] == false || result['status'] == 'error'){
      return {"failed": result['message']};
    }
    return {"success": result['data']['access_token']};
  }

  static Future<String> getProfile(String token) async{
    var url = baseUrl + '/get-user';

    Map<String, String> headers = {"Authorization": "Bearer "+token};

    Response response = await get(url, headers: headers);

    var result = json.decode(response.body);

    print(result['name']);
    // todo: progress this
    return result['name'];
  }
}
