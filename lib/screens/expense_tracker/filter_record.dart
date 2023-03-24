import 'package:flutter/material.dart';

class FilterRecord extends StatefulWidget {
  final Function(Map) filterTransaction;
  final Map filters;

  const FilterRecord({Key? key, required this.filters, required this.filterTransaction}) : super(key: key);
  FilterRecordState createState() => FilterRecordState(filters, filterTransaction);
}

class FilterRecordState extends State<FilterRecord> {
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

  List<String> transactionTypes = ["All", "Income", "Expense"];

  FilterRecordState(this.filters, this.filterTransaction);

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
            child: Column(children: [
              Text("Transaction Type"),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: filters["type"],
                onChanged: (String? value) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  ElevatedButton(onPressed: submitFilter, child: const Text("Submit")),
                ],
              )
            ])));
  }
}
