import 'dart:convert';
import 'package:ekhata/services/http_service.dart';
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
  int relation = -1;
  bool isLoading = true;

  _FriendState(this.username);

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    final response =
        await HttpService.getReq("${env.BACKEND_URL}/profile/$username");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      String success = data['success'] ? "true" : "false";
      setState(() {
        if (success == "true") {
          print("Success is true");
        } else {}
      });
    } else {
      print("response not 200");
    }
    isLoading = false;
  }

  Future<void> cancelRequest() async {
    final response =
        await HttpService.postReq("${env.BACKEND_URL}/deleterequest/", {
      "username": username,
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      String success = data['success'] ? "true" : "false";
      String message = data['message'] ?? "Unknown error occurred.";

      final snackBar = SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: "Close",
          onPressed: () {},
        ),
        backgroundColor:
            (success == "true" ? Colors.green[800] : Colors.red[800]),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (success == "true") {
        print("Success is true");
      } else {
        // options = [];
      }
    } else {
      print(response.statusCode);
      print("response not 200");
    }
  }

  Future<void> unfriend() async {
    final response = await HttpService.postReq(
        "${env.BACKEND_URL}/sendrequest/", {"username": username});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      String success = data['success'] ? "true" : "false";
      String message = data['message'] ?? "Unknown error occurred.";

      final snackBar = SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: "Close",
          onPressed: () {},
        ),
        backgroundColor:
            (success == "true" ? Colors.green[800] : Colors.red[800]),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (success == "true") {
        print("Success is true");
      } else {
        // options = [];
      }
    } else {
      print(response.statusCode);
      print("response not 200");
    }
  }

  Future<void> addFriend() async {
    final response = await HttpService.postReq(
        "${env.BACKEND_URL}/sendrequest/", {"username": username});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      String success = data['success'] ? "true" : "false";
      String message = data['message'] ?? "Unknown error occurred.";

      final snackBar = SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: "Close",
          onPressed: () {},
        ),
        backgroundColor:
            (success == "true" ? Colors.green[800] : Colors.red[800]),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (success == "true") {
        print("Success is true");
      } else {
        // options = [];
      }
    } else {
      print(response.statusCode);
      print("response not 200");
    }
  }

  Future<void> removeFriend() async {
    final response = await HttpService.postReq(
        "${env.BACKEND_URL}/removefriend/", {"username": username});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      String success = data['success'] ? "true" : "false";
      String message = data['message'] ?? "Unknown error occurred.";

      final snackBar = SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: "Close",
          onPressed: () {},
        ),
        backgroundColor:
            (success == "true" ? Colors.green[800] : Colors.red[800]),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (success == "true") {
        print("Success is true");
      } else {
        // options = [];
      }
    } else {
      print(response.statusCode);
      print("response not 200");
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
                  child: Column(children: [
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
                ElevatedButton(
                  onPressed: () {
                    print("pressed");
                    if (relation == -1) {
                      addFriend();
                    } else if (relation == 0) {
                      cancelRequest();
                    } else {
                      unfriend();
                    }
                    // context.read<AuthBloc>().add(AuthLogoutEvent());
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => Home()),
                    //     (Route<dynamic> route) => false,
                    // );
                  },
                  child: const Text('Add Friend'),
                ),
              ])));
        }));
  }
}
