import 'package:financify/security/firebase-budget-service/firebase-budget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entities/Budget.dart';

class ModifyBudgetModal {
  static final FireBaseBudgetService _budgetService = FireBaseBudgetService();

  static Widget build(BuildContext context, Budget budget) {
    return AlertDialog(
      title: Text('Modify Budget'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: TextEditingController(text: budget.name),
            decoration: InputDecoration(labelText: 'Name'),
            onChanged: (text) => budget.name = text,
          ),
          TextField(
            controller: TextEditingController(text: budget.amount.toString()),
            decoration: InputDecoration(labelText: 'Amount'),
            onChanged: (text) => budget.amount = double.parse(text),
          ),
        ],
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: null,
        child: ElevatedButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        GestureDetector(
          onTap: null,
        child: ElevatedButton(
          child: Text(
            'Save',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          onPressed: () {
            _budgetService.updateBudget(budget);
            Navigator.of(context).pop();
          },
        ),
        ),
      ],
    );
  }
}
