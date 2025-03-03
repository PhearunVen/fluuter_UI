import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learn_api/app_desboard.dart';
import 'package:learn_api/app_url.dart';
import 'package:learn_api/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInUser extends StatefulWidget {
  const SignInUser({super.key});

  @override
  State<SignInUser> createState() => _SignInUserState();
}

class _SignInUserState extends State<SignInUser> {
  bool ispassword = true;
  final txt = FocusNode();
  void togglePassword() {
    setState(() {
      ispassword = !ispassword;
      if (txt.hasPrimaryFocus) return;
      txt.canRequestFocus = false;
    });
  }

  TextEditingController txtUserName = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  Future<void> loginUser(String userName, String userPassword) async {
    var url = Uri.parse("${AppUrl.url}login_user.php");
    final rp = await http.post(
      url,
      body: {'UsernameLogin': userName, 'PasswordLogin': userPassword},
    );
    if (rp.statusCode == 200) {
      final data = jsonDecode(rp.body);

      if (data['success'] == 1) {
        //save user login info
        final sp = await SharedPreferences.getInstance();
        sp.setString("userId", "${data['userID']}");
        sp.setString("userName", "${data['userName']}");
        sp.setString("userPass", "${data['userPass']}");
        sp.setString("userType", "${data['userType']}");
        sp.setString("userImage", "${data['userImage']}");
        sp.setString("userEmail", "${data['userEmail']}");
        sp.setString("userFullname", "${data['userFullName']}");
        sp.setString("userPhone", "${data['userPhone']}");
        sp.setBool("isLogin", true);

        print("${data['msg_success']}");
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AppDesboard()),
          (route) => false,
        );
      } else {
        print("${data['msg_error']}");
      }
    } else {
      print("Failed to send data!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login User')),
        body: Form(
          key: _keyForm,
          child: ListView(
            children: <Widget>[
              // Container(
              //   alignment: Alignment.center,
              //   padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
              //   child: Image.asset(
              //     'assets/images/person_icon.png',
              //     width: 100,
              //     height: 100,
              //   ),
              // ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required UserName!';
                    }
                    return null;
                  },
                  controller: txtUserName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person, size: 32),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Password!';
                    }
                    return null;
                  },
                  controller: txtPassword,
                  obscureText: ispassword,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline, size: 32),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: GestureDetector(
                        onTap: togglePassword,
                        child: Icon(
                          // condition ? result_if_true : result_if_false;
                          ispassword
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 56,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    if (_keyForm.currentState!.validate()) {
                      String strname = txtUserName.text;
                      String strpwd = txtPassword.text.trim();
                      loginUser(strname, strpwd);
                    }
                  },
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                height: 56,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 40),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Does not have account?'),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
