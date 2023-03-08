import 'package:flutter/material.dart';

class FilterTransaction extends StatefulWidget {
  final Function(Map) filterTransaction;
  final Map filters;

  const FilterTransaction({Key? key, required this.filters, required this.filterTransaction}) : super(key: key);
  FilterTransactionState createState() => FilterTransactionState(filters, filterTransaction);
}

class FilterTransactionState extends State<FilterTransaction> {
  final Function(Map) filterTransaction;
  final Map filters;
  List<Map<String, String?>> transactions = [];

  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();
  final _amountController = TextEditingController();

  String amount = "";
  bool isDebit = true;
  final String username = "";
  bool isLoading = false;
  bool showForm = false;

  List<String> transactionTypes = ["All", "Credit", "Debit"];
  List<String> verificationTypes = ["All", "Verified", "Unverified"];

  FilterTransactionState(this.filters, this.filterTransaction);

  void _onRemarksChange(String text) {
    setState(() {
      amount = text;
    });
  }

  void submitFilter() {
    filterTransaction(filters);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        scrollable: true,
        title: const Text("Filter"),
        content: Padding(
            padding: const EdgeInsets.all(6.5),
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Transaction Type"),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: filters["type"],
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        filters["type"] = value!;
                      });
                    },
                    items: transactionTypes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text("Verification Status"),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: filters["verification"],
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        filters["verification"] = value!;
                      });
                    },
                    items: verificationTypes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: submitFilter, child: const Text("Submit")),
                      ElevatedButton(
                          onPressed: () {
                            print("close it");
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"))
                    ],
                  )
                ])));
  }
}
