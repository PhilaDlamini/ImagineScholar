import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imaginine_scholar/models/Announcement.dart';
import '../models/User.dart';

class CreateAnnouncementView extends StatefulWidget {
  User user;
  CreateAnnouncementView(this.user, {super.key});

  @override
  State<StatefulWidget> createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncementView> {
  final _formKey = GlobalKey<FormState>();
  final announcementController = TextEditingController();
  DateTime? expirationDate = DateTime.now();

  //Creates the event
  void _create() {
    var ref = FirebaseDatabase.instance.ref();
    Announcement annos = Announcement(widget.user.name,
      widget.user.imageURL,
      announcementController.text,
      expirationDate!.toIso8601String(),
      null
    );

    ref.child('announcements').child(annos.id).set(annos.toJson()).then((_) {
      print('posted announcement!');
      Navigator.pop(context);
      announcementController.text = '';
    }).onError((error, stackTrace) {
      print('error sending announcement! ${error.toString()}');
    });
  }

  //picks the date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        expirationDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const outline = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        borderSide:  BorderSide(
          color: Colors.blueAccent,
          width: 1,
        ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Announce"),
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
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
                  controller: announcementController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.chat),
                      enabledBorder: InputBorder.none,
                      focusedBorder: outline,
                      hintText: 'Announcement'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Announcement can't be empty";
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
                          expirationDate != null
                              ? '${expirationDate!.toLocal().toString().split(' ')[0]}'
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
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
