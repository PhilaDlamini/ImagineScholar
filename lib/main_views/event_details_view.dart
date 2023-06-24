import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Event.dart';

class EventDetailsView extends StatefulWidget {
  Event event;
  EventDetailsView(this.event, {super.key});
  @override
  State<StatefulWidget> createState() => EventDetailsState();

}

class EventDetailsState extends State<EventDetailsView>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Event details")
          ],
        )
      ),
    );
  }

}