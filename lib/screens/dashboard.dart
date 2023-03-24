import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import './chart.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import '../services/storage_service.dart';
import '../services/dashboard.dart';
import 'user/profile.dart';
import 'search.dart';
import './transaction/transactions_list.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String avatar = "";
  String email = "";
  String firstName = "";
  String lastName = "";
  String username = "...";
  String toTake = "";
  String toGive = "";

  List<Map<String, dynamic>> transactions = [];

  Future<void> getUser() async {
    final StorageService _storageService = StorageService();
    final user = await _storageService.read('user');
    final userObj = jsonDecode(user ?? "");
    setState(() {
      email = userObj['email'] ?? "";
      username = userObj['username'] ?? "";
      avatar = userObj['avatar'] ?? "";
      firstName = userObj['firstName'] ?? "";
      lastName = userObj['lastName'] ?? "";
    });
  }

  Future<void> getData() async {
    List response = await DashboardService.getDashboard();
    if (response[0] == true) {
      List<dynamic> trans = response[1];
      List<Map<String, dynamic>> temp = [];
      double take = 0;
      double give = 0;
      trans.forEach((transaction) {
        if (transaction["amount"] > 0) {
          take += transaction["amount"];
        } else {
          give += transaction["amount"];
        }
        temp.add({
          "email": transaction["email"] ?? "",
          "username": transaction["username"] ?? "",
          "avatar": transaction["avatar"] ?? "",
          "amount": transaction["amount"] ?? "",
          "firstName": transaction["first_name"] ?? "",
          "lastName": transaction["last_name"] ?? "",
        });
      });
      setState(() {
        toTake = take.toString();
        toGive = give.abs().toString();
        transactions = temp;
      });
    } else {
      // showSnackBar(false);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                  title: Text("Dashboard", style: TextStyle(color: Theme.of(context).primaryColor)),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Search()),
                          );
                        },
                        child: Padding(
                            padding: EdgeInsets.only(right: 18.0), child: Icon(Icons.search, color: Colors.black))),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Profile()),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(avatar),
                          backgroundColor: Colors.brown.shade800,
                        ))
                  ]),
              body: SingleChildScrollView(
                  child: Column(children: [
                SizedBox(height: 20),
                Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Colors.black,
                      width: 2.0, // This would be the width of the underline
                    ))),
                    child: Text("My Stats",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ))),
                SizedBox(height: 20),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(14),
                        child: Card(
                            child: Container(
                                child: Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(15),
                                color: Colors.green,
                                child: Row(
                                  children: const [
                                    Icon(Icons.south_west_outlined, color: Colors.white),
                                    Text("  To Receive", style: TextStyle(color: Colors.white, fontSize: 15)),
                                  ],
                                )),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                const SizedBox(height: 15),
                                Text("Rs. $toTake",
                                    style: const TextStyle(
                                        color: Colors.green, fontSize: 20, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 15),
                              ],
                            )
                          ],
                        )))),
                    Padding(
                        padding: const EdgeInsets.all(14),
                        child: Card(
                            child: Container(
                                child: Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                                color: Colors.red,
                                child: Row(
                                  children: const [
                                    Icon(Icons.north_east, color: Colors.white),
                                    Text("   To Give", style: TextStyle(color: Colors.white, fontSize: 15)),
                                  ],
                                )),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                const SizedBox(height: 15),
                                Text("Rs. $toGive",
                                    style:
                                        const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 15),
                              ],
                            )
                          ],
                        ))))
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ))),
                  child: const Text("Latest Transactions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: transactions.map((transaction) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListTransactions(username: transaction["username"])),
                              );
                            },
                            child: Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(transaction["firstName"] + " " + transaction["lastName"],
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                            Text(transaction["username"],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Rs. ${transaction["amount"].abs().toString()}",
                                                style: TextStyle(
                                                    color: transaction["amount"] < 0 ? Colors.red : Colors.green,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600)),
                                            Icon(transaction["amount"] < 0 ? Icons.arrow_downward : Icons.arrow_upward,
                                                color: transaction["amount"] < 0 ? Colors.red : Colors.green)
                                          ],
                                        )
                                      ],
                                    )))));
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Chart(),
              ])));
        }));
  }
}
