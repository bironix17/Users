import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:users/Auth/ui.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('Login');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Users',
        theme: ThemeData(primarySwatch: Colors.green),
        home: Authorization(),
        debugShowCheckedModeBanner: false);
  }
}
