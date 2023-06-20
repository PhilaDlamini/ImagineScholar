import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imaginine_scholar/SharedPref.dart';
import '../models/User.dart' as our;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //Logs in the user
  void _logIn() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (userCredential.user != null) {

        //TODO: move to CreateAccountView
        //saves the current user information to user defaults
        User user = auth.currentUser!;
        var ref = FirebaseDatabase.instance.ref();
        ref.child('users').child(user.uid).get().then((snapshot) {
          if (snapshot.value != null) {
            var userData = snapshot.value as Map<dynamic, dynamic>;
            our.User currUser = our.User.fromJson(userData);
            SharedPref.save('user', currUser);
            print("saved user info");
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error signing in anonymously: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(35),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter valid password";
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _logIn();
                    }
                    print("Pressed");
                  },
                  child: const Text("Log in"),
                )
              ],
            ),
          ),
        )
    );
  }
}