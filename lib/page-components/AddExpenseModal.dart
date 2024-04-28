import 'package:financify/entities/Budget.dart';
import 'package:financify/security/user-auth/firebase-auth/firebase-auth-services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entities/Expense.dart';
import '../security/firebase-budget-service/firebase-budget.dart';
import '../security/firebase-expense-service/firebase-expense.dart';

class AddExpenseModal {
  static final FireBaseAuthService _auth = FireBaseAuthService();
  static final expenseService = FireBaseExpenseService();
  static final budgetService = FireBaseBudgetService();

  final expenseTitleController = TextEditingController();
  var expenseAmountController = TextEditingController();
  final expenseDateController = TextEditingController();
  final expenseCategoryController = TextEditingController();
  final expenseDescriptionController = TextEditingController();

  void addExpense(Budget budget) {
    try {
      if (expenseTitleController.text.isEmpty ||
          expenseAmountController.text.isEmpty) {
        throw Exception('Fill in the required fields');
      }

      Expense expense = Expense(
        userId: '',
        title: expenseTitleController.text,
        amount: double.parse(expenseAmountController.text),
        date: expenseDateController.text.isEmpty
            ? expenseDateController.text
            : DateTime.now().toString(),
        category: expenseCategoryController.text.isEmpty
            ? expenseCategoryController.text
            : 'Miscellaneous',
        description: expenseDescriptionController.text.isEmpty
            ? expenseDescriptionController.text
            : 'A simple expense',
        budgetId: budgetService.budgetId,
        id: budgetService.budgetId,
      );

      expenseService.addExpense(expense, budget);
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context, Budget? budget) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    GlobalKey<FormFieldState> budgetTitleKey = GlobalKey<FormFieldState>();

    return AlertDialog(
      title: const Text('Add Expense'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          onChanged: () {
            Form.of(primaryFocus!.context!).save();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (budget == null)
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  key: budgetTitleKey,
                  decoration: const InputDecoration(labelText: 'Budget Title*'),
                ),
              TextFormField(
                controller: expenseTitleController,
                decoration: const InputDecoration(labelText: 'Expense Title'),
              ),
              TextFormField(
                controller: expenseAmountController,
                decoration: const InputDecoration(labelText: 'Amount*'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: expenseDateController,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
              TextField(
                controller: expenseCategoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: expenseDescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
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
          onPressed: () async {

            if(!formKey.currentState!.validate()){
              return;
            }
            if (budget != null) {
              addExpense(budget);
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                content: Text(
                  'Expense added successfully to existing budget with name "${budget.name}"',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ));

              return;
            }

            if (budget == null) {

              Budget? existingBudget = await budgetService.getBudgetByTitle(budgetTitleKey.currentState!.value);

              if(existingBudget != null){
                addExpense(existingBudget);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  content: Text(
                    'Expense added successfully to existing budget',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ));

                return;
              }
              else {

                Budget newBudget = Budget(
                  userId: _auth.getCurrentUser()!.uid,
                  startDate: DateTime.now().toString(),
                  endDate: DateTime.now().toString(),
                  name: budgetTitleKey.currentState!.value.toString(),
                  amount: double.parse(expenseAmountController.text),
                  id: budgetService.budgetId,
                );

                budgetService.addBudget(newBudget);
                addExpense(newBudget);

                ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  content: Text(
                    'Expense added successfully to new budget with name ${newBudget.name}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ));
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
