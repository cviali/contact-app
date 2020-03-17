import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class RegisterPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const RegisterPage({Key key, this.analytics, this.observer})
      : super(key: key);

  @override
  _RegisterPageState createState() {
    return _RegisterPageState(analytics, observer);
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  _RegisterPageState(this.analytics, this.observer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Register'),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                    controller: usernameController,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                    controller: nameController,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                    controller: emailController,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                    obscureText: true,
                    controller: passwordController,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                    obscureText: true,
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Confirm Password cannot be empty';
                      } else if (value != passwordController.text) {
                        return 'Confirm Password must match password';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                          child: Text("Register"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(
                                            title: "Bounche",
                                            analytics: analytics,
                                            observer: observer,
                                          )));
                            }
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
