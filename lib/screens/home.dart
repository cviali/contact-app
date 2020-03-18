import 'dart:async';

import 'package:contact/screens/contacts.dart';
import 'package:contact/screens/loginPage.dart';
import 'package:contact/screens/photos.dart';
import 'package:contact/screens/scan.dart';
import 'package:contact/utilities/httpRequest.dart';
import 'package:contact/utilities/sharedPreferencesRequest.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget{
  HomePage({Key key, this.title, this.analytics, this.observer})
      : super(key: key);
  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _HomePageState createState() {
    return _HomePageState(analytics, observer);
  }

}

class _HomePageState extends State<HomePage>{
  int _selectedIndex = 0;
  String barcode = '', title = '';
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final controller = PageController(initialPage: 0, keepPage: true);

  _HomePageState(this.analytics, this.observer);

  Future<void> _sendAnalyticsEvent(String string) async {
    await analytics.logEvent(
      name: 'open_scanner',
      parameters: <String, dynamic>{
        'string': string
      },
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      controller.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.decelerate);
    });
  }

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs){
      API.getProfile(prefs.getString("access_token")).then((result){
        setState(() {
          title = "Hi, "+ result;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(
                      analytics: analytics,
                      observer: observer,
                    )));
          })
        ],
      ),
      body: PageView(
        controller: controller,
        onPageChanged: ((index) {
          onPageChanged(index);
        }),
        children: <Widget>[
          ContactsPage(observer: observer),
          PhotosPage(
            observer: observer,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scan,
        child: Icon(Icons.camera),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              title: Text("Contacts"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo),
              title: Text("Photos"),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: onItemTapped,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future _scan() async {
    PermissionStatus permissionCamera = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera),
        permissionStorage = await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.storage);
    if (permissionCamera.value + permissionStorage.value == 0 ||
        permissionCamera.value + permissionStorage.value == 1) {
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler().requestPermissions(
          [PermissionGroup.camera, PermissionGroup.storage]);
    } else {
      String barcode = await scanner.scan();
      if(barcode == "qwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiop"){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScanPage(
                  barcode: this.barcode,
                )));
      }else{
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text("Scan Failed"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("QR Doesn't match our records.")
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                      )
                    ],);
                },
              );
            });
      }
      _sendAnalyticsEvent(barcode);
    }
  }
}