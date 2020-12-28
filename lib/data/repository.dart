import 'package:users/data/network.dart';
import 'package:users/data/user.dart';

class Repository {
  UsersNetwork _usersNetwork = UsersNetwork();

  Future<List<User>> getData() {
    return _usersNetwork.getData();
  }
}
