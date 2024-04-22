
import 'package:financify/security/firebase-budget-service/firebase-budget.dart';
import 'package:flutter/material.dart';

import '../entities/Budget.dart';
import 'AddExpenseModal.dart';

class ViewBudgetAndExpensesModal extends StatelessWidget {
  final Budget budget;
  final FireBaseBudgetService budgetService = FireBaseBudgetService();

  ViewBudgetAndExpensesModal({super.key, required this.budget});

  void openAddExpenseModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AddExpenseModal().build(context, budget);
        });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(30),
      scrollable: false,
      title: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            border: Border.all(
                width: 1, color: Theme.of(context).colorScheme.onSurface),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(budget.name.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 20)
          )
      ),
      content: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.5,
        constraints: const BoxConstraints(maxHeight: 900, maxWidth: 900),
        child: Column(
          children: [
            SingleChildScrollView(
            child: Column(
                children: <Widget>[
              Text('Amount: ${budget.amount}'),
              Text('Start Date: ${budget.startDate}'),
              Text('End Date: ${budget.endDate}'),
              const Text('Expenses:'),
              FutureBuilder(
                future: budgetService.getExpensesByBudgetId(budget.id),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    final expenses = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: expenses.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.onSurface),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ListTile(
                            title: Text(expenses[index].title),
                            subtitle: Text(expenses[index].amount.toString()),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ]),
                  ),
            Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      child: Text(
                        'Delete budget',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      onPressed: () => {
                        FireBaseBudgetService()
                            .deleteBudget(budget.id),
                        Navigator.of(context).pop()
                      },
                    ),
                    ElevatedButton(
                      child: Text(
                        'Close',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
    ),
    ),
    );
  }
}
