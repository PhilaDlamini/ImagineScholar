import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Event.dart';
import '../shared_methods.dart';

class EventDetailsView extends StatefulWidget {
  Event event;

  EventDetailsView(this.event, {super.key});

  @override
  State<StatefulWidget> createState() => EventDetailsState();
}

class EventDetailsState extends State<EventDetailsView> {

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
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.event.authorURL),
                    maxRadius: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(getDisplayTime(widget.event.date))
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 56, bottom: 8),
                child: Text(
                  widget.event.description,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.access_time_sharp),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(widget.event.getDisplayTime()),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.location_city_outlined),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(widget.event.location),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.email),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(widget.event.getGoingText()),
                    )
                  ],
                ),
              ),
              if (widget.event.rsvpd != null)
                Container(
                  height: 100,
                  padding: EdgeInsets.only(top: 16),
                  child: ListView.builder(
                    itemCount: widget.event.rsvpdURLs?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                widget.event.rsvpdURLs!.elementAt(index)),
                            maxRadius: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(widget.event.rsvpdNames!.elementAt(index)),
                          )
                        ],
                      );
                    },
                  ),
                )
            ],
          )),
    );
  }
}
