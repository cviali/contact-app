import 'package:flutter/material.dart';

class PhotoDetailPage extends StatefulWidget{
  @override
  _StatePhotoDetailPage createState() {
    return _StatePhotoDetailPage();
  }
}

class _StatePhotoDetailPage extends State<PhotoDetailPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Detail"),
      ),
      body: Center(
        child: Text("Detail"),
      ),
    );
  }
}