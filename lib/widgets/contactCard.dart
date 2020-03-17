import 'package:contact/screens/contactDetail.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget{
  final int id;
  final String name;
  final String position;
  final String email;

  const ContactCard({Key key, this.id, this.name, this.position, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onLongPress: (){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(name),
                  content: Text(position),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    )
                  ],
                );
              });
        },
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContactDetailPage(
                    id: id,
                  )));
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Text(email),
              Text(position),
            ],
          ),
        ),
      ),
    );
  }

}