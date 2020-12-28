import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// В super лучше всегда что-нибудь передавать, это обережет тебя от
  /// непредвиденных ошибок.
  AuthBloc() : super(null) {
    add(StartEvent());
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    /// Эту логику можно вынести в какой-нибудь глобальный BLoC, который
    /// будет управлять начальным состоянием приложения.
    ///
    /// Сейчас у тебя так получается, что экран на секунду успевает показываться.
    ///
    /// Тем более эта логика здесь не особо уместна.
    if (event is StartEvent) {
      /// Как раз вот здесь можно использовать storage
      var box = Hive.box('Login');
      String login = box.get('login', defaultValue: null); // Дефолтное значение null можно не указывать, оно и так null
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
