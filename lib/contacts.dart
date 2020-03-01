import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'detail.dart';
import 'models/contact.dart';

class ContactsPage extends StatefulWidget {
  final int id;

  const ContactsPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ContactsPageState();
  }
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = List<Contact>();
  bool isFetching = false;

  Future<List<Contact>> getContacts() async {
    setState(() {
      isFetching = true;
    });
    String url = "https://jsonplaceholder.typicode.com/users";

    var contacts = List<Contact>();

    Response response = await get(url);

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      for (var contact in result) {
        contacts.add(Contact.fromJson(contact));
      }
    }
    setState(() {
      isFetching = false;
    });
    return contacts;
  }

  Widget contactList() {
    if (isFetching) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(12),
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onLongPress: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(_contacts[index].name),
                        content: Text(_contacts[index].position),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          )
                        ],
                      );
                    });
              },
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(
                          id: _contacts[index].id,
                        )));
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _contacts[index].name,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(_contacts[index].email),
                    Text(_contacts[index].position),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: _contacts.length,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getContacts().then((result) {
      _contacts.addAll(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: contactList()
    );
  }
}
