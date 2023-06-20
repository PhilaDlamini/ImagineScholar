import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imaginine_scholar/main_views/quoted_post_view.dart';

import '../models/Post.dart';
import '../models/User.dart';

class CreatePostView extends StatefulWidget {
  User user;
  Post? quotedPost;

  CreatePostView(this.user, this.quotedPost, {super.key});

  @override
  State<StatefulWidget> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePostView> {
  final _formKey = GlobalKey<FormState>();
  final contentController = TextEditingController();

  //Writes the post
  void _post() {
    print("qouted: ${widget.quotedPost?.id}");
    //post
    var ref = FirebaseDatabase.instance.ref();
    Post post = Post(
        widget.user.name,
        widget.user.imageURL,
        contentController.text,
        null,
        null,
        null,
        widget.quotedPost?.id);
    ref.child('posts').child(post.id).set(post.toJson()).then((_) {
      print('sent post!');
      Navigator.pop(context);
      contentController.text = '';
    }).onError((error, stackTrace) {
      print('error sending post! ${error.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
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
              child: Text("Post"),
            ),
            onTap: () {
              if (_formKey.currentState!.validate()) {
                _post();
              }
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user.imageURL),
                maxRadius: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  widget.user.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 8)),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration.collapsed(
                      hintText: "What's happening",
                      hintStyle: TextStyle(fontSize: 18)),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(fontSize: 18),
                  controller: contentController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Post can't be empty";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          if (widget.quotedPost != null)
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: QuotedPostView(widget.quotedPost!.id),
            )
        ]),
      ),
    );
  }
}
