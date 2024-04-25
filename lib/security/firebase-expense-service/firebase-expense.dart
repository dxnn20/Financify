import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financify/entities/Budget.dart';
import 'package:financify/security/firebase-budget-service/firebase-budget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../entities/Expense.dart';

class FireBaseExpenseService{
  static final FirebaseFirestore _firebaseAuth = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final budgetService = FireBaseBudgetService();

  Future<void>addExpense(Expense expense, Budget budget) async {
    try {

      _firebaseAuth.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('budgets').doc(budget.getId()).collection('expenses').add({
          'expenseId': const Uuid().v4(),
          'title': expense.title,
          'amount': expense.amount,
          'date': expense.date.isEmpty ? DateTime.now().toString() : expense.date,
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'budgetId': budgetService.budgetId,
          'description': expense.description,
          'category': expense.category
        });
      //get budget of the expense and subtract the amount of the expense from the budget
      //update the budget with the new amount


// Retrieve the corresponding budget document
      final budgetDoc = await _firebaseAuth
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('budgets')
          .doc(budget.getId())
          .get();

      // Update the budget amount by subtracting the expense amount
      final double expenseAmount = expense.amount;
      final double currentBudgetAmount = budgetDoc['amount'];
      final double updatedBudgetAmount = currentBudgetAmount - expenseAmount;

      // Update the budget document with the new amount
      await _firebaseAuth
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('budgets')
          .doc(budget.getId())
          .update({'amount': updatedBudgetAmount});
    } on FirebaseAuthException {
      // Handle FirebaseAuthException
      rethrow;
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
        await _firebaseAuth.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('expenses').doc(expense.id).update({
          'id': expense.id,
          'budgetId': expense.budgetId,
          'title': expense.title,
          'amount': expense.amount,
          'date': expense.date,
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'description': expense.description,
          'category': expense.category
        });
    } on FirebaseAuthException {
      rethrow;
    }
  }

  getExpenses() async{
    var data = await _firebaseAuth.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('budgets').doc(budgetService.budgetId).collection('expenses').get();
    return data;
  }

  Future<List<Expense>> getFormattedExpenses() async {
    var data = await getExpenses(); // Await the result of getExpenses()

    List<Expense> expenses = [];

    for (var element in data) {
      Expense expense = Expense(
          id: element['expenseId'],
          userId: element['userId'],
          budgetId: element['budgetId'],
          title: element['title'],
          amount: element['amount'].toDouble(),
          date: element['date'],
          description: element['description'],
          category: element['category']
      );

      expenses.add(expense);
    }

    return expenses; // Return the list of expenses
  }

  Future<List<Expense>> getLast5Expenses() async {
    try {
      List<Budget> budgets = await FireBaseBudgetService().getBudgets();

      if (budgets.isEmpty) {
        return [];
      }

      Budget? firstBudget;

      // Find the first budget with expenses
      for (final budget in budgets) {
        final expenses = await FireBaseBudgetService().getExpensesByBudgetId(budget.id);
        if (expenses.isNotEmpty) {
          firstBudget = budget;
          break;
        }
      }

      // If no budget with expenses was found
      if (firstBudget == null) {
        return [];
      }

      // Get expenses of the first budget
      List<Expense> expenses = await FireBaseExpenseService().getExpensesByBudgetId(firstBudget.id);

      // Return the first 5 expenses
      return expenses.take(5).toList();
    } catch (e) {
      print('Error getting last 5 expenses: $e');
      return [];
    }
  }


  Future getExpensesByBudgetId (String id) async {
    var data = await _firebaseAuth.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('budgets').doc(id).collection('expenses').orderBy('date', descending: true).get();

    List<Expense> expenses = [];

    for (var element in data.docs) {
      Expense expense = Expense(
          id: element['expenseId'],
          userId: element['userId'],
          budgetId: element['budgetId'],
          title: element['title'],
          amount: element['amount'].toDouble(),
          date: element['date'],
          description: element['description'],
          category: element['category']
      );

      expenses.add(expense);
    }
    return expenses;
  }

  Future getExpensesSumByBudgetId(String id) async {
    var data = await _firebaseAuth.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('budgets').doc(id).collection('expenses').get();

    double sum = 0;

    for (var element in data.docs) {
      sum += element['amount'];
    }

    return sum;
  }

}