import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financify/security/firebase-budget-service/firebase-budget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../entities/Budget.dart';
import '/security/user-auth/firebase-auth/firebase-auth-services.dart';

class AddBudgetModal extends StatelessWidget {
  const AddBudgetModal({super.key});

  @override
  Widget build(BuildContext context) {
    FireBaseAuthService auth = FireBaseAuthService();
    FireBaseBudgetService budgetService = FireBaseBudgetService();

    var budgetNameController = TextEditingController();
    var amountController = TextEditingController();
    var startDateController = TextEditingController();
    var endDateController = TextEditingController();

    String? err;

    addBudget() async {
      try {
        User? user = auth.getCurrentUser();

        if (user == null) {
          throw Exception('User not logged in');
        }

        if (budgetNameController.text.isEmpty ||
            amountController.text.isEmpty) {
          throw Exception('Fields cannot be empty');
        }

        CollectionReference budgets =
            FirebaseFirestore.instance.collection('budgets');

        Budget budget = Budget(
          userId: user.uid,
          name: budgetNameController.text,
          amount: double.parse(amountController.text),
          startDate: startDateController.text.isEmpty
              ? DateTime.now().toString()
              : startDateController.text,
          endDate: endDateController.text.isEmpty
              ? DateTime.now().toString()
              : endDateController.text,
          id: const Uuid().v4(),
        );

        await budgetService.addBudget(budget);
      } catch (e) {
        print(e);
      }
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: budgetNameController,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            decoration: InputDecoration(
              labelText: 'Budget Name',
              labelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: amountController,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                ),
            decoration: InputDecoration(
              errorText: err,
              labelText: 'Amount',
              labelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: startDateController,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            decoration: InputDecoration(
              labelText: 'Start Date',
              labelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: endDateController,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            decoration: InputDecoration(
              labelText: 'End Date',
              labelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 50.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {

              if(budgetNameController.text.isEmpty || amountController.text.isEmpty || num.tryParse(amountController.text) == null){
                err = 'Invalid amount';
                return;
              }

              addBudget();
              ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                content: Text(
                  'Budget added successfully',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ));
              Navigator.pop(context); // Close the modal
            },
            child: Text(
              'Add Budget',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
