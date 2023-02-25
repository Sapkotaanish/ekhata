import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/services/http_service.dart';
import 'package:ekhata/env/env.dart' as env;
import './add_transaction.dart';

class ListTransactions extends StatefulWidget {
  final String username;
  const ListTransactions({Key? key, required this.username}) : super(key: key);
  _ListTransactionsState createState() => _ListTransactionsState(username);
}

class _ListTransactionsState extends State<ListTransactions> {
  List<Map<String, dynamic?>> transactions = [];

  String email = "";
  String avatar = "";
  final String username;
  bool isLoading = true;
  bool formOpened = false;

  _ListTransactionsState(this.username);

  void appendTransaction(Map<String, dynamic> newTransaction) {
    print(newTransaction);
    setState(() {
      transactions = [newTransaction, ...transactions];
    });
  }

  Future<void> getTransactions() async {
    print(username);
    final response = await HttpService.postReq(
        "${env.BACKEND_URL}/gettransactions/", {"username": username});
    // final data = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (data["success"] == true) {
        List<Map<String, dynamic?>> temp = [];
        data["data"]?.forEach((transaction) {
          temp.add({
            "id": transaction["id"],
            "transaction_type": transaction["transaction_type"],
            "remarks": transaction["transaction_detail"],
            "addedBy": transaction["added_by"],
            "isVerified": transaction["is_verified"],
            "dateOfVerification": transaction["date_of_verification"],
            "dateOfTransaction": transaction["date_of_transaction"],
            "amount": transaction["amount"],
          });
        });

        setState(() {
          transactions = temp;
        });
      }
    } else {
      print("Success false");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> verifyTransaction() async {
    final response = await HttpService.postReq(
        "${env.BACKEND_URL}/verifytransaction/", {"username": username});
    // final data = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (data["success"] == true) {
        List<Map<String, dynamic?>> temp = [];
        data["data"]?.forEach((transaction) {
          temp.add({
            "id": transaction["id"],
            "transaction_type": transaction["transaction_type"],
            "remarks": transaction["transaction_detail"],
            "addedBy": transaction["added_by"],
            "isVerified": transaction["is_verified"],
            "dateOfVerification": transaction["date_of_verification"],
            "dateOfTransaction": transaction["date_of_transaction"],
            "amount": transaction["amount"],
          });
        });

        setState(() {
          transactions = temp;
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
    getTransactions();
  }

  void showForm() {
    print("show form");
    // showDialog(builder: )
    setState(() {
      formOpened = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text(username),
              ),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddTransaction(
                              username: username,
                              appendTransaction: appendTransaction);
                        });
                  },
                  child: const Icon(Icons.add)),
              body: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                          children: (() {
                      if (transactions.isEmpty) {
                        return [const Text("No transactions found.")];
                      } else {
                        return transactions.map((transaction) {
                          print(transaction);
                          return SizedBox(
                              width: double.maxFinite,
                              child: Card(
                                  shape: const RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  margin: const EdgeInsets.only(),
                                  color: transaction["transaction_type"] == "C"
                                      ? Colors.green[200]
                                      : Colors.red[200],
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(children: [
                                        const SizedBox(height: 15),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(transaction[
                                                            "remarks"] ??
                                                        ""),
                                                    Text(transaction["amount"]
                                                        .toString()),
                                                  ]),
                                              (() {
                                                if (transaction["isVerified"]) {
                                                  return const Text("Verified");
                                                } else {
                                                  return ElevatedButton(
                                                      onPressed: () {},
                                                      child:
                                                          const Text("Verify"));
                                                }
                                              }()),
                                            ]),
                                      ]))));
                        }).toList();
                      }
                    }()))));
        }));
  }
}
