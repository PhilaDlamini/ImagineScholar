import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imaginine_scholar/main.dart';

import '../models/Post.dart';

class PostDetailsView extends StatefulWidget{
  Post post;
  PostDetailsView(this.post, {super.key});
  @override
  State<StatefulWidget> createState() => _PostDetailsState();

}

class _PostDetailsState extends State<PostDetailsView>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                print("Deleting post");
              },
              //TODO:only show if the user owns the post
              icon: Icon(Icons.delete))
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
                  Padding(padding: EdgeInsets.only(left: 16),
                    child: Text(
                      widget.post.author,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8), child: Text(widget.post.getDisplayTime())
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 56, bottom: 8),
                child: Text(widget.post.content,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Row(
                children: [
                  Text("Liked by ${widget.post.likes?.length ?? 0} people")
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Container(
                  height: 1,
                  color: Colors.blueGrey,
                ),
              ),
              if (widget.post.comments != null)
                Container(
                  height: 200,
                  child: ListView.builder(
                                itemCount: widget.post.comments!.length,
                                itemBuilder: (context, index) {
                                  PostComment comment = widget.post.comments!.elementAt(index);
                                  return CommentView(comment);
                                }
                  ),
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
  const CommentView(this.comment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(comment.imageURL),
                  maxRadius: 10,
                ),
                Padding(padding: EdgeInsets.only(left: 8),
                  child: Text(
                    comment.author,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                IconButton(onPressed: () {
                  print("Responding");
                  },
                    icon: Icon(Icons.reply_all_sharp)
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 32, bottom: 8),
              child: Text(comment.content,
                style: TextStyle(fontSize: 15),
              ),
            ),
            if (comment.responses != null)
              Container(
                height: 200,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(height: 2,);
                  }
              ),
            )
          ],
        )
    );
  }
}

class CommentResponseView extends StatelessWidget {
  final PostCommentResponse response;
  const CommentResponseView(this.response, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          children: [
            Container(
              width: 1,
              color: Colors.blueGrey,
            ),
            Padding(
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
                  Padding(padding: EdgeInsets.only(left: 8),
                    child: Text(
                      response.author,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 32, bottom: 8),
                child: Text(response.content,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ],
        ),
    );
  }

}