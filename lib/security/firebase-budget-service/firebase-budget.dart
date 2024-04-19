import 'package:financify/entities/Budget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FireBaseBudgetService{
  final FirebaseFirestore _firebaseAuth = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String budgetId = Uuid().v4();

  Future<void> addBudget(Budget budget) async {
    try {
        await _firebaseAuth.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('budgets').doc(budgetId).set({
          'budgetid': budgetId,
          'userid': FirebaseAuth.instance.currentUser!.uid,
          'name': budget.name,
          'amount': budget.amount,
          'startdate': budget.startDate,
          'enddate': budget.endDate,
          'userId': FirebaseAuth.instance.currentUser!.uid
        });
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<void> updateBudget(Budget budget) async {
    try {
        await _firebaseAuth.collection('budgets').doc(budget.id).update({
          'id': budget.id,
          'name': budget.name,
          'amount': budget.amount,
          'startdate': budget.startDate,
          'enddate': budget.endDate,
          'userId': FirebaseAuth.instance.currentUser!.uid
        });
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<num> getBudgetsSum() async {
      try {
        var budgets = await _firebaseAuth.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('budgets').get();
        num sum = 0;

        budgets.docs.forEach((element) {
          sum += element['amount'];
        });

      return sum;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

}
