import 'dart:convert';
import 'package:ekhata/screens/transaction/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/services/http_service.dart';
import 'package:ekhata/services/friend_service.dart';
import 'package:ekhata/env/env.dart' as env;
import '../friend/user.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  List<Map<String, String?>> friends = [];
  List<Map<String, String?>> filteredFriends = [];

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
        setState(() {
          filteredFriends = friends;
        });
      }
    } else {
      print("Success false");
    }
    setState(() {
      isLoading = false;
    });
  }

  void filterFriends(value) {
    value = value.trim().toLowerCase();
    setState(() {
      filteredFriends = friends
          .where((element) =>
              element["email"]!.toLowerCase().contains(value) ||
              element["firstName"]!.toLowerCase().contains(value) ||
              element["lastName"]!.toLowerCase().contains(value) ||
              element["username"]!.toLowerCase().contains(value))
          .toList();
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
          return Scaffold(
              appBar: AppBar(
                title: Text("Transactions", style: TextStyle(color: Theme.of(context).primaryColor)),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: (() {
                          if (friends.isEmpty) {
                            return [const Text("No friends found.")];
                          } else {
                            return [
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: TextField(
                                  decoration: InputDecoration(
                                      // focusedBorder: OutlineInputBorder(
                                      //   borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                                      //   borderRadius: BorderRadius.circular(30),
                                      // ),
                                      // enabledBorder: OutlineInputBorder(
                                      //   borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 0.8),
                                      //   borderRadius: BorderRadius.circular(30),
                                      // ),
                                      prefixIcon: Icon(Icons.search),
                                      // prefixIconColor: Theme.of(context).primaryColor,
                                      hintText: "Filter by Name/Username/Email"),
                                  onChanged: (value) {
                                    filterFriends(value);
                                  },
                                ),
                              ),
                              ...filteredFriends.map((user) {
                                return SizedBox(
                                    width: double.maxFinite,
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListTransactions(username: user["username"] ?? "")));
                                        },
                                        child: User(user["username"]!, user["firstName"]!, user["lastName"]!,
                                            user["email"]!, user["avatar"]!)));
                              }).toList()
                            ];
                          }
                        }()))));
        }));
  }
}
