import 'dart:convert';
import 'package:ekhata/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import 'package:ekhata/services/http_service.dart';
import 'package:ekhata/env/env.dart' as env;
import './add_transaction.dart';
import './filter_transaction.dart';
import 'package:intl/intl.dart';

class ListTransactions extends StatefulWidget {
  final String username;
  const ListTransactions({Key? key, required this.username}) : super(key: key);
  _ListTransactionsState createState() => _ListTransactionsState(username);
}

class _ListTransactionsState extends State<ListTransactions> {
  Map<int, String> weekdayName = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday"
  };

  List<Map<String, dynamic>> transactions = [];
  List<Map<String, dynamic>> filteredTransactions = [];
  Map filters = {"type": "All", "verification": "All"};

  String email = "";
  String myUsername = "";
  String avatar = "";
  final String username;
  bool isLoading = true;
  bool formOpened = false;
  bool isScrolled = false;

  ScrollController _scrollController = ScrollController();

  _ListTransactionsState(this.username);

  void appendTransaction(Map<String, dynamic> newTransaction) {
    setState(() {
      isLoading = true;
      getTransactions();
    });
  }

  String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  void filterTransaction(Map filters) {
    final test = transactions.where((element) {
      if (filters["type"] == "All") {
        return true;
      } else if (filters["type"] == "Credit") {
        return element["diney"] != email;
      }
      return element["diney"] == email;
    }).toList();
    setState(() {
      filteredTransactions = test.where((element) {
        if (filters["verification"] == "All") {
          return true;
        } else if (filters["verification"] == "Verified") {
          return element["isVerified"];
        }
        return !element["isVerified"];
      }).toList();
    });
  }

  Future<void> getTransactions([withProfile = true]) async {
    if (withProfile) {
      final StorageService _storageService = StorageService();
      final user = await _storageService.read('user');
      final userObj = jsonDecode(user ?? "");
      setState(() {
        email = userObj['email'] ?? "";
        avatar = userObj['avatar'] ?? "";
        myUsername = userObj['username'] ?? "";
      });
    }
    final response = await HttpService.postReq("${env.BACKEND_URL}/gettransactions/", {"username": username});
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"] == true) {
        List<Map<String, dynamic>> temp = [];
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
            "liney": transaction["liney"],
            "diney": transaction["diney"],
          });
        });

        setState(() {
          transactions = temp;
          filteredTransactions = temp;
        });
      }
    } else {
      print("Success false");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> verifyTransaction(int id) async {
    final response = await HttpService.postReq("${env.BACKEND_URL}/verifytransaction/", {"transaction_id": id});
    // final data = json.decode(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"] == true) {
        getTransactions(false);
      }
    } else {
      print("Success false");
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getTransactions();
  }

  void _scrollListener() {
    setState(() {
      isScrolled = _scrollController.position.pixels > 50 ? true : false;
    });
  }

  void showForm() {
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
                iconTheme: const IconThemeData(color: Colors.black),
                title: Text(isScrolled ? username : "", style: const TextStyle(color: Colors.white, fontSize: 18)),
                backgroundColor: isScrolled ? Theme.of(context).primaryColor : Colors.white,
                elevation: 0,
              ),
              floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  AddTransaction(username: username, appendTransaction: appendTransaction)));
                        },
                        child: const Icon(Icons.add))),
                FloatingActionButton.extended(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FilterTransaction(filters: filters, filterTransaction: filterTransaction);
                        });
                  },
                  label: const Text("Filter"),
                  icon: const Icon(Icons.filter_list_outlined),
                )
              ]),
              body: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                          children: (() {
                        if (transactions.isEmpty) {
                          return [
                            Container(
                                width: double.maxFinite,
                                color: Colors.white,
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: Column(
                                  children: [
                                    Text("Transaction History",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).primaryColor)),
                                    Text(username,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Theme.of(context).primaryColor))
                                  ],
                                )),
                            Center(
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height / 3, 0, 0),
                                    child: const Text("No transactions found.", style: TextStyle(fontSize: 16)))),
                          ];
                        } else {
                          String prevDate = "";
                          double remainingTransaction = 0;
                          List<Widget> widgets = [];

                          widgets.add(const SizedBox(height: 60));
                          for (int i = filteredTransactions.length - 1; i >= 0; i--) {
                            final transaction = filteredTransactions[i];
                            if (transaction["liney"] == email) {
                              remainingTransaction += double.parse(transaction["amount"]);
                            } else {
                              remainingTransaction -= double.parse(transaction["amount"]);
                            }
                            DateTime transactionTime = DateTime.parse(transaction["dateOfTransaction"].split('+')[0]);
                            widgets.insert(
                                0,
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  (() {
                                    String tran = transaction["dateOfTransaction"].toString().split('T')[0];
                                    String nextDate =
                                        i > 0 ? transactions[i - 1]["dateOfTransaction"].toString().split('T')[0] : "f";
                                    if (tran != nextDate) {
                                      return Padding(
                                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("$tran \n${weekdayName[transactionTime.weekday]}",
                                                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                                              Text(remainingTransaction.abs().toString(),
                                                  style: TextStyle(
                                                      color: remainingTransaction < 0 ? Colors.red : Colors.green,
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.w600)),
                                            ],
                                          ));
                                    } else {
                                      prevDate = tran;
                                      return const SizedBox();
                                    }
                                  }()),
                                  SizedBox(
                                      width: double.maxFinite,
                                      child: Card(
                                          shape: const RoundedRectangleBorder(
                                            side: BorderSide(color: Colors.grey, width: 0.3),
                                          ),
                                          margin: const EdgeInsets.only(),
                                          // color: Colors.grey[300],
                                          child: Container(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(children: [
                                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        FittedBox(
                                                            child: Container(
                                                          width: MediaQuery.of(context).size.width - 150,
                                                          child: Text(utf8convert(transaction["remarks"]),
                                                              style: const TextStyle(
                                                                  fontSize: 18.0, fontWeight: FontWeight.w500)),
                                                        )),
                                                        const SizedBox(height: 10),
                                                        Text(DateFormat("h:mm a").format(transactionTime),
                                                            style: const TextStyle(
                                                                color: Color(0xaa4c57cf),
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 12)),
                                                        Text(DateFormat("y MMM d").format(transactionTime),
                                                            style: const TextStyle(
                                                                color: Color(0xaa4c57cf),
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 12)),
                                                        const SizedBox(height: 10),
                                                        Text("Added By: ", style: TextStyle(color: Colors.grey[500])),
                                                        Text(transaction["addedBy"] == email ? myUsername : username,
                                                            style: TextStyle(color: Colors.grey[600])),
                                                      ]),
                                                  Column(children: [
                                                    Row(
                                                      children: [
                                                        Text(transaction["amount"].toString(),
                                                            style: TextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight: FontWeight.w500,
                                                                color: transaction["liney"] == email
                                                                    ? Colors.green
                                                                    : Colors.red)),
                                                        const SizedBox(width: 4),
                                                        transaction["liney"] == email
                                                            ? const Icon(Icons.arrow_circle_up_outlined,
                                                                color: Colors.green, size: 26.0)
                                                            : const Icon(Icons.arrow_circle_down_outlined,
                                                                color: Colors.red, size: 26.0),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6),
                                                    (() {
                                                      if (transaction["isVerified"]) {
                                                        return const Text("Verified");
                                                      } else {
                                                        if (transaction["addedBy"] == email) {
                                                          return const Text("Pending");
                                                        } else {
                                                          return ElevatedButton(
                                                              onPressed: () {
                                                                verifyTransaction(transaction["id"]);
                                                              },
                                                              child: const Text("Verify"));
                                                        }
                                                      }
                                                    }()),
                                                  ]),
                                                ]),
                                              ]))))
                                ]));
                          }

                          widgets.insert(
                              0,
                              Container(
                                  width: double.maxFinite,
                                  color: Colors.white,
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Column(
                                    children: [
                                      Text("Transaction History",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(context).primaryColor)),
                                      Text(username,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Theme.of(context).primaryColor))
                                    ],
                                  )));

                          return widgets;
                        }
                      }()))));
        }));
  }
}
