import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Post.dart';

class QuotedPostView extends StatefulWidget {
  final String postId;

  QuotedPostView(this.postId, {super.key});

  @override
  State<StatefulWidget> createState() => _QuotedPostViewState();
}

class _QuotedPostViewState extends State<QuotedPostView> {
  var post;

  @override
  void initState() {
    super.initState();
    var ref = FirebaseDatabase.instance.ref();

    //read the lists of posts
    ref.child('posts').child(widget.postId).get().then((snapshot) {
      if (snapshot.value != null) {
        var postData = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          post = Post.fromDict(postData);
        });
      } else {
        // Data does not exist at the specified path
        print('No data found');
      }
    }).catchError((error) {
      // Handle any errors that occur during the read operation
      print('Error reading data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return post == null
        ? Container() //wait till ready
        : Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(post.authorURL),
                        maxRadius: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          post.author,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(post.getDisplayTime()))
                    ],
                  ),
                  Text(
                    post.content,
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
            ));
  }
}
