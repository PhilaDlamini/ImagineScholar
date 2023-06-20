import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imaginine_scholar/main_views/quoted_post_view.dart';

import '../models/Post.dart';
import '../models/User.dart';

class CreateEventsView extends StatefulWidget {
  CreateEventsView({super.key});

  @override
  State<StatefulWidget> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEventsView> {
  final _formKey = GlobalKey<FormState>();
  final contentController = TextEditingController();

  //Writes the post
  void _create() {
    // print("qouted: ${widget.quotedPost?.id}");
    // //post
    // var ref = FirebaseDatabase.instance.ref();
    // ref.child('posts').child(post.id).set(post.toJson()).then((_) {
    //   print('sent post!');
    //   Navigator.pop(context);
    //   contentController.text = '';
    // }).onError((error, stackTrace) {
    //   print('error sending post! ${error.toString()}');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Events"),
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
              child: Text("Create"),
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
                  keyboardType: TextInputType.multiline,
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
        ]),
      ),
    );
  }
}
