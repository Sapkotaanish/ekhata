import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/services/http_service.dart';
import 'package:ekhata/env/env.dart' as env;

class TransactionsList extends StatefulWidget {
  final String username;
  const TransactionsList({Key? key, required this.username}) : super(key: key);
  _TransactionsListState createState() => _TransactionsListState(username);
}

class _TransactionsListState extends State<TransactionsList> {
  List<Map<String, String?>> transactions = [];

  String email = "";
  String avatar = "";
  final String username;
  bool isLoading = true;

  _TransactionsListState(this.username);

  Future<void> getTransactions() async {
    print(username);
    final response = await HttpService.postReq(
        "${env.BACKEND_URL}/gettransactions/", {"username": username});
    // final data = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (data["success"] == "true" || data["success"]) {
        // setState(() {
        //   List<Map<String, String?>> temp = [];
        //   print(data["data"]);
        //   data["data"]?.forEach((user) {
        //     print(user);
        //     temp.add({
        //       "email": user["email"] ?? "",
        //       "username": user["username"] ?? "",
        //       "avatar": user["avatar"] ?? ""
        //     });
        //   });
        //   transactions = temp;
        // });
      }
      print(data);
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
    getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text("$username"),
              ),
              body: Center(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Column(
                          children: (() {
                          if (transactions.isEmpty) {
                            return [const Text("No transactions found.")];
                          } else {
                            return transactions.map((user) {
                              return Container(
                                  width: double.maxFinite,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      margin: EdgeInsets.only(),
                                      color: Colors.blue[50],
                                      child: Container(
                                          padding: EdgeInsets.all(10),
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
                                          ]))));
                            }).toList();
                          }
                        }()))));
        }));
  }
}
