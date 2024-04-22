
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'login-page.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
    @override
    void initState() {
      super.initState();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const LoginPage()));
      });
    }

    @override
    void dispose() {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      super.dispose();
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Lottie.asset('assets/splash-screen.json'),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Financify',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
