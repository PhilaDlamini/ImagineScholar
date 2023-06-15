
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  void _handleSignIn() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential userCredential = await _auth.signInAnonymously();
      if (userCredential != null) {
        print("Signed in!");
      } else {
        print("Failed to sign user in");
      }
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: _handleSignIn,
            child: Text("Sign in anon"))
      ),
    );
  }
}