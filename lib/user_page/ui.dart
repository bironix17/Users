import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users/data/user.dart';
import 'package:users/list_users/bloc.dart';
import '../list_users/ui.dart';

class UserPage extends StatelessWidget {
  User user;

  /// В конструктор экранов лучше ничего не передавать, особенно когда ты
  /// используешь bloc.
  ///
  /// Т.е. значение лучше вытягивать напрямую из блока.
  UserPage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.fullName),
      ),
      body: Center(
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: CircleAvatar(
                    backgroundImage: user.image,
                    radius: 95,
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      user.fullName,
                      style: GoogleFonts.lato(fontSize: 32),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      user.address,
                      style: GoogleFonts.lato(fontSize: 24),
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
