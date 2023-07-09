import 'dart:core';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Event {
  var id = Uuid().v4();
  String name;
  String location;
  String description;
  String authorURL;
  String date;
  List<String>? rsvpd; //list of users who rsvpd
  List<String>? rsvpdNames; //their names
  List<String>? rsvpdURLs; //their images

  Event(this.name, this.location, this.description, this.authorURL, this.date,
      this.rsvpd, this.rsvpdNames, this.rsvpdURLs);

  String getGoingText() {
    var num = rsvpd?.length ?? 0;
    if(num == 0) {
      return "No one is going";
    } else if(num == 1) {
      return "1 person is going";
    }
    return "$num people are going";
  }

  String getDisplayTime() {
    return "time";
  }

  static fromDict(Map<dynamic, dynamic> data) {
    var event = Event(
      data['name'],
      data['location'],
      data['description'],
      data['authorURL'],
      data['date'],
      data['rsvpd']?.toList().cast<String>(),
      data['rsvpdNames']?.toList().cast<String>(),
      data['rsvpdURLs']?.toList().cast<String>(),
    );
    event.id = data['id'];
    return event;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'authorURL': authorURL,
      'date': date,
      'rsvpd': rsvpd,
      'rsvpdNames': rsvpdNames,
      'rsvpdURLs': rsvpdURLs
    };
  }
}
