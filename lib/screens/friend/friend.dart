import 'dart:convert';
import 'package:ekhata/services/http_service.dart';
import 'package:ekhata/services/friend_service.dart';
import 'package:ekhata/env/env.dart' as env;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_event.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/services/storage_service.dart';
import '../home.dart';

class Friend extends StatefulWidget {
  final String username;

  const Friend(this.username);
  _FriendState createState() => _FriendState(username);
}

class _FriendState extends State<Friend> {
  final String username;
  String email = "";
  String firstName = "";
  String lastName = "";
  String? avatar;
  String relation = "F";
  bool isLoading = true;

  _FriendState(this.username);

  @override
  void initState() {
    super.initState();
    getUser();
  }

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

  Future<void> getUser() async {
    final response = await HttpService.getReq(
        "${env.BACKEND_URL}/profile/$username".replaceAll('#', '%23'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"] == true) {
        final userDetail = data["data"][0];
        setState(() {
          firstName = userDetail["first_name"];
          lastName = userDetail["last_name"];
          email = userDetail["email"];
          relation = userDetail["relation"];
        });
      }
    } else {
      showSnackBar(false);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteRequest() async {
    setState(() {
      isLoading = true;
    });
    try {
      List response = await FriendService.deleteFriendRequest(username, false);
      showSnackBar(response[0], response[1]);
    } catch (id) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> cancelRequest() async {
    setState(() {
      isLoading = true;
    });
    try {
      List response = await FriendService.deleteFriendRequest(username, true);
      showSnackBar(response[0], response[1]);
    } catch (id) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> unfriend() async {
    setState(() {
      isLoading = true;
    });
    try {
      List response = await FriendService.deleteFriendRequest(username, true);
      showSnackBar(response[0], response[1]);
    } catch (id) {
      showSnackBar(false);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> addFriend() async {
    setState(() {
      isLoading = true;
    });
    try {
      List response = await FriendService.removeFriend(username);
      print(response);
      showSnackBar(response[0], response[1]);
    } catch (id) {
      showSnackBar(false);
    }
    setState(() {
      isLoading = true;
    });
  }

  Future<void> removeFriend() async {
    setState(() {
      isLoading = true;
    });
    try {
      List response = await FriendService.removeFriend(username);
      print(response);
      showSnackBar(response[0], response[1]);
    } catch (id) {
      showSnackBar(false);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> acceptRequest() async {}

  Widget friendsButton() {
    if (relation == "N") {
      return ElevatedButton(
          child: Text("Add Friend"),
          onPressed: () {
            addFriend();
          });
    } else if (relation == "S") {
      return ElevatedButton(
          child: Text("Cancel Request"),
          onPressed: () {
            cancelRequest();
          });
    } else if (relation == "I") {
      return Column(children: [
        ElevatedButton(
            child: Text("Accept Request"),
            onPressed: () {
              acceptRequest();
            }),
        ElevatedButton(
            child: Text("Accept Request"),
            onPressed: () {
              deleteRequest();
            }),
      ]);
    } else {
      return ElevatedButton(
          child: Text("Unfriend"),
          onPressed: () {
            removeFriend();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Scaffold(
              appBar: AppBar(title: const Text("Profile")),
              body: Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Column(children: [
                          SizedBox(height: 20),
                          CircleAvatar(
                              // foregroundImage: NetworkImage(avatar ?? ""),
                              child: Text(username[0].toUpperCase() ?? "U"),
                              radius: 50),
                          SizedBox(height: 20),
                          Text(email),
                          SizedBox(height: 20),
                          Text(username),
                          SizedBox(height: 20),
                          Text("$firstName $lastName"),
                          SizedBox(height: 20),
                          friendsButton(),
                        ])));
        }));
  }
}
