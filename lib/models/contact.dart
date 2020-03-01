class Contact {
  final int id;
  final String name;
  final String email;
  final String position;

  Contact({this.id, this.name, this.email, this.position});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        position: (json['address']['geo']['lat']
            +', '+ json['address']['geo']['lng']));
  }
}