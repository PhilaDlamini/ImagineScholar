import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imaginine_scholar/authentication/create_account.dart';
import 'package:imaginine_scholar/authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:imaginine_scholar/home.dart';
import 'firebase_options.dart';
import 'main_views/posts_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(App());
}

class App extends StatefulWidget {
  App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  User? user;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      this.user = user;
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imagine Scholar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raleway',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: TextTheme(
            bodyMedium: TextStyle(fontSize: 14),
        ),
        useMaterial3: true,
      ),
      home: user == null ? Login() : HomePage(), //TODO: this doesn't update to the home page when the user signs in
    );
  }
}
