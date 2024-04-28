import 'package:financify/page-components/AddExpenseModal.dart';
import 'package:flutter/material.dart';

class addExpenseButton extends StatelessWidget{
  const addExpenseButton({super.key});

  AddExpenseModal openAddExpenseModal(){
    return AddExpenseModal();
  }

  @override
  Widget build(BuildContext context){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.background,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.background,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),

      child: FloatingActionButton(
        elevation: 30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusElevation: 0,
        hoverElevation: 0,
        onPressed: () {
          showDialog(
            builder: (context) => openAddExpenseModal().build(context, null), context: context,
          );
        },
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        child: const Icon(Icons.add),
      ),
    );
  }
}