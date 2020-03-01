import 'package:contact/contacts.dart';
import 'package:contact/photos.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ContactsApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final controller = PageController(initialPage: 0, keepPage: true);

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PageView(
        controller: controller,
        onPageChanged: ((index) {
          onPageChanged(index);
        }),
        children: <Widget>[ContactsPage(), PhotosPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}
