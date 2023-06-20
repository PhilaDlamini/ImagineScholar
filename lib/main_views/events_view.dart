
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'create_events_view.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});
  @override
  State<StatefulWidget> createState() =>  EventsViewState();
}

class  EventsViewState extends State<EventsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CreateEventsView()),
              );
            },
          )
        ],
      ),
      body: Center(
          child: Text("Events view")
      ),
    );
  }
}
