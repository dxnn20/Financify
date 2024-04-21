import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financify/page-components/AddExpenseModal.dart';
import 'package:financify/page-components/ModifyBudgetModal.dart';
import 'package:financify/security/firebase-budget-service/firebase-budget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:financify/main.dart';
import 'package:financify/screens/login-page.dart';
import '../entities/Budget.dart';
import '../page-components/ViewBudgetAndExpensesModal.dart';
import '/security/user-auth/firebase-auth/firebase-auth-services.dart';

import 'home-page.dart';

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  void openEditModal(BuildContext context, Budget budget) {
    showDialog(
        context: context,
        builder: (context) {
          return ModifyBudgetModal.build(context, budget);
        });
  }

  void openAddExpenseModal(BuildContext context, Budget budget) {
    showDialog(
        context: context,
        builder: (context) {
          return AddExpenseModal().build(context, budget);
        });
  }

  void openViewBudgetAndExpensesModal(BuildContext context, Budget budget) {
    showDialog(
        context: context,
        builder: (context) {
          return ViewBudgetAndExpensesModal(budget: budget);
        });
  }

  @override
  Widget build(BuildContext context) {
    final FireBaseAuthService auth = FireBaseAuthService();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            //menu container
            Container(
              constraints: const BoxConstraints.expand(),
              margin: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home),
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
                      icon: const Icon(Icons.attach_money),
                      onPressed: () {
                        Navigator.pushNamed(context, '/budgets');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        auth.signOut();
                        print('User signed out');
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ),
            ),
            //Page Container
            Column(
              children: [
                //Main Card
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.1,
                  constraints: const BoxConstraints(maxWidth: 900, minWidth: 250),
                  child: Card(
                    color: Theme.of(context).colorScheme.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'What a time to plan a vacation...',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    alignment: Alignment.topCenter,
                    constraints: const BoxConstraints(maxWidth: 900, minWidth: 250),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.3,
                        constraints:
                            const BoxConstraints(maxWidth: 900, minWidth: 250),
                        child: FutureBuilder(
                            future: FireBaseBudgetService().getBudgets(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                // Extract the list of budgets from the snapshot
                                List<Budget> budgets =
                                    snapshot.data as List<Budget>;

                                return ListView.builder(
                                    itemCount: budgets.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: null,
                                        child: Card(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            elevation: 5.0,
                                            child: GestureDetector(
                                              onTap: () {
                                                openViewBudgetAndExpensesModal(
                                                    context, budgets[index]);
                                              },
                                              child: ListTile(
                                                title: Text(
                                                  budgets[index].name,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  '${budgets[index].amount as num}\$',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  ),
                                                ),
                                                trailing: SafeArea(
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        style: ButtonStyle(
                                                            iconColor:
                                                                MaterialStateProperty
                                                                    .all(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary,
                                                        )),
                                                        icon:
                                                            const Icon(Icons.edit),
                                                        onPressed: () {
                                                          openEditModal(context,
                                                              budgets[index]);
                                                        },
                                                      ),
                                                      IconButton(
                                                        style: ButtonStyle(
                                                            iconColor:
                                                                MaterialStateProperty
                                                                    .all(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary,
                                                        )),
                                                        icon: const Icon(Icons.add),
                                                        onPressed: () {
                                                          openAddExpenseModal(
                                                              context,
                                                              budgets[index]);
                                                        },
                                                      ),
                                                      IconButton(
                                                        style: ButtonStyle(
                                                            iconColor:
                                                                MaterialStateProperty
                                                                    .all(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary,
                                                        )),
                                                        icon: const Icon(
                                                            Icons.delete),
                                                        onPressed: () {
                                                          FireBaseBudgetService()
                                                              .deleteBudget(
                                                                  budgets[index]
                                                                      .id);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )),
                                      );
                                    });
                              }
                              throw UnimplementedError();
                            }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
