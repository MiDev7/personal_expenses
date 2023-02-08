import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.deleteTx,
  });

  final Transaction transaction;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 3.0),
      child: Card(
        elevation: 3,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 05.0),
          leading: Container(
            height: 90,
            width: 80,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                // shape: BoxShape.rectangle
                borderRadius: const BorderRadius.all(Radius.circular(9))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                child: Text(
                  '\$${transaction.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
          title: Text(transaction.title,
              style: Theme.of(context).textTheme.titleLarge),
          subtitle: Text(
            DateFormat('EEE, yyyy-d-MM').format(transaction.date),
            style: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),
          trailing: MediaQuery.of(context).size.width > 400
              ? TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () => deleteTx(transaction.id),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'))
              : IconButton(
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).colorScheme.error,
                  iconSize: 30,
                  onPressed: () => deleteTx(transaction.id),
                ),
        ),
      ),
    );
  }
}
