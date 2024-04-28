import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financify/entities/Budget.dart';
import 'package:financify/main.dart';
import 'package:financify/page-components/addExpense-button.dart';
import 'package:financify/page-components/tips-card.dart';
import 'package:financify/security/firebase-budget-service/firebase-budget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entities/Expense.dart';
import '../page-components/AddBudgetModal.dart';
import '../page-components/SetBudgetGoalModal.dart';

import '../security/firebase-expense-service/firebase-expense.dart';
import '/security/user-auth/firebase-auth/firebase-auth-services.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences prefs;

  final FireBaseAuthService _auth = FireBaseAuthService();
  final FireBaseBudgetService _budgetService = FireBaseBudgetService();
  List<Expense> expenses = [];
  List<Budget> budgets = [];
  List<TextButton> sortedButtons = [];

  @override
  void initState() {
    super.initState();
    loadSharedPreferences();
    loadExpenses();
  }

  Future<void> loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    // Load click counts from SharedPreferences
    for (String key in clickCounts.keys) {
      int? count = prefs.getInt(key);
      if (count != null) {
        setState(() {
          clickCounts[key] = count;
        });
      }
    }

    // Load other data and update the UI
    loadExpenses();
  }

  void incrementClickCount(String buttonKey) {
    setState(() {
      clickCounts[buttonKey] = (clickCounts[buttonKey] ?? 0) + 1;
    });
    // Save click counts to SharedPreferences
    prefs.setInt(buttonKey, clickCounts[buttonKey]!);
  }

  String formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  Future loadExpenses() async {
    expenses = await FireBaseExpenseService().getLast5Expenses();
    setState(() {
      sortedButtons = getSortedButtons(context);
    });
  }

  Map<String, int> clickCounts = {
    'Profile': 0,
    'Budgets': 0,
    'AddBudget': 0,
    'SetGoal': 0,
  };

  List<TextButton> buttons(BuildContext context) {
    return [
      TextButton.icon(
        key: const Key('Budgets'),
        onPressed: () {
          if (clickCounts['Budgets'] != null) {
            incrementClickCount('Budgets');
          }
          Navigator.pushNamed(context, '/budgets');
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.background,
          ),
        ),
        icon: Icon(
          Icons.attach_money,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        label: Text(
          'Budgets',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      TextButton.icon(
          key: const Key('AddBudget'),
          icon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () {
            incrementClickCount('AddBudget');
            openAddBudgetModal(context);
          },
          label: Text(
            'Add Budget',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.background,
            ),
          )),
      TextButton.icon(
          key: const Key('Profile'),
          onPressed: () {
            incrementClickCount('Profile');

            Navigator.pushNamed(context, '/profile');
          },
          icon: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          label: Text(
            'Profile',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.background,
            ),
          )),
      TextButton.icon(
          key: const Key('SetGoal'),
          onPressed: () {
            incrementClickCount('SetGoal');
            openSetBudgetGoalModal(context);
          },
          icon: Icon(
            Icons.arrow_outward,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          label: Text(
            'Set Goal',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.background,
            ),
          )),
    ];
  }

  List<TextButton> getSortedButtons(BuildContext context) {
    List<TextButton> buffer = buttons(context);

    buffer.sort((a, b) {
      String? keyA = a.key?.toString().replaceAll(RegExp(r'[<>\[\]]'), '');
      String? keyB = b.key?.toString().replaceAll(RegExp(r'[<>\[\]]'), '');

      keyA = keyA?.substring(1, keyA.length - 1);
      keyB = keyB?.substring(1, keyB.length - 1);

      if (keyA == null || keyB == null) {
        return 0;
      }

      final countA = clickCounts[keyA] ?? 0;
      final countB = clickCounts[keyB] ?? 0;

      return countB.compareTo(countA); // Sort in descending order
    });

    return buffer;
  }

  void openSetBudgetGoalModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SetBudgetGoalModal(context); // Widget for the modal bottom sheet
      },
    );
  }

  void openAddBudgetModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const AddBudgetModal(); // Widget for the modal bottom sheet
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    buildPlaceholder() {
      return Container(
          width: 30,
          constraints: const BoxConstraints(
            minHeight: 50,
            maxWidth: 200,
          ),
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
          ));
    }

    return Scaffold(
      floatingActionButton: const addExpenseButton(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Stack(
            children: [
              // Side menu
              Container(
                constraints: const BoxConstraints.expand(),
                margin: const EdgeInsets.only(right: 5, top: 10),
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
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height,
                  constraints:
                      const BoxConstraints(maxWidth: 1000, minWidth: 250),

                  // Main container
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
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
                                        stream: _auth.getBudgetGoalStream(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<dynamic> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          }

                                          return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(
                                                    _auth.getCurrentUser()?.uid)
                                                .collection('budgets')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Flex(
                                                    direction: Axis.vertical,
                                                    children: [
                                                      CircularProgressIndicator()
                                                    ]);
                                              }

                                              double totalBalance = 0.0;

                                              for (var budgetDoc
                                                  in snapshot.data!.docs) {
                                                totalBalance +=
                                                    budgetDoc['amount'] ?? 0.0;
                                              }
                                              return Text(
                                                  '\$${totalBalance.toString()}',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ));
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Align(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        if (constraints.maxWidth > 600) {
                                          // Check if the screen width is larger than 600
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: (sortedButtons.isEmpty)
                                                ? [
                                                    buildPlaceholder(),
                                                    buildPlaceholder(),
                                                    buildPlaceholder(),
                                                    buildPlaceholder()
                                                  ]
                                                : [
                                                    sortedButtons[0],
                                                    const SizedBox(width: 5),
                                                    sortedButtons[1],
                                                    const SizedBox(width: 5),
                                                    sortedButtons[2],
                                                    const SizedBox(width: 5),
                                                    sortedButtons[3],
                                                  ],
                                          );
                                        } else {
                                          if (sortedButtons.isEmpty) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                buildPlaceholder(),
                                                const SizedBox(height: 5),
                                                buildPlaceholder(),
                                                const SizedBox(height: 5),
                                                buildPlaceholder(),
                                                const SizedBox(height: 5),
                                                buildPlaceholder(),
                                              ],
                                            );
                                          }
                                          return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    width: constraints.maxWidth,
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 200),
                                                    child: sortedButtons[0]),
                                                const SizedBox(height: 5),
                                                Container(
                                                    width: constraints.maxWidth,
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 200),
                                                    child: sortedButtons[1]),
                                                const SizedBox(height: 5),
                                                Container(
                                                    width: constraints.maxWidth,
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 200),
                                                    child: sortedButtons[2]),
                                                const SizedBox(height: 5),
                                                Container(
                                                    width: constraints.maxWidth,
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 200),
                                                    child: sortedButtons[3]),
                                              ]);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Column(
                            children: [
                              StreamBuilder<List<Budget>>(
                                stream: _budgetService.getBudgetsStreamAsList(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        'Error: ${snapshot.error}'); // Placeholder for error state
                                  } else {
                                    List<Budget> budgets = snapshot.data ??
                                        []; // Get the list of budgets

                                    double totalBudgetsSum = 0;

                                    for (var budget in budgets) {
                                      totalBudgetsSum += budget.amount;
                                    }

                                    return Column(
                                      children: [
                                        Text(
                                            '\$${totalBudgetsSum.toString()} / \$${_auth.getBudgetGoal()} ',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: LinearProgressIndicator(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            minHeight: 30,
                                            value: double.parse(_auth
                                                        .getBudgetGoal()) ==
                                                    0
                                                ? 0.01
                                                : (totalBudgetsSum /
                                                            double.parse(_auth
                                                                .getBudgetGoal()) <
                                                        0.1)
                                                    ? 0.05
                                                    : (totalBudgetsSum /
                                                        double.parse(_auth
                                                            .getBudgetGoal())),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .background),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text('Here\'s your last few expenses:',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                constraints: const BoxConstraints(
                                    maxWidth: 1000, minWidth: 250),
                                child:
                                    Flex(direction: Axis.vertical, children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      constraints: const BoxConstraints(
                                          maxHeight: 300,
                                          maxWidth: 1000,
                                          minWidth: 250),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  }
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        'Error: ${snapshot.error}');
                                                  }

                                                  if ((snapshot.data
                                                          as List<Expense>)
                                                      .isEmpty) {
                                                    return Text(
                                                        'No expenses, that\'s cool!',
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                        ));
                                                  }

                                                  List<Expense> expenses =
                                                      snapshot.data
                                                          as List<Expense>;
                                                  return ListView.builder(
                                                    itemCount: expenses.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Card(
                                                        child: ListTile(
                                                            style: ListTileStyle
                                                                .list,
                                                            title: Text(
                                                                expenses[index]
                                                                    .title,
                                                                style:
                                                                    TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimary,
                                                                )),
                                                            subtitle: Text(
                                                              expenses[index]
                                                                  .date,
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onPrimary,
                                                              ),
                                                            ),
                                                            trailing: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                border:
                                                                    Border.all(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .error,
                                                                ),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Text(
                                                                '\$${expenses[index].amount.toString()}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Theme.of(
                                                                          context)
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const TipsCard(),
                                ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
