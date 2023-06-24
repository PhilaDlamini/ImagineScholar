import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/Event.dart';
import '../models/User.dart';
import 'create_event_view.dart';
import 'event_details_view.dart';

class EventsView extends StatefulWidget {
  User user;
  EventsView(this.user, {super.key});

  @override
  State<StatefulWidget> createState() => EventsViewState();
}

class EventsViewState extends State<EventsView> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();

    //Fetch all current posts
    var ref = FirebaseDatabase.instance.ref();
    ref.child('events').get().then((snapshot) {
      if (snapshot.value != null) {
        for (var child in snapshot.children) {
          var eventData = child.value as Map<dynamic, dynamic>;
          var event = Event.fromDict(eventData);
          events.insert(0, event);
        }
      }
    });

    //Listen for post updates
    ref.child('events').onChildChanged.listen((ev) {
      var eventData = ev.snapshot.value as Map<dynamic, dynamic>;
      var event = Event.fromDict(eventData);
      setState(() {
        events.removeWhere((e) => e.id == event.id);
        events.add(event);
      });
    });

    ref.child('events').onChildRemoved.listen((ev) {
      var postData = ev.snapshot.value as Map<dynamic, dynamic>;
      var event = Event.fromDict(postData);
      setState(() {
        events.removeWhere((e) => e.id == event.id);
      });
    });

    ref.child('events').onChildAdded.listen((ev) {
      var eventData = ev.snapshot.value as Map<dynamic, dynamic>;
      var event = Event.fromDict(eventData);
      setState(() {
        events.removeWhere((e) => e.id == event.id);
        events.add(event);
      });
    });
  }

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
                MaterialPageRoute(builder: (context) => CreateEventsView(widget.user)),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (BuildContext context, int index) {
                  return EventView(events[index]);
                })),
      ),
    );
  }
}

class EventView extends StatefulWidget {
  Event event;
  EventView(this.event, {super.key});

  @override
  State<StatefulWidget> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventDetailsView(widget.event)),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.event.authorURL),
                  maxRadius: 20,
                ),
                Container( //TODO: remove hard-coded height
                  color: Colors.blueGrey,
                  width: 1,
                  height: 90,
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event.name,
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(widget.event.description,
                  style:
                      const TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.email),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("${widget.event.rsvpd?.length ?? 0}"),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
