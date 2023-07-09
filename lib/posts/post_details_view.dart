import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imaginine_scholar/main.dart';
import '../models/Post.dart';
import '../models/User.dart';
import '../shared_methods.dart';

/*
 * TODO:Add reply to post comment functionality
 *
 */
class PostDetailsView extends StatefulWidget{
  User user;
  Post post;
  PostDetailsView(this.post, this.user, {super.key});
  @override
  State<StatefulWidget> createState() => _PostDetailsState();

}

class _PostDetailsState extends State<PostDetailsView>{
  final _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();

  void _addComment() {
    var ref = FirebaseDatabase.instance.ref().child('posts');
    PostComment comment = PostComment(widget.user.name, widget.user.imageURL, commentController.text, null);
    var comments = widget.post.comments ?? [];
    comments.add(comment);

    //convert each to a dict
    List<Map<String, dynamic>> coms = [];
    for(var comment in comments) {
      coms.add(comment.toJson());
    }

    ref.child(widget.post.id).child('comments').set(coms).then((_) {
      print('commeneted alright');
      setState(() {
        commentController.text = '';
      });
    }).catchError((error) {
      print("Error adding comment ${error.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if(widget.post.authorURL == widget.user.imageURL)
            IconButton(
              onPressed: () {
                print("Deleting post");
              },
              //TODO:only show if the user owns the post
              icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.post.authorURL),
                    maxRadius: 20,
                  ),
                  Padding(padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      widget.post.author,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8), child: Text(getDisplayTime(widget.post.timestamp))
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 56, bottom: 8),
                child: Text(widget.post.content,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Row(
                children: [
                  Text(widget.post.getLikedByText())
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Container(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              if (widget.post.comments != null)
                Container(
                  height: 500,
                  child: ListView.builder(
                                itemCount: widget.post.comments!.length,
                                itemBuilder: (context, index) {
                                  PostComment comment = widget.post.comments!.elementAt(index);
                                  return CommentView(comment);
                                }
                  ),
                ),
              Row(
                children: [
                  Form (
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          width: 200,
                          child: TextFormField(
                            style: TextStyle(fontSize: 18),
                            controller: commentController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Post can't be empty";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                          if(_formKey.currentState!.validate()) {
                            _addComment();
                          }
                      },
                      icon: Icon(Icons.send, color: Colors.blue,)
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

//For a comment
class CommentView extends StatelessWidget {
  final PostComment comment;
  CommentView(this.comment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(comment.imageURL),
              maxRadius: 10,
            ),
            Padding(padding: const EdgeInsets.only(left: 8),
              child: Text(
                comment.author,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            IconButton(onPressed: () {
              print("Responding");
              },
                icon: const Icon(Icons.reply_all_sharp)
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, bottom: 8),
          child: Text(comment.content,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        if (comment.responses != null)
          Container(
            height: 100,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(height: 2,);
              }
          ),
        ),
      ],
    );
  }
}

class CommentResponseView extends StatelessWidget {
  final PostCommentResponse response;
  const CommentResponseView(this.response, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 1,
          color: Colors.blueGrey,
        ),
        const Padding(
            padding: EdgeInsets.only(left: 32)
        ),
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(response.imageURL),
                maxRadius: 10,
              ),
              Padding(padding: const EdgeInsets.only(left: 8),
                child: Text(
                  response.author,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, bottom: 8),
            child: Text(response.content,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    ],
    );
  }

}