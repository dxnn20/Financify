import 'package:financify/entities/Budget.dart';
import 'package:financify/security/user-auth/firebase-auth/firebase-auth-services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../entities/Expense.dart';
import '../security/firebase-budget-service/firebase-budget.dart';
import '../security/firebase-expense-service/firebase-expense.dart';

class AddExpenseModal{
  static final FireBaseAuthService _auth = FireBaseAuthService();
  static final expenseService = FireBaseExpenseService();
  static final budgetService = FireBaseBudgetService();

  static final expenseTitleController = TextEditingController();
  var  expenseAmountController = TextEditingController();
  static final expenseDateController = TextEditingController();
  static final expenseCategoryController = TextEditingController();
  static final expenseDescriptionController = TextEditingController();

  void addExpense(Budget budget){
    try{

      print('expenseTitleController.text: ${expenseTitleController.text}');
      print('expenseAmountController.text: ${expenseAmountController.text}');

      if(expenseTitleController.text.isEmpty || expenseAmountController.text.isEmpty ){
        throw Exception('All fields are required');
      }

      Expense expense = Expense(
        userId: '',
        title: expenseTitleController.text,
        amount: double.parse(expenseAmountController.text),
        date: expenseDateController.text.isEmpty ? expenseDateController.text : DateTime.now().toString(),
        category: expenseCategoryController.text.isEmpty ? expenseCategoryController.text : 'Miscellaneous',
        description: expenseDescriptionController.text.isEmpty ? expenseDescriptionController.text : 'A simple expense',
        budgetId: budgetService.budgetId,
        id: budgetService.budgetId,
      );

      expenseService.addExpense(expense, budget);
      print('Expense added successfully!');
      print('Expense Name: ${expenseTitleController.text}');
      print('Amount: ${expenseAmountController.text}');
      print('Date: ${expenseDateController.text}');
      print('Category: ${expenseCategoryController.text}');
      print('Description: ${expenseDescriptionController.text}');

    }catch(e){
      print(e);
    }
  }

  Widget build(BuildContext context, Budget budget){
    return AlertDialog(
      title: Text('Add Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: expenseTitleController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: expenseAmountController,
            decoration: InputDecoration(labelText: 'Amount'),
          ),
          TextField(
            controller: expenseDateController,
            decoration: InputDecoration(labelText: 'Date'),
          ),
          TextField(
            controller: expenseCategoryController,
            decoration: InputDecoration(labelText: 'Category'),
          ),
          TextField(
            controller: expenseDescriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text(
            'Save',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          onPressed: () {
            addExpense(budget);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}