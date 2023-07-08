
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imaginine_scholar/announcements/announcement_details.dart';
import 'package:imaginine_scholar/announcements/create_announcement_view.dart';
import 'package:imaginine_scholar/list_item.dart';
import 'package:imaginine_scholar/models/Announcement.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/User.dart';
class AnnouncementsView extends StatefulWidget {
  final User user;
  const AnnouncementsView(this.user, {super.key});
  @override
  State<StatefulWidget> createState() =>  _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<AnnouncementsView> {
  List<Announcement> annos = [];

  @override
  void initState() {
    super.initState();
    var ref = FirebaseDatabase.instance.ref().child('announcements');

    //Listen for Announcement updates
    ref.onChildChanged.listen((event) {
      var annosData = event.snapshot.value as Map<dynamic, dynamic>;
      var a = Announcement.fromDict(annosData);
      setState(() {
        annos.removeWhere((e) => e.id == a.id);
        annos.add(a);
      });
    });

    ref.onChildRemoved.listen((event) {
      var annosData = event.snapshot.value as Map<dynamic, dynamic>;
      var a = Announcement.fromDict(annosData);
      setState(() {
        annos.removeWhere((e) => e.id == a.id);
      });
    });

    ref.onChildAdded.listen((event) {
      var annosData = event.snapshot.value as Map<dynamic, dynamic>;
      var a = Announcement.fromDict(annosData);
      setState(() {
        annos.removeWhere((e) => e.id == a.id);
        annos.add(a);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcements"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CreateAnnouncementView(widget.user)),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: ListView.builder(
                itemCount: annos.length,
                itemBuilder: (BuildContext context, int index) {
                  Announcement a = annos.elementAt(index);
                  List<Widget> folupsCount = [
                    Row(
                      children: [
                        Icon(Icons.blur_linear),
                        Padding(padding: EdgeInsets.only(left: 8)),
                        Text('${a.followups?.length ?? 0} followups')
                      ],
                    )
                  ];
                  return ListItem(a.authorURL, a.author, a.getDisplayTime(), a.content, folupsCount, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AnnouncementDetailsView(widget.user, a)),
                    );
                  });
                })),
      ),
    );
  }
}
