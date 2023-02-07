import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctofTotal;

  const ChartBar({
    super.key,
    required this.label,
    required this.spendingAmount,
    required this.spendingPctofTotal,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Column(
          children: [
            Container(
              height: constraint.maxHeight * 0.15,
              child: FittedBox(
                child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
              ),
            ),
            SizedBox(
              height: constraint.maxHeight * 0.05,
            ),
            Container(
              height: constraint.maxHeight * 0.6,
              width: 20,
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctofTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              ]),
            ),
            SizedBox(
              height: constraint.maxHeight * 0.05,
            ),
            Container(
              height: constraint.maxHeight * 0.15,
              child: FittedBox(
                child: Text(label),
              ),
            )
          ],
        );
      },
    );
  }
}
