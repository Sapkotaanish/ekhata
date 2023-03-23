import 'package:ekhata/screens/friend/received_requests.dart';
import 'package:ekhata/screens/friend/friends_list.dart';
import 'package:ekhata/screens/friend/sent_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import '../search.dart';

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
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                  title: Text("Friends", style: TextStyle(color: Theme.of(context).primaryColor)),
                  shape: Border(bottom: BorderSide(color: Colors.grey)),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  bottom: TabBar(
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.black,
                    tabs: const [
                      FittedBox(
                        child: Text("Friends"),
                      ),
                      FittedBox(
                        child: Text(
                          "Received\nRequests",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          "Sent\nRequests",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Search()),
                          );
                        },
                        child: const Padding(
                            padding: EdgeInsets.only(right: 18.0), child: Icon(Icons.search, color: Colors.black))),
                  ]),
              body: const TabBarView(
                children: [
                  FriendsList(),
                  ReceivedRequests(),
                  SentRequests(),
                ],
              ),
            ),
          );
        }));
  }
}
