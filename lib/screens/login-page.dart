import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

import '/security/user-auth/firebase-auth/firebase-auth-services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? user = FirebaseAuth.instance.currentUser;

  String? _email;
  String? _password;

  String? err;

  @override
  Widget build(BuildContext context) {
    final FireBaseAuthService auth = FireBaseAuthService();

    final _formKey = GlobalKey<FormState>();

    void login() {
      if (_email!.isEmpty || _password!.isEmpty) {
        return;
      }

      auth.signInWithEmailAndPassword(_email!, _password!).then((value) {
        Navigator.pushNamed(context, '/home');
      }).catchError((onError) {
        setState(() {
          err = 'Invalid email or password';
        });
      });
    }

    @override
    void initState() {
      // Listen to changes in the authentication state
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          user = user;
        });
      });
    }

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

            // Theme toggle button container
            child: Container(
                margin: const EdgeInsets.all(50),
                child: IconButton(
                  onPressed: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                  icon: const Icon(Icons.sunny),
                )),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      width: 300,
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.background,
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Form(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.disabled,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildEmailForm(),
                                  const SizedBox(height: 20),
                                  _buildPasswordForm(),
                                  const SizedBox(height: 20),
                                  if (err != null)
                                    Text(
                                      '$err',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error,
                                      ),
                                    ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        login();
                                      }
                                      ;
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text('No Account?'),
                                  const SizedBox(height: 10),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/register');
                                      },
                                      child: Text('Register',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                          ))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
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

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Widget _buildPasswordForm() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
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
}
