
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});
  @override
  State<StatefulWidget> createState() =>  EventsViewState();
}

class  EventsViewState extends State<EventsView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text("Events view")
      ),
    );
  }
}
