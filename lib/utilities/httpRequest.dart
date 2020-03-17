//import 'dart:convert';
//
//import 'package:http/http.dart' as http;
//
//const baseUrl = "http://dev.bounche.com/bounche-rsvp/public/";
//
//class API{
//  static Future<String> postLogin(String username, String password) async {
//    var url = baseUrl + 'api/login';
//    http.Response response = await http.post(url, headers: {"Content-Type": "application/json"}, body: {
//      "email": "chrisbounche",
//      "password": "bounche"
//    });
//
//    if(response.statusCode != 200){
//      return json.decode(response.body)['message'];
//    }
//    return json.decode(response.body)[]
//  }
//}