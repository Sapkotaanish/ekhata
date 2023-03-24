import 'dart:convert';
import 'package:ekhata/screens/transaction/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/services/http_service.dart';
import 'package:ekhata/services/friend_service.dart';
import 'package:ekhata/env/env.dart' as env;
import './user.dart';
import './friend.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  List<Map<String, String?>> friends = [];

  String email = "";
  String avatar = "";
  String username = "";
  bool isLoading = true;

  void showSnackBar(bool success, [String message = "Unknown error occurred."]) {
    final snackBar = SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: "Close",
          onPressed: () {},
        ),
        backgroundColor: (success = true) ? Colors.green[800] : Colors.red[800]);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> getFriends() async {
    final response = await HttpService.getReq("${env.BACKEND_URL}/friends/");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"] == "true" || data["success"]) {
        setState(() {
          List<Map<String, String?>> temp = [];
          data["data"]?.forEach((user) {
            temp.add({
              "email": user["email"] ?? "",
              "username": user["username"] ?? "",
              "avatar": user["avatar"] ?? "",
              "firstName": user["first_name"],
              "lastName": user["last_name"]
            });
          });
          friends = temp;
        });
      }
    } else {
      print("Success false");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (() {
                        if (friends.isEmpty) {
                          return [const Text("No friends found.")];
                        } else {
                          return friends.map((user) {
                            return SizedBox(
                                width: double.maxFinite,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => Friend(user["username"]!)));
                                    },
                                    child: User(user["username"]!, user["firstName"]!, user["lastName"]!,
                                        user["email"]!, user["avatar"]!)));
                          }).toList();
                        }
                      }())));
        }));
  }
}
