import 'dart:core';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Announcement {
  String id = Uuid().v4();
  String author;
  String authorURL;
  String content;
  String expiry;
  String posted = DateTime.now().toIso8601String();
  List<FollowUp>? followups;

  Announcement(this.author, this.authorURL, this.content, this.expiry,
      this.followups);

  getDisplayTime() => "1hr ago";

  static fromDict(Map<dynamic, dynamic> data) {
    var annos = Announcement(
      data['author'],
      data['authorURL'],
      data['content'],
      data['expiry'],
      data['followups']?.map((e) => FollowUp.fromDict(e)).toList().cast<
          FollowUp>(),
    );
    annos.id = data['id'];
    annos.posted = data['posted'];
    return annos;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'authorURL': authorURL,
      'content': content,
      'expiry': expiry,
      'posted': posted,
    };
  }
}

class FollowUp {
  String id = Uuid().v4();
  String author;
  String authorURL;
  String content;
  List<FollowUpResponse>? responses;
  FollowUp(this.author, this.authorURL, this.content, this.responses);

  static fromDict(Map<dynamic, dynamic> data) {
    var folup = FollowUp(
      data['author'],
      data['authorURL'],
      data['content'],
      data['responses']?.map((e) => FollowUpResponse.fromDict(e)).toList().cast<
          FollowUpResponse>(),
    );
    folup.id = data['id'];
    return folup;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'authorURL': authorURL,
      'content': content,
    };
  }
}

class FollowUpResponse {
  String id = Uuid().v4();
  String author;
  String authorURL;
  String content;
  FollowUpResponse(this.author, this.authorURL, this.content);

  static fromDict(Map<dynamic, dynamic> data) {
    var res = FollowUpResponse(
      data['author'],
      data['authorURL'],
      data['content'],
    );
    res.id = data['id'];
    return res;
  }
}

