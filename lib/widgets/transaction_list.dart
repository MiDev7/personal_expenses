import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList({
    super.key,
    required this.transactions,
    required this.deleteTx,
  });

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Container(
            height: 400,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  margin: EdgeInsets.all(30.0),
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
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: ((context, index) {
              return Container(
                height: 90,
                margin: EdgeInsets.symmetric(horizontal: 13.0, vertical: 3.0),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 05.0),
                    leading: Container(
                      height: 90,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          // shape: BoxShape.rectangle
                          borderRadius: BorderRadius.all(Radius.circular(9))),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: FittedBox(
                          child: Text(
                            '\$${transactions[index].amount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                    title: Text(transactions[index].title,
                        style: Theme.of(context).textTheme.titleLarge),
                    subtitle: Text(
                      DateFormat('EEE, yyyy-d-MM')
                          .format(transactions[index].date),
                      style: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).colorScheme.error,
                      iconSize: 30,
                      onPressed: () => deleteTx(transactions[index].id),
                    ),
                  ),
                ),
              );
            }),
          );
  }
}
