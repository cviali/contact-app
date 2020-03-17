import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/contact.dart';

class ContactDetailPage extends StatefulWidget {
  final int id;

  const ContactDetailPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ContactDetailPageState();
  }
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  Contact _contact = Contact();
  bool isFetching = false;
  String title = 'Contact Detail';

  Future<Contact> _getDetail() async {
    setState(() {
      isFetching = true;
    });

    var contact = new Contact();

    String url =
        "https://jsonplaceholder.typicode.com/users/" + widget.id.toString();
    print(url);

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
        title = _contact.name;
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
            Text(_contact.position)
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: detailPage());
  }
}
