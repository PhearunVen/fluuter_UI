import 'package:flutter/material.dart';
import 'package:learn_api/app_desboard.dart';
import 'package:learn_api/sign_in_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sp = await SharedPreferences.getInstance();
  final loginStatus = sp.getBool('isLogin') ?? false;
  runApp(MyApp(isLogin: loginStatus));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp({super.key, required this.isLogin});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: isLogin ? const AppDesboard() : const SignInUser(),
    );
  }
}
