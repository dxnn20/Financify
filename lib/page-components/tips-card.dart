

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TipsCard extends StatelessWidget{
  const TipsCard({super.key});

  @override
  Widget build(BuildContext context) {

    List<String> tips = [
      'Creating an expense for a non-existent budget will automatically create a new budget with that name.'
      'Remember to always keep track of your expenses. It helps you to know where your money is going and how you can save more.',
      'Always have a budget. It helps you to know how much you can spend and how much you can save.',
      'Always have an emergency fund. It helps you to be prepared for any unexpected expenses.',
      'Always have a savings account. It helps you to save money for the future.',
      'Always have a retirement account. It helps you to save money for your retirement.',
      'Always have a health insurance. It helps you to be prepared for any medical expenses.',
      'Always have a life insurance. It helps you to be prepared for any unexpected events.',
      'Always have a will. It helps you to be prepared for any unexpected events.',
      'Always have a power of attorney. It helps you to be prepared for any unexpected events.',
      'Always have a living will. It helps you to be prepared for any unexpected events.',
    ];

    return Container(
      padding: const EdgeInsets.all(30),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onBackground,
            blurRadius: 10,
            offset: const Offset(0, 5),
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Tips',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Icon(
                Icons.lightbulb,
                color: Theme.of(context).colorScheme.onPrimary,),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            tips[Random().nextInt(tips.length)],
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

}