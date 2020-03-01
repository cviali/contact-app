import 'dart:convert';

import 'package:contact/models/photo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotosPage extends StatefulWidget {
  @override
  _PhotosPageState createState() {
    return _PhotosPageState();
  }
}

class _PhotosPageState extends State<PhotosPage> {
  List<Photo> _photos = List<Photo>();
  bool isFetching = false;

  Future<List<Photo>> getPhotos() async {
    setState(() {
      isFetching = true;
    });
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
    return photos;
  }

  Widget photoList() {
    if (isFetching) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GridView.builder(
        padding: EdgeInsets.all(12),
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        semanticChildCount: 2,
        itemCount: _photos.length,
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                ),
                FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage, image: _photos[index].url),
                Positioned.fill(
                    child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {

                    },
                  ),
                ))
              ],
            ),
          );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: photoList());
  }
}
