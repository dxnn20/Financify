import 'package:financify/security/user-auth/firebase-auth/firebase-auth-services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SetBudgetGoalModal extends StatelessWidget {
  final TextEditingController goalController = TextEditingController();

  SetBudgetGoalModal(BuildContext context, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Budget Goal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: goalController,
            decoration: const InputDecoration(labelText: 'Goal'),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Save',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          onPressed: () {
            FireBaseAuthService auth = FireBaseAuthService();

            auth.setBudgetGoal(double.parse(goalController.text)).then((value) {
              print('Budget goal set successfully');
            }).catchError((error) {
              print('Error: $error');
            });

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
