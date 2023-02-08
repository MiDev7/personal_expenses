import 'package:expenses_planner/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  const Chart({super.key, required this.recentTransaction});

  List<Map<String, dynamic>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.00;

      for (var transaction in recentTransaction) {
        if (transaction.date.day == weekDay.day &&
            transaction.date.month == weekDay.month &&
            transaction.date.year == weekDay.year) {
          totalSum += transaction.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        margin: const EdgeInsets.all(15),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: groupedTransactionValues.map((tx) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    label: tx['day'],
                    spendingAmount: tx['amount'],
                    spendingPctofTotal:
                        maxSpending == 0.0 ? 0.0 : tx['amount'] / maxSpending),
              );
            }).toList(),
          ),
        ));
  }
}
