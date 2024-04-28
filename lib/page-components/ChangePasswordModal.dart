import 'package:financify/security/user-auth/firebase-auth/firebase-auth-services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var formFieldKey = GlobalKey<FormFieldState>();

    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordConfirmController =
        TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    validatePassword(String password) {
      if (password.length < 6) {
        return 'Password must be at least 6 characters';
      }
      return null;
    }

    return AlertDialog(
      title: const Text('Change Password'),
      content: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Current Password',),
              controller: currentPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (validatePassword(value) != null) {
                  return 'Password must be at least 6 characters';
                }

                return null;
              },
            ),
            TextFormField(
              obscureText: true,
              key: formFieldKey,
              controller: newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (validatePassword(value) != null) {
                  return 'Password must be at least 6 characters';
                }

                return null;
              },
            ),
            TextFormField(
              obscureText: true,
              controller: newPasswordConfirmController,
              decoration:
                  const InputDecoration(labelText: 'Confirm New Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if(validatePassword(value) != null){
                  return 'Password must be at least 6 characters';
                }

                if (value != formFieldKey.currentState!.value) {
                  return 'Passwords do not match';
                }

                return null;
              }
            ),
          ],
        ),
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
          child: Text(
            'Save',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          onPressed: () {

            if(formKey.currentState?.validate() == false){
              return;
            }

            if (validatePassword(newPasswordController.text) != null) {
              return;
            }
            if (newPasswordController.text !=
                newPasswordConfirmController.text) {
              return;
            }
            if (FireBaseAuthService()
                    .getCurrentUser()
                    ?.updatePassword(newPasswordController.text) !=
                null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Password changed successfully',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
