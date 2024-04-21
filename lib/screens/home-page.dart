import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financify/main.dart';
import 'package:financify/security/firebase-budget-service/firebase-budget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../entities/Expense.dart';
import '../page-components/AddBudgetModal.dart';
import '/security/user-auth/firebase-auth/firebase-auth-services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FireBaseAuthService _auth = FireBaseAuthService();
  final FireBaseBudgetService _budgetService = FireBaseBudgetService();
  final List<Expense> expenses = [];

  String? get userId => null;

  @override
  Widget build(BuildContext context) {
    void openAddBudgetModal(BuildContext context) {
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
                      constraints: const BoxConstraints(maxHeight: 300),
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
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(_auth.getCurrentUser()?.uid)
                                            .collection('budgets')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }

                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          }

                                          double totalBalance = 0.0;
                                          for (var budgetDoc in snapshot.data!.docs) {
                                            totalBalance +=
                                                budgetDoc['amount'] ?? 0.0;
                                          }
                                          return Text(
                                              '\$${totalBalance.toString() ?? 0}',
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
                                        openAddBudgetModal(context);
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
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Align(
                              alignment: Alignment.center,
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                children: <Widget>[
                                  Card(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    child: ListTile(
                                      title: Text('Expense 1'),
                                      subtitle: Text('Expense 1 Description'),
                                      trailing: Text('\$100.00'),
                                    ),
                                  )
                                ],
                              ))),
                    ),
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
