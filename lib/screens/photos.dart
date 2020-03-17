import 'dart:convert';

import 'package:contact/models/photo.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotosPage extends StatefulWidget {
  final FirebaseAnalyticsObserver observer;
  static const String routeName = '/photos';

  const PhotosPage({Key key, this.observer}) : super(key: key);
  @override
  _PhotosPageState createState() {
    return _PhotosPageState(observer);
  }
}

class _PhotosPageState extends State<PhotosPage> {
  List<Photo> _photos = List<Photo>();
  bool isFetching = true;
  int listCount = 1;
  ScrollController _scrollController = new ScrollController();
  final FirebaseAnalyticsObserver observer;

  _PhotosPageState(this.observer);

  void _sendCurrentPageToAnalytics() {
    observer.analytics.setCurrentScreen(
      screenName: '${PhotosPage.routeName}',
    );
  }

  Future<List<Photo>> getPhotos() async {
    String url = "https://jsonplaceholder.typicode.com/photos";

    Response response = await get(url);

    List<Photo> photos = List<Photo>();

    if (response.statusCode == 200) {
      setState(() {
        isFetching = false;
      });
      var result = json.decode(response.body);
      for (var photo in result) {
        photos.add(Photo.fromJson(photo));
      }
    }
    listCount += 15;
    return photos;
  }

  Widget photoList() {
    if (isFetching) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(12),
        itemCount: listCount,
        itemBuilder: (context, index) {
          return Card(
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                        FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: _photos[index].url),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(_photos[index].title)),
                  ),
                ],
              ));
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getPhotos().then((result) {
      _photos.addAll(result);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getPhotos().then((result) {
          setState(() {
            _photos.addAll(result);
          });
        });
      }
    });

    _sendCurrentPageToAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: photoList());
  }
}
