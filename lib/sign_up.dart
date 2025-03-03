import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn_api/app_desboard.dart';
import 'package:learn_api/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
  TextEditingController txtFullName = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  final _keyform = GlobalKey<FormState>();
  String? _password;
  String? _confirmpassword;

  Future<void> signup_user(
    String fullName,
    String userName,
    String userPassword,
  ) async {
    var url = Uri.parse("${AppUrl.url}register_user.php");

    try {
      final rp = await http.post(
        url,
        body: {
          'FullName': fullName,
          'UserName': userName,
          'Password': userPassword,
        },
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
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AppDesboard()),
            (route) => false,
          );
        } else {
          print('${data['msg_error']}');
        }
      } else {
        print('Faild to connect to server.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Sign UP')),
        body: Form(
          key: _keyform,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'FullName is required';
                    }
                    return null;
                  },
                  controller: txtFullName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person, size: 32),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
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
                  onChanged: (value) {
                    _password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
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
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  onChanged: (value) {
                    _confirmpassword = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Password is required';
                    }
                    if (_password != _confirmpassword) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  controller: txtConfirmPassword,
                  obscureText: ispassword,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline, size: 32),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: GestureDetector(
                        onTap: togglePassword,
                        child: Icon(
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
                margin: const EdgeInsets.fromLTRB(0, 35, 0, 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    if (_keyform.currentState!.validate()) {
                      String strfullName = txtFullName.text;
                      String strname = txtUserName.text.trim();
                      String strpwd = txtPassword.text.trim();
                      signup_user(strfullName, strname, strpwd);
                    }
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
