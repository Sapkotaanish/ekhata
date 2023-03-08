import 'dart:convert';
import 'package:ekhata/screens/friend/received_requests.dart';
import 'package:ekhata/screens/friend/friends_list.dart';
import 'package:ekhata/screens/friend/sent_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_event.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/services/storage_service.dart';

class FriendView extends StatefulWidget {
  const FriendView({Key? key}) : super(key: key);
  _FriendViewState createState() => _FriendViewState();
}

class _FriendViewState extends State<FriendView> {
  int activeSection = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Column(children: [
            Container(
              color: Colors.green[100],
              child: Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: activeSection == 0 ? Colors.black : Colors.blue,
                    ),
                    child: const Text("Friends"),
                    onPressed: () {
                      _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      print(activeSection);
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: activeSection == 1 ? Colors.black : Colors.blue,
                    ),
                    child: const Text("Received Requests"),
                    onPressed: () {
                      _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      print(activeSection);
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: activeSection == 2 ? Colors.black : Colors.blue,
                    ),
                    child: const Text("Sent Requests"),
                    onPressed: () {
                      _pageController.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      print("gotothis");
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [FriendsList(), ReceivedRequests(), SentRequests()],
                onPageChanged: (value) {
                  setState(() {
                    activeSection = value;
                  });
                },
              ),
            )
          ]);
        }));
  }
}
