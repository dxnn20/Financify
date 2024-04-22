import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../security/user-auth/firebase-auth/firebase-auth-services.dart';
import 'home-page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FireBaseAuthService auth = FireBaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            //sidebar
            Container(
              constraints: const BoxConstraints.expand(),
              margin: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home),
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
                      icon: const Icon(Icons.attach_money),
                      onPressed: () {
                        Navigator.pushNamed(context, '/budgets');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        auth.signOut();
                        print('User signed out');
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ),
            ),

            //page container
            Align(
              alignment: Alignment.center,

              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 900, minWidth: 250),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary,
                          blurRadius: 15,
                          offset: const Offset(0, 0),
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      constraints: const BoxConstraints(maxWidth: 800, minWidth: 250),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Icon(
                            Icons.person,
                            size: 100,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          FutureBuilder(
                              future: auth.getFutureCurrentUser(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Column(
                                    children: [
                                      Text(
                                        'Name: ${snapshot.data!.displayName}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                      Text(
                                        'Email: ${snapshot.data!.email}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              }),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 120),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .background),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      'Change Password',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .background),
                                    ),
                                    onPressed: () {
                                      auth.signOut();
                                      print('User signed out');
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: Text(
                                      'Sign Out',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              ])
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
