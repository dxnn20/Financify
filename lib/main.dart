import 'package:financify/screens/budgets-page.dart';
import 'package:financify/screens/home-page.dart';
import 'package:financify/screens/login-page.dart';
import 'package:financify/screens/profile-page.dart';
import 'package:financify/screens/register-page.dart';
import 'package:financify/screens/splash-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  int _currentIndex = -1;
  ThemeData _currentTheme = CustomTheme.darkTheme;
  final List<ThemeData> _themes = [
    CustomTheme.lightTheme,
    CustomTheme.darkTheme,
    CustomTheme.cute,
    CustomTheme.cuteLight,
    // Add more themes here as needed
  ];

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentIndex = (_currentIndex + 1) % _themes.length;
    _currentTheme = _themes[_currentIndex];
    print('Current theme: $_currentIndex');
    notifyListeners(); // Notify listeners to rebuild UI
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Financify',
      theme: Provider
          .of<ThemeProvider>(context)
          .currentTheme,
      //home: SplashScreen(),
      //home: HomePage(),
      // home: FutureBuilder(
      //   future: FirebaseAuth.instance.authStateChanges().first,
      //   builder: (context, AsyncSnapshot<User?> snapshot) {
      //     print(snapshot.connectionState);
      //     print(snapshot.hasData);
      //
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const CircularProgressIndicator();
      //     }
      //     if (snapshot.hasData) {
      //       return const HomePage();
      //     }
      //     return const LoginPage();
      //   },
      // ),
      home: HomePage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/budgets': (context) => BudgetsPage(),
      },
    );
  }
}

class AppTheme {
  final ThemeData data;

  AppTheme(this.data);
}

class CustomTheme {
  static final lightTheme = ThemeData(
      primaryColor: Color(0xFF222831),
      hintColor: Color(0xFF31363F),
      // Add more theme properties as needed
      brightness: Brightness.light,
      colorScheme: const ColorScheme(background: Color(0xFF222831),
          brightness: Brightness.light,
          error: Color(0xFFD20062),
          onBackground: Color(0xFFEEEEEE),
          onError: Color(0xFF31363F),
          onPrimary: Color(0xFF222831),
          onSecondary: Color(0xFFEEEEEE),
          onSurface: Color(0xFFEEEEEE),
          primary: Color(0xFF222831),
          secondary: Color(0xFFEEEEEE),
          surface: Color(0xFFEEEEEE)
      )
  );

  static final darkTheme = ThemeData(
      primaryColor: Color(0xFF222831),
      hintColor: Color(0xFF31363F),
      // Add more theme properties as needed
      brightness: Brightness.dark,
      colorScheme: ColorScheme(background: Color(0xFFEEEEEE),
          brightness: Brightness.dark,
          error: Color(0xFFD20062),
          onBackground: Color(0xFF000000),
          onError: Color(0xFF000000),
          onPrimary: Color(0xFFEEEEEE),
          onSecondary: Color(0xFF000000),
          onSurface: Color(0xFF000000),
          primary: Color(0xFF222831),
          secondary: Color(0xFF000000),
          surface: Color(0xFF000000)
      ));

  static final ThemeData cute = ThemeData(
    primaryColor: const Color(0xFF153448),
    hintColor: const Color(0xFF153448),
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      primary: Color(0xFF153448),
      secondary: Color(0xFF153448),
      surface: Color(0xFFE5DDC5),
      background: Color(0xFF153448),
      error: Color(0xFF803D3B),
      onPrimary: Color(0xFF153448),
      onSecondary: Color(0xFFE5DDC5),
      onSurface: Color(0xFFE5DDC5),
      onBackground: Color(0xFFE5DDC5),
      onError: Color(0xFF153448),
      brightness: Brightness.light,
    ),
  );

  static final ThemeData cuteLight = ThemeData(
    primaryColor: const Color(0xFF153448),
    hintColor: const Color(0xFF153448),
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      primary: Color(0xFF153448),
      secondary: Color(0xFF153448),
      surface: Color(0xFFE5DDC5),
      background: Color(0xFFB3C8CF),
      error: Color(0xFF803D3B),
      onPrimary: Color(0xFF153448),
      onSecondary: Color(0xFF153448),
      onSurface: Color(0xFFE5DDC5),
      onBackground: Color(0xFF153448),
      onError: Color(0xFF153448),
      brightness: Brightness.dark,
    ),
  );

}
