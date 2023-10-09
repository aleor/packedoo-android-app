import 'dart:io';

class NewUser {
  String firstName;
  String lastName;
  File photo;
  String gender;
  int age;
  String phoneNumber;
  String email;
  String password;
  String photoURL;
  String locale;

  NewUser(
      {this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.phoneNumber,
      this.locale});
}
