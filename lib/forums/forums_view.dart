import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:imaginine_scholar/forums/forum_response_view.dart';
import 'package:imaginine_scholar/models/Announcement.dart';
import '../models/Forum.dart';
import '../models/User.dart';
import '../shared_methods.dart';

class ForumsView extends StatefulWidget {
  final User user;

  const ForumsView(this.user, {super.key});

  @override
  State<StatefulWidget> createState() => _ForumsViewState();
}

class _ForumsViewState extends State<ForumsView> {
  late Forum forum;

  @override
  void initState() {
    super.initState();
    var ref = FirebaseDatabase.instance.ref().child('forums');

    //Get the forum
    ref.get().then((snapshot) {
      if (snapshot.value != null) {
        var forumData = snapshot.value as Map<dynamic, dynamic>;
        forum = Forum.fromDict(forumData);
      }
    });

    //Listen for future changes
    ref.onValue.listen((event) {
      var forumsData = event.snapshot.value as Map<dynamic, dynamic>;
      var forum = Forum.fromDict(forumsData);
      setState(() {
        this.forum = forum;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forums"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(
                        'Question',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForumResponseView(
                                      widget.user, forum, null)),
                            );
                          },
                          icon: Icon(Icons.lightbulb_outline))
                    ]),
                    Text(forum.question)
                  ],
                ),
              ),
            ),
            if (forum.responses != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: forum.responses!
                    .map((response) {
                      return Container(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForumResponseView(
                                      widget.user, forum, response)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  response.authorName ?? "Anonymous",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(getDisplayTime(response.date)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(response.response),
                                ),
                                if (response.quotedResponse != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: QuotedForumView(
                                        response.quotedResponse!),
                                  )
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                    .toList()
                    .cast<Widget>(),
              )
          ],
        ),
      ),
    );
  }
}

class QuotedForumView extends StatefulWidget {
  final String forumId;

  QuotedForumView(this.forumId, {super.key});

  @override
  State<StatefulWidget> createState() => _QuotedForumViewState();
}

class _QuotedForumViewState extends State<QuotedForumView> {
  var forum;

  @override
  void initState() {
    super.initState();
    var ref = FirebaseDatabase.instance.ref();

    //read the lists of posts
    ref.child('forums/responses').get().then((snapshot) {
      if (snapshot.value != null) {
        for (var child in snapshot.children) {
          var resData = child.value as Map<dynamic, dynamic>;
          var curr = ForumResponse.fromDict(resData);
          if (curr.id == widget.forumId) {
            setState(() {
              forum = curr;
            });
          }
        }
      }
    }).catchError((error) {
      // Handle any errors that occur during the read operation
      print('Error reading data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return forum == null
        ? Container() //wait till ready
        : Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    forum.authorName ?? "Anonymous",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(getDisplayTime(forum.date)),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(forum.response),
                  ),
                ],
              ),
            ));
  }
}
