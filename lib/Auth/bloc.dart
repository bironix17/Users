import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(null) {
    add(StartEvent());
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is StartEvent) {
      var box = Hive.box('Login');
      String login = box.get('login', defaultValue: null);
      if (login != null)
        yield AuthorizedState();
      else
        yield NotAuthorizedState();
    }

    if (event is LoginEvent) {
      if (event.login.isEmpty)
        yield InputErrorState();
      else {
        var box = Hive.box('Login');
        box.put('login', event.login);
        yield AuthorizedState();
      }
    }
  }
}


abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String login;
  LoginEvent(this.login);
}

class StartEvent extends AuthEvent {}




abstract class AuthState {}

class NotAuthorizedState extends AuthState {}

class AuthorizedState extends AuthState {}

class InputErrorState extends AuthState {}
