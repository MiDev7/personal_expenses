import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_item.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.deleteTx,
  });

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraint) {
            return SizedBox(
              height: constraint.maxHeight * 0.6,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    margin: const EdgeInsets.all(30.0),
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: ((context, index) {
              return TransactionItem(
                  transaction: transactions[index], deleteTx: deleteTx);
            }),
          );
  }
}
