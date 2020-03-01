import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'models/contact.dart';

class DetailPage extends StatefulWidget {
  final int id;

  const DetailPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends State<DetailPage> {
  Contact _contact = Contact();
  bool isFetching = false;

  Future<Contact> _getDetail() async {
    setState(() {
      isFetching = true;
    });

    var contact = new Contact();

    String url =
        "https://jsonplaceholder.typicode.com/users/" + widget.id.toString();

    Response response = await get(url);

    if (response.statusCode == 200) {
      setState(() {
        isFetching = false;
      });
      contact = Contact.fromJson(json.decode(response.body));
    }

     return contact;
  }

  @override
  void initState() {
    super.initState();
    _getDetail().then((result) {
      setState(() {
        _contact = result;
      });
    });
  }

  Widget detailPage() {
    if (isFetching) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_contact.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Text(_contact.email),
            Text(_contact.position),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contact Detail"),
        ),
        body: detailPage());
  }
}
