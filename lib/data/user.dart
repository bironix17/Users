import 'package:flutter/cupertino.dart';

class User {
  final String address;
  final String fullName;
  final ImageProvider<Object> image;

  User(this.fullName, this.address, this.image);

  @override
  String toString() {
    return 'User{address: $address, fullName: $fullName, image: $image}';
  }
}