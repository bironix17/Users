import 'package:hive/hive.dart';

/// Такой сторадж помогает абстрагироваться от реализации и структурировать
/// все твои значения в одном месте.
///
/// Передавая экземпляр такого класса в конструктор другого, другому всё равно
/// какую реализацию использует [AppStorage]: Hive, SharedPreferences, текстовый
/// файл или БД.
///
/// Соответственно, в таком классе сразу видно, какие значения использует
/// приложение. Обычные строки могут быстро запутать.
abstract class AppStorage {
  String login;
}

class AppStorageHive implements AppStorage {
  static const String boxName = 'LOGIN';
  static const String _loginKey = 'loginKey';

  static Future initHive() async {
    await Hive.openBox(boxName);
  }

  Box get _hiveBox => Hive.box(boxName);

  @override
  String get login => _hiveBox.get(_loginKey);

  @override
  set login(String value) {
    _hiveBox.put(_loginKey, value);
  }
}