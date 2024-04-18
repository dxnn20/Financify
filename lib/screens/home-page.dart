//placeholder HOMEPAGE

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';

import '../main.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/media/1x/login-bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 300,
              margin: const EdgeInsets.only(bottom: 20),
              height: 100,
              decoration: BoxDecoration(
                color: Pallete.pallete[50],
                borderRadius: BorderRadius.all(Radius.circular(20)
                ),
              ),
              child: Center(
                child: Text(
                  'Financify',
                  style: TextStyle(
                    color: Pallete.pallete[100],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
