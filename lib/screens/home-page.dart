import 'package:financify/main.dart';
import 'package:financify/security/firebase-budget-service/firebase-budget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../page-components/AddBudgetModal.dart';
import '/security/firebase-auth/firebase-auth-services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  FireBaseAuthService _auth = FireBaseAuthService();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FireBaseAuthService _auth = FireBaseAuthService();
  final FireBaseBudgetService _budgetService = FireBaseBudgetService();

  @override
  Widget build(BuildContext context) {
    void _openAddBudgetModal(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const AddBudgetModal(); // Widget for the modal bottom sheet
        },
      );
    }

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
                      icon: const Icon(Icons.house),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
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
                      onPressed: () {
                        Navigator.pushNamed(context, '/budgets');
                      },
                      icon: const Icon(Icons.attach_money),
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
              //  Outside container
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.7,
                constraints: const BoxConstraints(maxWidth: 900, minWidth: 300),
                // Limit width to 300
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(),
                ),

                // Main container
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Card container
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Align(
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.02),

                          // Inside container
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Hello, ${_auth.getCurrentUser()?.displayName}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: FutureBuilder(
                                        future: _budgetService.getBudgetsSum(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          }
                                          return Text(
                                              '\$${snapshot.data ?? 0}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${_auth.getCurrentUser()?.email}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _openAddBudgetModal(context);
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/profile');
                                      },
                                      icon: Icon(
                                        Icons.person,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
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
