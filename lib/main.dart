import 'dart:async';

import 'package:contact/screens/contacts.dart';
import 'package:contact/screens/home.dart';
import 'package:contact/screens/loginPage.dart';
import 'package:contact/screens/photos.dart';
import 'package:contact/screens/scan.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  
  runZoned((){
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bounche RSVP',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(
          title: 'Bounche RSVP', analytics: analytics, observer: observer),
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: analytics,
        )
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.analytics, this.observer})
      : super(key: key);
  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _MyHomePageState createState() => _MyHomePageState(analytics, observer);
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  _MyHomePageState(this.analytics, this.observer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: LoginPage(analytics: analytics, observer: observer,))
    );
  }
}
