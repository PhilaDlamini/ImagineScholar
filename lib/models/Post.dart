import 'dart:core';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Post {
  String id = Uuid().v4();
  String author;
  String authorURL;
  String content;
  List<PostComment>? comments;
  List<String>? likes; //list of UIDs of everyone who liked the post
  List<String>? likedURLs; //pic urls of users who liked the post
  String? quotedPostId; //id of the quoted post
  String timestamp = DateTime.now().toIso8601String();

  Post(this.author, this.authorURL, this.content, this.comments, this.likes,
      this.likedURLs, this.quotedPostId);

  static fromDict(Map<dynamic, dynamic> data) {
    var post = Post(
      data['author'],
      data['authorURL'],
      data['content'],
      data['comments']?.map((e) => PostComment.fromDict(e)).toList().cast<PostComment>(),
      data['likes']?.toList().cast<String>(),
      data['likedURLs']?.toList().cast<String>(),
      data['quotedPostId'],
    );
    post.id = data['id'];
    post.timestamp = data['timestamp'];
    return post;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'authorURL': authorURL,
      'content': content,
      'timestamp': timestamp.toString(),
      'quotedPostId': quotedPostId
    };
  }

  //Returns a readable data
  String getDisplayTime() {
    String val = "";

    //Calculate the date
    DateTime dateTime = DateTime.parse(timestamp);
    Duration diff = DateTime.now().difference(dateTime);

    if(diff.inDays > 7) {
      val = DateFormat.yMd().format(dateTime);
    } else if (diff.inDays >= 1) {
      val = "${diff.inDays} d";
    } else if(diff.inHours >= 1) {
      val = "${diff.inHours} hr";
    } else if(diff.inMinutes >= 1) {
      val = "${diff.inMinutes} min";
    } else {
      val = "${diff.inSeconds} sec";
    }
    return val;
  }
}

class PostComment {
  String id = Uuid().v4();
  String author;
  String imageURL;
  String content;
  List<PostCommentResponse>? responses;

  PostComment(this.author, this.imageURL, this.content, this.responses);

  static fromDict(Map<dynamic, dynamic> data) {
    var comment = PostComment(
        data['author'],
        data['imageURL'],
        data['content'],
        data['responses']
            ?.map((e) => PostCommentResponse.fromDict(e))
            .cast<PostCommentResponse>());
    comment.id = data['id'];
    return comment;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'imageURL': imageURL,
      'content': content,
      'responses': null //NULL for now
    };
  }

}

class PostCommentResponse {
  String id = Uuid().v4();
  String author;
  String imageURL;
  String content;

  PostCommentResponse(this.author, this.imageURL, this.content);

  static fromDict(Map<dynamic, dynamic> data) {
    var resp =
        PostCommentResponse(data['author'], data['imageURL'], data['content']);
    resp.id = data['id'];
    return resp;
  }
}
