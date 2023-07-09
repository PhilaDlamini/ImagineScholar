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
  String timestamp = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now().toUtc());

  Post(this.author, this.authorURL, this.content, this.comments, this.likes,
      this.likedURLs, this.quotedPostId);

  String getLikedByText() {
    var num = likes?.length ?? 0;
    if(num == 0) {
      return "No likes";
    } else if(num == 1) {
      return "Liked by 1 person";
    }
    return "Liked by $num people";
  }

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
