import 'dart:convert';
import 'package:ekhata/screens/transaction/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/services/http_service.dart';
import 'package:ekhata/services/friend_service.dart';
import 'package:ekhata/env/env.dart' as env;

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
              "avatar": user["avatar"] ?? ""
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
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ListTransactions(
                                                    username:
                                                        user["username"] ??
                                                            "")));
                                  },
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
                                            SizedBox(height: 15),
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                    backgroundColor: Colors.red,
                                                    child: Text(user["username"]
                                                                ?[0]
                                                            .toUpperCase() ??
                                                        ""),
                                                    foregroundImage:
                                                        NetworkImage(
                                                            user["avatar"] ??
                                                                "")),
                                                SizedBox(width: 5),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(user["username"] ??
                                                          ""),
                                                      Text(user["email"] ?? ""),
                                                    ])
                                              ],
                                            ),
                                            //   SizedBox(height: 15),
                                            //   Divider(
                                            //     height: 10,
                                            //     thickness: 2,
                                            //     indent: 0,
                                            //     endIndent: 0,
                                            //     color: Colors.grey[400],
                                            //   ),
                                            //   Row(
                                            //       crossAxisAlignment:
                                            //           CrossAxisAlignment.center,
                                            //       mainAxisAlignment:
                                            //           MainAxisAlignment.center,
                                            //       children: [
                                            //         SizedBox(width: 20),
                                            //         IconButton(
                                            //           iconSize: 32,
                                            //           icon: const Icon(Icons.close),
                                            //           color: Colors.red,
                                            //           onPressed: () {
                                            //             print("delete req");
                                            //             deleteRequest(
                                            //                 user["username"] ?? "");
                                            //           },
                                            //         ),
                                            //       ]),
                                            // ]))
                                          ])))));
                        }).toList();
                      }
                    }())));
        }));
  }
}
