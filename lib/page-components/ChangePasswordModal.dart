import 'package:financify/security/user-auth/firebase-auth/firebase-auth-services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePasswordModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordConfirmController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    validatePassword(String password){
      if(password.length < 6){
        return 'Password must be at least 6 characters';
      }
      return null;
    }

    _validateConfirmPassword(String password, String confirmPassword){
      if(password != confirmPassword){
        return 'Passwords do not match';
      }
      return null;
    }

    return AlertDialog(
      title: const Text('Change Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Current Password',
            errorText: validatePassword(currentPasswordController.text)
            ),
            controller: currentPasswordController,
          ),
          TextFormField(
            controller: newPasswordController,
            decoration: const InputDecoration(labelText: 'New Password'),
          ),
          TextFormField(
            controller: newPasswordConfirmController,
            decoration: const InputDecoration(labelText: 'Confirm New Password'),
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
            if(validatePassword(newPasswordController.text) != null){
              return;
            }
            if(newPasswordController.text != newPasswordConfirmController.text){
              return;
            }
            if(FireBaseAuthService().getCurrentUser()?.updatePassword(newPasswordController.text) != null)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password changed successfully',
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