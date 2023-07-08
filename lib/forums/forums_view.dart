
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForumsView extends StatefulWidget {
  const ForumsView({super.key});
  @override
  State<StatefulWidget> createState() =>  _ForumsViewState();
}

class _ForumsViewState extends State<ForumsView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text("Forums view")
      ),
    );
  }
}
