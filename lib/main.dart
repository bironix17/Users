import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:users/Auth/ui.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// По структуре файлов:
///
/// Хорошо, что ты разнес это всё по разным папкам. В целом, для такого
/// маленького приложения это сойдет.
///
/// В глаза бросается именование: user_page, list_users и data, в целом, норм,
/// а Auth выбивается. В дарте принято именовать директории с маленькой буквы
/// снейк-кейсом.
///
/// Норм, что вынес логику данных в data, но саму модель [User] следовало бы
/// перенести в отдельную директорию (можно внутри той же data).

void main() async {
  await Hive.initFlutter();

  /// Вот здесь лучше использовать глоабльные константы для строки. А еще лучше
  /// использовать отдельную утилиту для управления простыми значениями и
  /// абстрагироваться от использования зависимости (т.е. Hive в этом случае).
  ///
  /// Пример положил в data->storage
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
