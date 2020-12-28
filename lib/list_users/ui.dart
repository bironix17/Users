import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:users/data/user.dart';
import 'package:users/list_users/bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:users/user_page/ui.dart';

class ListUsers extends StatefulWidget {
  ListUsers({Key key}) : super(key: key);

  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  String _login;
  ListUsersBloc _listUsersBloc;

  _ListUsersState() {
    _login = Hive.box('login').get('login');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListUsersBloc(),
      child: BlocBuilder<ListUsersBloc, ListUsersState>(
        builder: (context, state) {
          _listUsersBloc = BlocProvider.of<ListUsersBloc>(context);
          return Scaffold(
            appBar: AppBar(
                title: _textForAppBarTitle(state),
                automaticallyImplyLeading: false,
                actions: _SeacherInAppBar(state)
                ),
            body: _listViewOrOthers(state),
          );
        },
      ),
    );
  }

  void logout() {
    _listUsersBloc.add(LogoutEvent());
  }

  void _stopSearching() {
    _listUsersBloc.add(ExitFromSearchUsersEvent());
  }

  void _showSearchUser() {
    _listUsersBloc.add(SearchUsersEvent(""));
  }

  void _searchingUserFromListView(String str) {
    _listUsersBloc.add(SearchUsersEvent(str));
  }

  Container _listViewOrOthers(ListUsersState state) {

    if (state is LoadingState)
      return Container(
          child: SpinKitCircle(
        color: Colors.green,
        size: 50,
      ));

    if (state is LoadedState)
      return Container(
          child: RefreshIndicator(
        child: _buildList(state.users),
        onRefresh: _handleRefresh,
      ));

    if (state is ErrorState)
      return Container(
          child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(child: Image.asset('assets/images/oops.jpg')),
              )));

    if (state is SearchUserState)
      return Container(
        child: _buildList(state.users),
      );

    if(state is LogOutState)
      Future.microtask(() => Navigator.pop(context));
  }

  Future<void> _handleRefresh() {
    _listUsersBloc.add(UpdateUsersEvent());
    return null;
  }

  ListView _buildList(List<User> users) {
    return ListView(
      children: users
          .map((User user) => Card(
                  child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.image,
                ),
                title: Text(user.fullName),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserPage(
                                user: user,
                              )))
                },
              )))
          .toList(),
    );
  }

  _textForAppBarTitle(ListUsersState state) {
    if (state is SearchUserState)
      return new TextField(
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.white30),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 16.0),
        onChanged: _searchingUserFromListView,
      );
    else if (state is LoadedState) return Text(_login);
  }

  List<Widget> _SeacherInAppBar(ListUsersState state) {
    if (state is SearchUserState)
      return [
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _stopSearching();
          },
        ),
      ];
    else if (state is LoadedState)
      return [
        Row(
          children: [
            MaterialButton(
              onPressed: logout,
              child: Text(
                'Выйти',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _showSearchUser,
            )
          ],
        )
      ];
  }
}
