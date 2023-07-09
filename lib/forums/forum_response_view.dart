import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:imaginine_scholar/main.dart';
import 'package:imaginine_scholar/models/Announcement.dart';
import '../models/Forum.dart';
import '../models/User.dart';
import '../shared_methods.dart';

class ForumResponseView extends StatefulWidget {
  User user;
  Forum forum;
  ForumResponse? responseQuoting;

  ForumResponseView(this.user, this.forum, this.responseQuoting, {super.key});

  @override
  State<StatefulWidget> createState() => _ForumResponseState();
}

class _ForumResponseState extends State<ForumResponseView> {
  ForumResponse? quoted;
  final _formKey = GlobalKey<FormState>();
  final forumResponseController = TextEditingController();
  bool anonymous = false;

  void _sendResponse() {
    var response = ForumResponse(forumResponseController.text);
    response.quotedResponse = widget.responseQuoting?.id;

    if(!anonymous) {
      response.authorName = widget.user.name;
      response.authorURL = widget.user.imageURL;
    }

    //Send the response
    var ref = FirebaseDatabase.instance.ref().child('forums/responses');
    var responses = widget.forum.responses ?? [];
    responses.add(response);

    //convert each to a dict
    List<Map<String, dynamic>> coms = [];
    for(var res in responses) {
      coms.add(res.toJson());
    }

    ref.set(coms).then((_) {
      print('sent response');
      setState(() {
        forumResponseController.text = '';
      });
    }).catchError((error) {
      print("Error adding comment ${error.toString()}");
    });

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Response"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.forum.question)
                  ],
                ),
              ),
            ),
            if (widget.responseQuoting != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.responseQuoting!.authorName ?? 'Anonymous'} said'),
                  Text(widget.responseQuoting!.response)
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text("Response"),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: forumResponseController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Response can't be empty";
                  }
                  return null;
                },
              ),
            ),
            Row(
              children: [
                Text("Anonymous"),
                Spacer(),
                Checkbox(
                    value: anonymous,
                    onChanged: (value) {
                      setState(() {
                        anonymous = value!;
                      });
                    })
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(children: [
                  Spacer(),
                  TextButton(
                    child: Text("Send"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _sendResponse();
                      }
                    },
                  ),
                  Spacer()
                ]))
          ],
        ),
      ),
    );
  }
}


