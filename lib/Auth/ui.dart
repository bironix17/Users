import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users/Auth/bloc.dart';
import 'package:users/list_users/ui.dart';

class Authorization extends StatefulWidget {
  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthorizedState) {
          Future.microtask(() => Navigator.push(
              context, MaterialPageRoute(builder: (context) => ListUsers())));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Users'),
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: TextFormField(
                  controller: _textFieldController,
                  decoration: InputDecoration(labelText: "Login"),
                  keyboardType: TextInputType.name,
                  maxLength: 15,
                  autovalidate: true,
                  validator: (String s) {
                    if (state is InputErrorState) return "Введите логин";
                    return null;
                  },
                ),
                width: 300,
              ),
              Container(
                  padding: EdgeInsets.only(top: 30),
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text('Войти'),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context)
                          .add(LoginEvent(_textFieldController.text));
                    },
                  ))
            ],
          )),
        );
      }),
    );
  }
}
