import 'dart:async';
import 'dart:convert';

import 'package:contact/widgets/contactCard.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:contact/models/contact.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({Key key, this.id, this.observer}) : super(key: key);
  final int id;
  final FirebaseAnalyticsObserver observer;
  static const String routeName = '/contact';

  @override
  State<StatefulWidget> createState() {
    return _ContactsPageState(observer);
  }
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = List<Contact>();
  bool isFetching = false, isVisible = false;
  final FirebaseAnalyticsObserver observer;

  _ContactsPageState(this.observer);

  void _sendCurrentPageToAnalytics() {
    observer.analytics.setCurrentScreen(
      screenName: '${ContactsPage.routeName}',
    );
  }

  Future<List<Contact>> getContacts() async {
    setState(() {
      isFetching = true;
      isVisible = false;
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
      return AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemBuilder: (context, index) {
            return ContactCard(
              id: _contacts[index].id,
              name: _contacts[index].name,
              email: _contacts[index].email,
              position: _contacts[index].position,
            );
          },
          itemCount: _contacts.length,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getContacts().then((result) {
      _contacts.addAll(result);
      Timer(
          Duration(milliseconds: 1),
          () => setState(() {
                isVisible = true;
              }));
    });
    _sendCurrentPageToAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: contactList());
  }
}
