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
          events.removeWhere((e) => e.id == event.id);
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
                MaterialPageRoute(
                    builder: (context) => CreateEventsView(widget.user)),
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
                  return EventView(events[index], widget.user);
                })),
      ),
    );
  }
}

class EventView extends StatelessWidget {
  Event event;
  User user;
  EventView(this.event, this.user, {super.key});

  Icon getMailIcon() {
    if (event.rsvpd == null || !event.rsvpd!.contains(user.uid)) {
      return const Icon(Icons.mail);
    }
    return const Icon(Icons.mail, color: Colors.blueAccent);
  }

  //Updates rsvps
  void _updateRVSPs() {
    var ref = FirebaseDatabase.instance.ref().child('events');
    List<String> rsvpd = event.rsvpd ?? [];
    List<String> rsvpdURLs = event.rsvpdURLs ?? [];
    List<String> rsvpdNames = event.rsvpdNames ?? [];

    if (!rsvpd.contains(user.uid)) {
      rsvpd.add(user.uid);
      rsvpdNames.add(user.name);
      rsvpdURLs.add(user.imageURL);

      ref.child(event.id).child('rsvpd').set(rsvpd).then((_) {
        print("sent rsvp");
      }).catchError((error) {
        print("Error sending rsvp");
      });

      ref.child(event.id).child('rsvpdNames').set(rsvpdNames).then((_) {
        print("sent rsvpd name");
      }).catchError((error) {
        print("Error sending rsvpd names");
      });

      ref.child(event.id).child('rsvpdURLs').set(rsvpdURLs).then((_) {
        print("sent rsvpd urls");
      }).catchError((error) {
        print("Error sending rsvpd urls");
      });
    } else {
      //Remove likes
      rsvpdURLs.remove(user.imageURL);
      rsvpd.remove(user.uid);
      rsvpdNames.remove(user.name);

      ref.child(event.id).child('rsvpd').set(rsvpd).then((_) {
        print("removed rsvp");
      }).catchError((error) {
        print("Error removing rsvp");
      });

      ref.child(event.id).child('rsvpdNames').set(rsvpdNames).then((_) {
        print("removed rsvp name");
      }).catchError((error) {
        print("Error removing names");
      });

      ref.child(event.id).child('rsvpdURLs').set(rsvpdURLs).then((_) {
        print("removed rsvp URL");
      }).catchError((error) {
        print("Error removing rsvp URL");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventDetailsView(event)),
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
                  backgroundImage: NetworkImage(event.authorURL),
                  maxRadius: 20,
                ),
                Container(
                  //TODO: remove hard-coded height
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
                  event.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    event.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      IconButton(
                          icon: getMailIcon(),
                          onPressed: _updateRVSPs,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("${event.rsvpd?.length ?? 0}"),
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
