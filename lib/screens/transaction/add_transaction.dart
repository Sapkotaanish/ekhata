import 'package:flutter/material.dart';
import 'package:ekhata/services/transaction_service.dart';

class AddTransaction extends StatefulWidget {
  final String username;
  final Function(Map<String, dynamic>) appendTransaction;

  const AddTransaction(
      {Key? key, required this.username, required this.appendTransaction})
      : super(key: key);
  AddTransactionState createState() =>
      AddTransactionState(username, appendTransaction);
}

class AddTransactionState extends State<AddTransaction> {
  final Function(Map<String, dynamic>) appendTransaction;
  List<Map<String, String?>> transactions = [];

  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();
  final _amountController = TextEditingController();

  String amount = "";
  String remarks = "";
  bool isDebit = true;
  final String username;
  bool isLoading = false;
  bool showForm = false;

  AddTransactionState(this.username, this.appendTransaction);

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
      // context.read<LoginBloc>().add(
      //     LoginRequestEvent(_emailController.text, _passwordController.text));
    }
  }

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

  Future<void> addTransaction() async {
    setState(() {
      isLoading = true;
    });
    try {
      double amt = double.parse(amount);
      final response = await TransactionService.addTransaction(
        to_transaction_with: username,
        transaction_type: isDebit ? "D" : "C",
        amount: amt,
        transaction_detail: remarks,
      );

      if (response[0] == true) {
        setState(() {
          appendTransaction(response[1]);
        });
      } else {
        showSnackBar(false, response[1]);
      }
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        scrollable: true,
        title: const Text("New Transaction"),
        content: Padding(
            padding: const EdgeInsets.all(6.5),
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
                      title: const Text("Debit"),
                      leading: Radio<bool>(
                          value: true,
                          groupValue: isDebit,
                          onChanged: (val) {
                            setState(() {
                              isDebit = val ?? true;
                            });
                          })),
                  ListTile(
                      title: const Text("Credit"),
                      leading: Radio<bool>(
                          value: false,
                          groupValue: isDebit,
                          onChanged: (val) {
                            setState(() {
                              isDebit = val ?? false;
                            });
                          })),
                  ElevatedButton(
                      onPressed: isLoading ? null : submitTransaction,
                      child: const Text("Submit")),
                  ElevatedButton(
                      onPressed: () {
                        print("close it");
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"))
                ]))));
  }
}
