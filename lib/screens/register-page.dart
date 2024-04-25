import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

import '/security/user-auth/firebase-auth/firebase-auth-services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _username;
  String? _password;
  final FireBaseAuthService _auth = FireBaseAuthService();

  void _signUp() {
    if (_email!.isEmpty || _username!.isEmpty || _password!.isEmpty) {
      return;
    } else if (_password!.length < 6) {
      return;
    }

    _auth
        .signUpWithEmailAndPassword(_email!, _password!, _username!)
        .then((value) {
      Navigator.pushNamed(context, '/login');
      print('User signed up successfully');
    }).catchError((error) {
      print('Error: $error');
    });
  }

  bool _validateEmail() {
    if (_email!.isEmpty || !_email!.contains('@') || !_email!.contains('.')) {
      return false;
    }
    return true;
  }

  bool _validateUsername() {
    if (_username!.isEmpty) {
      return false;
    }
    return true;
  }

  bool _validatePassword() {
    if (_password == null || _password!.length < 6) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              child: const Text(
                'Financify',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.all(50),
              child: IconButton(
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
                icon: const Icon(Icons.sunny),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Center(
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      children: [


                        Center(
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).hintColor,
                                  blurRadius: 15,
                                  offset: const Offset(10, 10),
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _buildEmailForm(),
                                SizedBox(height: 16),
                                _buildUsernameForm(),
                                SizedBox(height: 16),
                                _buildPasswordForm(),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      print('Valid email: $_email');
                                      print('Valid username: $_username');
                                      print('Valid password: $_password');
                                      _signUp();
                                    }



                                  },
                                  child: Text('Submit',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.background,
                                      )),
                                ),
                                SizedBox(height: 16),
                                Text('Have an account?'),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: Text('Login'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildEmailForm() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email'; // Error message for empty input
        }
        if (!isValidEmail(value)) {
          return 'Please enter a valid email'; // Error message for invalid email pattern
        }
        return null; // Return null if input is valid
      },
      onChanged: (value) {
        _email = value;
      },
    );
  }

  Widget _buildUsernameForm() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Username',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your username'; // Error message for empty input
        }
        return null; // Return null if input is valid
      },
      onChanged: (value) {
        _username = value;
      },
    );
  }

  Widget _buildPasswordForm() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      obscureText: true, // Hide password text
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password'; // Error message for empty input
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters long'; // Error message for password length
        }
        return null; // Return null if input is valid
      },
      onChanged: (value) {
        _password = value;
      },
    );
  }


  bool isValidEmail(String email) {
    // Use RegExp to match email pattern
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}