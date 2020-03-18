import 'package:contact/screens/home.dart';
import 'package:contact/screens/registerPage.dart';
import 'package:contact/utilities/httpRequest.dart';
import 'package:contact/utilities/sharedPreferencesRequest.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const LoginPage({Key key, this.analytics, this.observer}) : super(key: key);

  @override
  _LoginPageState createState() {
    return _LoginPageState(analytics, observer);
  }
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isFetching = false;

  final _formKey = GlobalKey<FormState>();

  _LoginPageState(this.analytics, this.observer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Login'),
              Container(
                padding: EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)))),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)))),
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password cannot be empty';
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
                        child: Text( isFetching ? "Loading.." : "Login" ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              isFetching = !isFetching;
                            });
                            API.postLogin('{"email": "' + emailController.text + '", "password": "' + passwordController.text + '"}').then((result){
                              if(result['failed'] != null){
                                final snackBar = SnackBar(
                                  content: Text(result['failed'])
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                                setState(() {
                                  isFetching = !isFetching;
                                });
                              }else{
                                SharedPreferencesRequest.setPreferences("access_token", result['success']);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      title: "Bounche",
                                      analytics: analytics,
                                      observer: observer,
                                    )));
                              }
                            });
                          }
                        }),
                    Container(
                      padding: EdgeInsets.only(left: 8),
                      child: RaisedButton(
                          child: Text("Register"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage(
                                          observer: observer,
                                          analytics: analytics,
                                        )));
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
