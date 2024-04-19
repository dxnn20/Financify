import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:firebase_core/firebase_core.dart';

import '../security/firebase-auth/firebase-auth-services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final FireBaseAuthService _auth = FireBaseAuthService();

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    void login() {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        return;
      }

      _auth
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        Navigator.pushNamed(context, '/home');
      }).catchError((error) {
        print('Error: $error');
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
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                  // image: DecorationImage(
                  //   image: AssetImage("assets/media/1x/login-bg.png"),
                  //   fit: BoxFit.cover,
                  // ),
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
                )),
          ),
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
          Center(
              child: Container(
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1,
                ),
              ),
              padding: const EdgeInsets.all(20),
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
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text('Or Register',
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
