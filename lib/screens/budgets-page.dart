import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financify/main.dart';
import 'package:financify/screens/login-page.dart';

import '../security/firebase-auth/firebase-auth-services.dart';
import 'home-page.dart';

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage>{
  @override
  Widget build(BuildContext context) {
    final FireBaseAuthService _auth = FireBaseAuthService();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              margin: const EdgeInsets.only(right: 10, top: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_money),
                      onPressed: () {
                        Navigator.pushNamed(context, '/budgets');
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
                      },
                      icon: const Icon(Icons.sunny),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        _auth.signOut();
                        print('User signed out');
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ),
            ),

            Center(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text('Budgets Page'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
