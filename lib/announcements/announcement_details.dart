import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imaginine_scholar/list_item.dart';

import '../models/Announcement.dart';
import '../models/User.dart';

class AnnouncementDetailsView extends StatefulWidget {
  User user;
  Announcement announcement;

  AnnouncementDetailsView(this.user, this.announcement, {super.key});

  @override
  State<StatefulWidget> createState() => _AnnouncementDetailsState();
}

class _AnnouncementDetailsState extends State<AnnouncementDetailsView> {
  final _formKey = GlobalKey<FormState>();
  final followUpController = TextEditingController();

  void followUp() {
    var ref = FirebaseDatabase.instance.ref().child('announcements');
    FollowUp followup = FollowUp(widget.user.name, widget.user.imageURL, followUpController.text, null);
    var followups = widget.announcement.followups ?? [];
    followups.add(followup);

    //convert each to a dict
    List<Map<String, dynamic>> coms = [];
    for(var followup in followups) {
      coms.add(followup.toJson());
    }

    ref.child(widget.announcement.id).child('followups').set(coms).then((_) {
      print('sent follow up');
      setState(() {
        followUpController.text = '';
      });
    }).catchError((error) {
      print("Error adding followup ${error.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Announcement"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.announcement.authorURL),
                        maxRadius: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.announcement.author,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(widget.announcement.getDisplayTime())
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 56, bottom: 8),
                    child: Text(
                      widget.announcement.content,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.blur_linear),
                      const Padding(padding: EdgeInsets.only(left: 8)),
                      Text(
                          '${widget.announcement.followups?.length ?? 0} people followed up')
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  color: Colors.grey,
                  height: 1,
                ),
              ),
              if (widget.announcement.followups != null)
              Column(
                children: widget.announcement.followups!.map((e) =>
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                              NetworkImage(e.authorURL),
                              maxRadius: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.author,
                                    style: const TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.mark_chat_read)
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Text(
                            e.content,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    )
                ).toList().cast<Widget>(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Form (
                      key: _formKey,
                      child: TextFormField(
                        style: TextStyle(fontSize: 18),
                        controller: followUpController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "FollowUp can't be empty";
                          }
                          return null;
                        },
                      ),
                  ),
                    ), Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            if(_formKey.currentState!.validate()) {
                              followUp();
                            }
                          }, icon: Icon(Icons.send)),

                    )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
