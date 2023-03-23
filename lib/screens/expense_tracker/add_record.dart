import 'package:flutter/material.dart';
import 'package:ekhata/services/tracker_service.dart';

class AddRecord extends StatefulWidget {
  final String username;
  final Function(Map<String, dynamic>) appendTransaction;

  const AddRecord({Key? key, required this.username, required this.appendTransaction}) : super(key: key);
  AddRecordState createState() => AddRecordState(username, appendTransaction);
}

class AddRecordState extends State<AddRecord> {
  final Function(Map<String, dynamic>) appendTransaction;
  List<Map<String, String?>> transactions = [];

  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();
  final _amountController = TextEditingController();

  String amount = "";
  String remarks = "";
  bool isDebit = false;
  final String username;
  bool isLoading = false;
  bool showForm = false;

  final List<String> incomeCategories = ["Salary", "Vettako Paisa"];
  String incomeCategory = "Salary";
  final List<String> expenseCategories = ["Food", "Utility"];
  String expenseCategory = "Food";

  AddRecordState(this.username, this.appendTransaction);

  void _onRemarksChange(String text) {
    setState(() {
      remarks = text;
    });
    print(text);
  }

  void _onAmountChange(String text) {
    setState(() {
      amount = text;
    });
  }

  void submitTransaction() {
    if (_formKey.currentState!.validate()) {
      addTransaction();
    }
  }

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

  Future<void> addTransaction() async {
    setState(() {
      isLoading = true;
    });
    try {
      double amt = double.parse(amount);
      final response = await TrackerService.addRecord(
        category: isDebit ? expenseCategory : incomeCategory,
        amount: amt,
        description: remarks,
        type: isDebit ? "Expense" : "Income",
      );
      print(response);

      if (response[0] == true) {
        setState(() {
          appendTransaction(response[1]);
        });
      } else {
        showSnackBar(false, response[1][0]);
      }
      Navigator.pop(context);
    } catch (err) {
      print(err);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // scrollable: true,
        appBar: AppBar(title: Text("New Record")),
        body: Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    onChanged: this._onAmountChange,
                    decoration: InputDecoration(hintText: 'Amount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Amount is required";
                      }
                    },
                  ),
                  TextFormField(
                    controller: _remarksController,
                    onChanged: this._onRemarksChange,
                    decoration: InputDecoration(hintText: 'Remarks'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Remarks is required";
                      }
                    },
                  ),
                  ListTile(
                      title: const Text("Income"),
                      leading: Radio<bool>(
                          value: false,
                          groupValue: isDebit,
                          onChanged: (val) {
                            setState(() {
                              isDebit = val ?? true;
                            });
                          })),
                  ListTile(
                      title: const Text("Expense"),
                      leading: Radio<bool>(
                          value: true,
                          groupValue: isDebit,
                          onChanged: (val) {
                            setState(() {
                              isDebit = val ?? false;
                            });
                          })),
                  Row(children: [
                    const Text("Category: "),
                    isDebit
                        ? DropdownButton<String>(
                            value: expenseCategory,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                expenseCategory = value!;
                              });
                            },
                            items: expenseCategories.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        : DropdownButton<String>(
                            value: incomeCategory,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                incomeCategory = value!;
                              });
                            },
                            items: incomeCategories.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: isLoading ? null : submitTransaction, child: const Text("Submit")),
                      ElevatedButton(
                          onPressed: () {
                            print("close it");
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"))
                    ],
                  )
                ]))));
  }
}
