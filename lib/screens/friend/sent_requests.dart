import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/services/friend_service.dart';

class SentRequests extends StatefulWidget {
  const SentRequests({Key? key}) : super(key: key);
  _SentRequestsState createState() => _SentRequestsState();
}

class _SentRequestsState extends State<SentRequests> {
  List<Map<String, String?>> requests = [];

  String email = "";
  String avatar = "";
  String username = "";
  bool isLoading = true;

  void showSnackBar(bool success,
      [String message = "Unknown error occurred."]) {
    final snackBar = SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: "Close",
          onPressed: () {},
        ),
        backgroundColor:
            (success = true) ? Colors.green[800] : Colors.red[800]);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> getRequests() async {
    List response = await FriendService.getSentFriendRequests();
    if (response[0] == true) {
      setState(() {
        requests = response[1];
      });
    } else {
      showSnackBar(false);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> cancelRequest(String username) async {
    List response = await FriendService.cancelFriendRequest(username);
    if (response[0] == true) {
      setState(() {
        requests = response[1];
      });
    } else {
      showSnackBar(false);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : Column(
                      children: (() {
                      if (requests.length == 0) {
                        return [Text("No any sent friend requests in pending")];
                      } else {
                        return requests.map((user) {
                          return Container(
                              width: double.maxFinite,
                              child: Card(
                                  shape: const RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  margin: const EdgeInsets.only(),
                                  color: Colors.blue[50],
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(children: [
                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                                backgroundColor: Colors.red,
                                                child: Text(user["username"]?[0]
                                                        .toUpperCase() ??
                                                    ""),
                                                foregroundImage: NetworkImage(
                                                    user["avatar"] ?? "")),
                                            const SizedBox(width: 5),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(user["username"] ?? ""),
                                                  Text(user["email"] ?? ""),
                                                ])
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Divider(
                                          height: 10,
                                          thickness: 2,
                                          indent: 0,
                                          endIndent: 0,
                                          color: Colors.grey[400],
                                        ),
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 20),
                                              IconButton(
                                                iconSize: 32,
                                                icon: const Icon(Icons.close),
                                                color: Colors.red,
                                                onPressed: () {
                                                  print("deny req");
                                                  cancelRequest(
                                                      user["username"] ?? "");
                                                },
                                              ),
                                            ]),
                                      ]))));
                        }).toList();
                      }
                    }())));
        }));
  }
}
