import 'package:financify/entities/Budget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../entities/Expense.dart';


class FireBaseBudgetService {
  final FirebaseFirestore _firebaseAuth = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String budgetId = const Uuid().v4();

  Future<void> addBudget(Budget budget) async {
    try {
      await _firebaseAuth
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('budgets')
          .doc(budgetId)
          .set({
        'budgetId': budgetId,
        'name': budget.name,
        'amount': budget.amount,
        'startdate': budget.startDate,
        'enddate': budget.endDate,
        'userId': FirebaseAuth.instance.currentUser!.uid
      });
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> updateBudget(Budget budget) async {
    try {
      await _firebaseAuth
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('budgets')
          .doc(budget.id)
          .update({
        'id': budget.id,
        'name': budget.name,
        'amount': budget.amount,
        'startdate': budget.startDate,
        'enddate': budget.endDate,
        'userId': FirebaseAuth.instance.currentUser!.uid
      });
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<num> getBudgetsSum() async {
    try {
      var budgets = await _firebaseAuth
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('budgets')
          .get();
      num sum = 0;

      for (var element in budgets.docs) {
        sum += element['amount'];
      }

      return sum;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future getBudgets() async {
    var data = await _firebaseAuth
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('budgets')
        .get();

    List<Budget> budgets = [];

    for (var element in data.docs) {
      Budget budget = Budget(
        userId: element['userId'],
        id: element['budgetId'],
        name: element['name'],
        amount: element['amount'].toDouble(),
        startDate: element['startdate'],
        endDate: element['enddate'],
      );

      budgets.add(budget);
    }

    return budgets;
  }

  void deleteBudget(String id) {
    _firebaseAuth
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('budgets')
        .doc(id)
        .delete();
  }

  String getBudgetId() {
    return budgetId;
  }

  Stream getBudgetsStream() {
    return _firebaseAuth
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('budgets')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Budget(
          id: doc.id,
          name: doc['name'],
          amount: doc['amount'].toDouble(),
          startDate: doc['startdate'],
          endDate: doc['enddate'],
          userId: doc['userId'],
        );
      }).toList();
    });
  }

  Future<List<Expense>> getExpensesByBudgetId(String id) async {

    var data = await _firebaseAuth
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('budgets')
        .doc(id)
        .collection('expenses')
        .orderBy('date', descending: true)
        .get();

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
        category: element['category'],
      );

      expenses.add(expense);
    }

    return expenses;
  }

  Future<List<Expense>> getExpenses() async{

    var data = await _firebaseAuth
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('budgets')
        .doc(budgetId)
        .collection('expenses')
        .orderBy('date', descending: true)
        .get();

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
        category: element['category'],
      );

      expenses.add(expense);
    }

    return expenses;

  }

}
