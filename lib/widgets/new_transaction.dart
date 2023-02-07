import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction({super.key, required this.addTransaction});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty ||
        enteredAmount.isNaN ||
        enteredAmount.isNegative ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      return;
    }
    widget.addTransaction(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime(2030))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textFactor = MediaQuery.of(context).textScaleFactor;
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10.0,
            top: 10.0,
            left: 10.0,
            right: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "Amount",
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate as DateTime)}',
                        style: TextStyle(
                          fontSize: 16 * textFactor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      style: TextButton.styleFrom(
                          textStyle: TextStyle(
                        fontSize: 16 * textFactor,
                        fontWeight: FontWeight.bold,
                      )),
                      child: const Text('Choose Date'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 0,
                ),
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.background,
                      backgroundColor: Theme.of(context).colorScheme.primary),
                  child: const Text("Confirm"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
