import 'package:flutter/material.dart';
import 'package:ekhata/services/tracker_service.dart';

class AddRecord extends StatefulWidget {
  final Function() appendTransaction;

  const AddRecord({Key? key, required this.appendTransaction}) : super(key: key);
  AddRecordState createState() => AddRecordState(appendTransaction);
}

class AddRecordState extends State<AddRecord> {
  final Function() appendTransaction;
  List<Map<String, String?>> transactions = [];

  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();
  final _amountController = TextEditingController();

  String amount = "";
  String remarks = "";
  bool isDebit = false;
  bool isLoading = false;
  bool showForm = false;

  final List<String> incomeCategories = ["Salary", "Bonus", "Commission", "Other"];
  String incomeCategory = "Salary";
  final List<String> expenseCategories = ["Food", "Beverage", "Lend/Borrow", "Entertainment", "Utility", "Other"];
  String expenseCategory = "Food";

  AddRecordState(this.appendTransaction);

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
          appendTransaction();
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
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(25),
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            onChanged: this._onAmountChange,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                              focusedBorder: OutlineInputBorder(),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Amount is required";
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _remarksController,
                            onChanged: this._onRemarksChange,
                            decoration: InputDecoration(
                              labelText: 'Remarks',
                              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                              focusedBorder: OutlineInputBorder(),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Remarks is required";
                              }
                            },
                          ),
                          SizedBox(height: 30),
                          Text("Record Type: ", style: TextStyle(fontSize: 16)),
                          ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
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
                              contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              title: const Text("Expense"),
                              leading: Radio<bool>(
                                  value: true,
                                  groupValue: isDebit,
                                  onChanged: (val) {
                                    setState(() {
                                      isDebit = val ?? false;
                                    });
                                  })),
                          SizedBox(height: 30),
                          Container(
                            child: Row(children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: isDebit
                                      ? DropdownButtonFormField<String>(
                                          value: expenseCategory,
                                          elevation: 16,
                                          decoration: InputDecoration(
                                            labelText: 'Category',
                                            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                                            focusedBorder: OutlineInputBorder(),
                                            border: OutlineInputBorder(),
                                            enabledBorder: OutlineInputBorder(),
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
                                      : DropdownButtonFormField<String>(
                                          value: incomeCategory,
                                          decoration: InputDecoration(
                                            labelText: 'Category',
                                            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                                            focusedBorder: OutlineInputBorder(),
                                            border: OutlineInputBorder(),
                                            enabledBorder: OutlineInputBorder(),
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
                                        )),
                            ]),
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(25, 15, 25, 15))),
                                  onPressed: () {
                                    print("close it");
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel")),
                              ElevatedButton(
                                onPressed: isLoading ? null : submitTransaction,
                                child: const Text("Submit"),
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(25, 15, 25, 15))),
                              ),
                            ],
                          )
                        ]))))));
  }
}
