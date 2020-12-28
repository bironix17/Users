import 'package:flutter/cupertino.dart';

class User {
  final int index;
  final String address;
  final String fullName;

  final ImageProvider<Object> image;

  User(this.index, this.fullName, this.address, this.image);
}