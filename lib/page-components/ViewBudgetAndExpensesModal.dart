import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../entities/Budget.dart';
import '../entities/Expense.dart';

class ViewBudgetAndExpensesModal extends StatelessWidget {
  final Budget budget;

  ViewBudgetAndExpensesModal({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(30),
      scrollable: true,
      title: Text('Budget: ${budget.name}'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.5,
        constraints: const BoxConstraints(maxHeight: 900, maxWidth: 900),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Amount: ${budget.amount}'),
            Text('Start Date: ${budget.startDate}'),
            Text('End Date: ${budget.endDate}'),
            const Text('Expenses:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  child: Text(
                    'Add Expense',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text(
                    'Close',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}