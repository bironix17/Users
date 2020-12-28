import 'package:dio/dio.dart';
import 'package:users/data/user.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class UsersNetwork {
  Dio dio = Dio();
  String endPoint = 'https://randomuser.me/api/';
  int userValue = 15;

  Future<List<User>> getData() async {
    try {

      Response response = await dio.get("https://randomuser.me/api/",
          queryParameters: {'results': userValue},
          options: Options(receiveTimeout: 3000));

      List<User> users = List<User>();

      var res = json.decode(response.toString());

      res = res['results'];
      for (int i = 0; i < userValue; i++) {

        String fullname =
            "${res[i]['name']['first']} ${res[i]['name']['last']}";

        String state = res[i]["location"]['state'].toString();
        String city = res[i]["location"]['city'].toString();
        String street = res[i]["location"]['street']['name'].toString();
        String number = res[i]["location"]['street']['number'].toString();

        String address = "$state $city $street $number";

        ImageProvider<Object> image = NetworkImage(res[i]['picture']['large']);

        users.add(User(i, fullname, address, image));
      }

      return users;
    } catch (e) {
      return null;
    }
  }
}
