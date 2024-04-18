import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'package:firebase_core/firebase_core.dart';

import '../user-auth/firebase-auth/firebase-auth-services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    final FireBaseAuthService _auth = FireBaseAuthService();

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    void _login(){
      if(emailController.text.isEmpty || passwordController.text.isEmpty){
        return;
      }

      _auth.signInWithEmailAndPassword(emailController.text, passwordController.text).then((value) {
        Navigator.pushNamed(context, '/home');
        print('User signed in successfully');
      }).catchError((error) {
        print('Error: $error');
      });
    }

    options:
    return Scaffold(
      body: Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/media/1x/login-bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
          Center(
            child: Container(
              width: 300,
              margin: const EdgeInsets.only(bottom: 20),
              height: 100,
              decoration: BoxDecoration(
                color: Pallete.pallete[50],
                borderRadius: BorderRadius.all(Radius.circular(20)
                ),
              ),
              child: Center(
                child: const Text(
                  'Financify',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                color: Pallete.pallete,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Pallete.pallete,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Pallete.pallete[200],
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
                      _login();
                    },
                    child: const Text('Login'
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text('Or Register', style: TextStyle(color: Pallete.pallete[200])),
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}