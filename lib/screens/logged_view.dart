import 'package:ekhata/screens/dashboard.dart';
import 'package:ekhata/screens/friend/received_requests.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ekhata/env/env.dart' as env;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import '../services/storage_service.dart';
import 'package:ekhata/services/http_service.dart';
import 'friend/friend_view.dart';
import 'user/profile.dart';

class LoggedView extends StatefulWidget {
  const LoggedView({Key? key}) : super(key: key);
  _LoggedViewState createState() => _LoggedViewState();
}

class _LoggedViewState extends State<LoggedView> {
  String avatar = "";
  String email = "";
  String username = "...";
  int currentView = 0;

  List<Widget> _widgetOptions = [
    Dashboard(),
    FriendView(),
  ];

  String getTitle() {
    if (currentView == 0) {
      return "Dashboard";
    } else if (currentView == 1) {
      return "Friends";
    } else {
      return "Ekhata";
    }
  }

  Future<void> getEmail() async {
    final StorageService _storageService = StorageService();
    final user = await _storageService.read('user');
    final userObj = jsonDecode(user ?? "");
    print(userObj);
    setState(() {
      email = userObj['email'] ?? "";
      username = userObj['username'] ?? "";
      avatar = userObj['avatar'] ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(getTitle()), actions: [
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(avatar),
                    backgroundColor: Colors.brown.shade800,
                  ))
            ]),
            body: _widgetOptions[currentView],
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: "Dashboard"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.school), label: "Friends")
              ],
              currentIndex: currentView,
              selectedItemColor: Colors.amber[800],
              onTap: (value) {
                setState(() {
                  currentView = value;
                });
                // if (value == 1) {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => FriendView()));
                // }
                print(value);
              },
            ),
          );
        }));
  }
}
