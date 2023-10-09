class Contact {
  String name;
  String phoneNumber;

  Contact({this.name, this.phoneNumber});

  Contact.fromMap(Map<dynamic, dynamic> map)
      : name = map['name'],
        phoneNumber = map['phoneNumber'];
}
