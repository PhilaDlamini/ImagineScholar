
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnnouncementsView extends StatefulWidget {
  const AnnouncementsView({super.key});
  @override
  State<StatefulWidget> createState() =>  _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<AnnouncementsView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text("Announcements view")
      ),
    );
  }
}
