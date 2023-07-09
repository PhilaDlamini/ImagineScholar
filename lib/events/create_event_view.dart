import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imaginine_scholar/posts/quoted_post_view.dart';
import 'package:intl/intl.dart';

import '../models/Event.dart';
import '../models/Post.dart';
import '../models/User.dart';

class CreateEventsView extends StatefulWidget {
  User user;

  CreateEventsView(this.user, {super.key});

  @override
  State<StatefulWidget> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEventsView> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  DateTime? eventDate = DateTime.now();
  TimeOfDay? eventTime = TimeOfDay.now();

  //Creates the event
  void _create() {
    var ref = FirebaseDatabase.instance.ref();
    Event event = Event(
        titleController.text,
        locationController.text,
        descriptionController.text,
        widget.user.imageURL,
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(eventDate!.toUtc()),
        //TODO: combine with time
        null,
        null,
        null);

    ref.child('events').child(event.id).set(event.toJson()).then((_) {
      print('posted events!');
      Navigator.pop(context);
      descriptionController.text = '';
      locationController.text = '';
      titleController.text = '';
    }).onError((error, stackTrace) {
      print('error sending post! ${error.toString()}');
    });
  }

  //picks the date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != eventDate) {
      setState(() {
        eventDate = picked;
      });
    }
  }

  //picks the time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (eventTime != null && pickedTime != eventTime) {
      setState(() {
        eventTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var outline = OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        borderSide: BorderSide(
          color: Colors.blueAccent,
          width: 1,
        ));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          InkWell(
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Done"),
            ),
            onTap: () {
              if (_formKey.currentState!.validate()) {
                _create();
              }
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          const Padding(padding: EdgeInsets.only(top: 8)),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(fontSize: 18),
                  controller: titleController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.chat),
                      enabledBorder: InputBorder.none,
                      focusedBorder: outline,
                      hintText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Post can't be empty";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  style: TextStyle(fontSize: 18),
                  controller: descriptionController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description),
                      enabledBorder: InputBorder.none,
                      focusedBorder: outline,
                      hintText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Description can't be empty";
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.date_range),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          eventDate != null
                              ? '${eventDate!.toLocal().toString().split(' ')[0]}'
                              : 'No date ',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text("Select Date"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.date_range),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          eventTime != null
                              ? '${eventTime!.format(context)}'
                              : 'No time ',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectTime(context),
                        child: Text("Select Time"),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  style: TextStyle(fontSize: 18),
                  controller: locationController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_city_outlined),
                      enabledBorder: InputBorder.none,
                      focusedBorder: outline,
                      hintText: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Location can't be empty";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
