
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();


}

class _ProfilePageState extends State<ProfilePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/media/1x/login-bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            child: const Column(
              children: [
                Text('Profile Page'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}