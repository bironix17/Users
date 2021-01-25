import 'package:dio/dio.dart';
import 'package:users/data/user.dart';
import 'package:flutter/material.dart';

import 'user.dart';

/// Хорошая практика - разносить методы запросов и настройку клиентов в
/// разные классы.
class NetworkClient {
  /// [baseUrl] - в константу
  static const String baseUrl = 'https://randomuser.me/';

  Dio get instance {
    final BaseOptions _clientOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 4000,
      receiveTimeout: 7000,
    );

    /// Настройка логгера запросов
    final logInterceptor = LogInterceptor(
      requestBody: true,
      responseBody: true,
    );

    return Dio(_clientOptions)..interceptors.add(logInterceptor);
  }
}

/// Пусть [UsersNetwork] будет каким-то сервисом, который содержит запросы для
/// API.
class UsersNetwork {
  /// Это тоже в константу
  static const int userValue = 15;

  /// В идеале это должно приходить в конструкторе [UsersNetwork]
  Dio client = NetworkClient().instance;

  Future<List<User>> getData() async {
    try {
      final Response response = await client.get("/api",
          queryParameters: {'results': userValue},
          options: Options(receiveTimeout: 3000));

      final List<dynamic> data = response.data['results'];

      /// Это то же самое, что ты написал, но немного короче
      return data.map((e) {
        String fullname = "${e['name']['first']} ${e['name']['last']}";

        String state = e["location"]['state'].toString();
        String city = e["location"]['city'].toString();
        String street = e["location"]['street']['name'].toString();
        String number = e["location"]['street']['number'].toString();

        String address = "$state $city $street $number";

        /// Притягивать зависимости UI-фреймворка в data-слой - не очень хорошо.
        ImageProvider<Object> image = NetworkImage(e['picture']['large']);

        return User(fullname, address, image);
      }).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
