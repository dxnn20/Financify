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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.account_balance_wallet,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      insetPadding: const EdgeInsets.all(50),
      title: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            budget.name.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      content: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          constraints: const BoxConstraints(maxHeight: 900, maxWidth: 900),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text('Amount: ${budget.amount}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
                const SizedBox(height: 5),
                Text('Start Date: ${budget.startDate}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
                const SizedBox(height: 5),
                Text('End Date: ${budget.endDate}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
                const SizedBox(height: 15),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Theme.of(context).colorScheme.onPrimary,
                  thickness: 5,
                ),
                Text(
                  'Expenses:',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                FutureBuilder(
                  future: budgetService.getExpensesByBudgetId(budget.id),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      final expenses = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: expenses.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurface,
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                expenses[index].title,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                expenses[index].amount.toString(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            FireBaseBudgetService().deleteBudget(budget.id);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(
            'Delete budget',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Close',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
