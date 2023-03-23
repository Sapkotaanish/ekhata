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
import 'transaction/transaction.dart';
import 'user/profile.dart';
import 'expense_tracker/tracker.dart';
import 'search.dart';

class LoggedView extends StatefulWidget {
  const LoggedView({Key? key}) : super(key: key);
  _LoggedViewState createState() => _LoggedViewState();
}

class _LoggedViewState extends State<LoggedView> {
  String avatar = "";
  String email = "";
  String firstName = "";
  String lastName = "";
  String username = "...";
  int currentView = 0;

  List<Widget> _widgetOptions = [
    Dashboard(),
    FriendView(),
    Transaction(),
    Tracker(),
  ];

  String getTitle() {
    if (currentView == 0) {
      return "Dashboard";
    } else if (currentView == 1) {
      return "Friends";
    } else if (currentView == 2) {
      return "Transactions";
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
      firstName = userObj['firstName'] ?? "";
      lastName = userObj['lastName'] ?? "";
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
            body: _widgetOptions[currentView],
            // body: IndexedStack(children: _widgetOptions, index: currentView),
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.query_stats_outlined), label: "Dashboard"),
                BottomNavigationBarItem(icon: Icon(Icons.people), label: "Friends"),
                BottomNavigationBarItem(icon: Icon(Icons.attach_money_outlined), label: "Transactions"),
                BottomNavigationBarItem(icon: Icon(Icons.wallet_outlined), label: "Tracker")
              ],
              currentIndex: currentView,
              selectedItemColor: Theme.of(context).primaryColor,
              onTap: (value) {
                setState(() {
                  currentView = value;
                });
              },
            ),
          );
        }));
  }
}
