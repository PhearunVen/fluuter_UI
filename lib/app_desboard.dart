import 'package:flutter/material.dart';
import 'package:learn_api/sign_in_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDesboard extends StatefulWidget {
  const AppDesboard({super.key});

  @override
  State<AppDesboard> createState() => _AppDesboardState();
}

class _AppDesboardState extends State<AppDesboard> {
  Future<void> logoutUser() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInUser()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Desboard'),
        actions: [
          IconButton(onPressed: () => logoutUser(), icon: Icon(Icons.logout)),
        ],
      ),
    );
  }
}
