import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotoCard extends StatelessWidget{
  final String url;
  final String title;

  const PhotoCard({Key key, this.url, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      image: url),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(title)),
            ),
          ],
        ));
  }

}