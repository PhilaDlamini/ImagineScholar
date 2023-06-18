
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({super.key});
  @override
  State<StatefulWidget> createState() =>  _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text("Chats view")
      ),
    );
  }
}
