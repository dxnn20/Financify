import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financify/entities/Budget.dart';
import 'package:financify/main.dart';
import 'package:financify/security/firebase-budget-service/firebase-budget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entities/Expense.dart';
import '../page-components/AddBudgetModal.dart';
import '../security/firebase-expense-service/firebase-expense.dart';
import '/security/user-auth/firebase-auth/firebase-auth-services.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FireBaseAuthService _auth = FireBaseAuthService();
  final FireBaseBudgetService _budgetService = FireBaseBudgetService();
  List<Expense> expenses = [];
  List<Budget> budgets = [];

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  String formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  Future loadExpenses() async {
    List<Expense> loadedExpenses =
        await FireBaseExpenseService().getLast5Expenses();

    setState(() {});
  }

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
            // Side menu
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
                                builder: (context) => const HomePage()));
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
                constraints: const BoxConstraints(maxWidth: 900, minWidth: 250),
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
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary,
                            blurRadius: 20,
                            offset: const Offset(0, 0),
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Align(
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
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${_auth.getCurrentUser()?.email}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Container(
                              alignment: Alignment.topLeft,
                              width: MediaQuery.of(context).size.width,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(_auth.getCurrentUser()?.uid)
                                      .collection('budgets')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Flex(
                                          direction: Axis.vertical,
                                          children: [CircularProgressIndicator()]);
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
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    constraints: const BoxConstraints(
                                        maxWidth: 200, minWidth: 100),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    child: TextButton.icon(
                                      icon: Icon(
                                        Icons.add,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                      onPressed: () {
                                        openAddBudgetModal(context);
                                      },
                                      label: Text(
                                        'Add Budget',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    constraints: const BoxConstraints(
                                        maxWidth: 150, minWidth: 50),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    child: TextButton.icon(
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
                                      label: Text(
                                        'Profile',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text('Here\'s your last few expenses:',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          constraints: const BoxConstraints(
                              maxHeight: 300, maxWidth: 900, minWidth: 250),
                          child: Flex(direction: Axis.vertical, children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                constraints: const BoxConstraints(
                                    maxHeight: 300,
                                    maxWidth: 500,
                                    minWidth: 250),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      blurRadius: 20,
                                      offset: const Offset(0, 0),
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FutureBuilder(
                                          future: FireBaseExpenseService()
                                              .getLast5Expenses(),
                                          // a Future<String> or null
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            }
                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            }

                                            if ((snapshot.data as List<Expense>)
                                                .isEmpty) {
                                              return Text(
                                                  'No expenses, that\'s cool!',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  ));
                                            }

                                            List<Expense> expenses =
                                                snapshot.data as List<Expense>;
                                            return ListView.builder(
                                              itemCount: expenses.length,
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  child: ListTile(
                                                      style: ListTileStyle.list,
                                                      title: Text(
                                                          expenses[index].title,
                                                          style: TextStyle(
                                                            color:
                                                                Theme.of(context)
                                                                    .colorScheme
                                                                    .onPrimary,
                                                          )),
                                                      subtitle: Text(
                                                        expenses[index].date,
                                                        style: TextStyle(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary,
                                                        ),
                                                      ),
                                                      trailing: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                            color:
                                                                Theme.of(context)
                                                                    .colorScheme
                                                                    .error,
                                                          ),
                                                        ),
                                                        padding:
                                                            const EdgeInsets.all(
                                                                5),
                                                        child: Text(
                                                          '\$${expenses[index].amount.toString()}',
                                                          style: TextStyle(
                                                            color:
                                                                Theme.of(context)
                                                                    .colorScheme
                                                                    .error,
                                                          ),
                                                        ),
                                                      )),
                                                );
                                              },
                                            );
                                          }),
                                    ))),
                          ]),
                        ),
                      ],
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
