import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:users/data/repository.dart';
import 'package:users/data/user.dart';

class ListUsersBloc extends Bloc<ListUsersEvent, ListUsersState> {
  Repository _repository = Repository();
  String _login;
  List<User> _users;

  ListUsersBloc() : super(null) {
    var box = Hive.box('Login');
    _login = box.get('login', defaultValue: null);
    add(UpdateUsersEvent());
  }

  @override
  Stream<ListUsersState> mapEventToState(ListUsersEvent event) async* {

    if (event is UpdateUsersEvent) {
      yield LoadingState(_login);
      _users = await _repository.getData();

      if (_users != null)
        yield LoadedState(login: _login, users: _users);
      else
        yield ErrorState(_login);
    }

    else if (event is ExitFromSearchUsersEvent)
      yield LoadedState(login: _login, users: _users);

    else if (event is SearchUsersEvent) {
      var searchedUsers =
          event.str.isEmpty ? _users : searchUserByName(event.str);
      yield SearchUserState(login: _login, users: searchedUsers);
    }

    else if (event is LogoutEvent) {
      Hive.box('login').clear();
      yield LogOutState('');
    }
  }

  List<User> searchUserByName(String name) {
    List<User> subUsers = List<User>();
    _users.forEach((element) {
      if (element.fullName.toLowerCase().contains(name.toLowerCase()))
        subUsers.add(element);
    });
    return subUsers;
  }
}

abstract class ListUsersEvent {}

class SearchUsersEvent extends ListUsersEvent {
  final String str;

  SearchUsersEvent(this.str);
}

class ExitFromSearchUsersEvent extends ListUsersEvent {}

class UpdateUsersEvent extends ListUsersEvent {}

class LogoutEvent extends ListUsersEvent {}

abstract class ListUsersState {
  final String login;

  ListUsersState(this.login);
}

class LogOutState extends ListUsersState {
  LogOutState(login) : super(login);
}

class ErrorState extends ListUsersState {
  ErrorState(login) : super(login);
}

class LoadedState extends ListUsersState {
  final List<User> users;

  LoadedState({login, this.users}) : super(login);
}

class LoadingState extends ListUsersState {
  LoadingState(login) : super(login);
}

class SearchUserState extends ListUsersState {
  final List<User> users;

  SearchUserState({login, this.users}) : super(login);
}
