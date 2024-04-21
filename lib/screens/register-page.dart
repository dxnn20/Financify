import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:financify/screens/login-page.dart';
import 'package:firebase_core/firebase_core.dart';

import '/security/user-auth/firebase-auth/firebase-auth-services.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FireBaseAuthService _auth = FireBaseAuthService();

  void _signUp(){

    if(emailController.text.isEmpty || usernameController.text.isEmpty || passwordController.text.isEmpty){
      return;
    }else if (passwordController.text.length < 6){
      return;
    }

    _auth.signUpWithEmailAndPassword(emailController.text, passwordController.text, usernameController.text).then((value) {
      Navigator.pushNamed(context, '/login');
      print('User signed up successfully');
    }).catchError((error) {
      print('Error: $error');
    });
  }

  bool _validateEmail(){
    if(emailController.text.isEmpty || !emailController.text.contains('@') || !emailController.text.contains('.')){
      return false;
    }
    return true;
  }

  bool _validateUsername(){
    if(usernameController.text.isEmpty){
      return false;
    }
    return true;
  }

  bool _validatePassword(){
    if(passwordController.text.isEmpty || passwordController.text.length < 6){
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(
          //   // child: Container(
          //   //   decoration: const BoxDecoration(
          //   //     image: DecorationImage(
          //   //       image: AssetImage("assets/media/1x/login-bg.png"),
          //   //       fit: BoxFit.cover,
          //   //     ),
          //   //   ),
          //   // ),
          // ),
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
              margin: const EdgeInsets.only(bottom: 20),
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)
                ),
              ),
            ),
          ),
          Center(
              child: Container(
                width: 300,
                height: 430,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Sign up',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        //errorText: 'Password must be at least 6 characters',
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        _signUp();
                      },
                      child: Text('Sign up!',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                        )
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text('Or Login',
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
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