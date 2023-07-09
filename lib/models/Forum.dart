import 'dart:core';
import 'package:uuid/uuid.dart';

class Forum {
  String id = Uuid().v4();
  String question;
  List<ForumResponse>? responses;

  Forum(this.question, this.responses);

  static fromDict(Map<dynamic, dynamic> data) {
    var forum = Forum(
      data['question'],
      data['responses']
          ?.map((e) => ForumResponse.fromDict(e))
          .toList()
          .cast<ForumResponse>(),
    );
    forum.id = data['id'];
    return forum;
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'question': question};
  }
}

class ForumResponse {
  String id = Uuid().v4();
  String? authorName;
  String? authorURL;
  String? quotedResponse;
  String response;
  String date = DateTime.now().toIso8601String();

  ForumResponse(this.response);

  static fromDict(Map<dynamic, dynamic> data) {
    var response = ForumResponse(
      data['response'],
    );
    response.id = data['id'];
    response.authorName = data['authorName'];
    response.authorURL = data['authorURL'];
    response.quotedResponse = data['quotedResponse'];
    response.date = data['date'];
    return response;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'authorURL': authorURL,
      'quotedResponse': quotedResponse,
      'response': response,
      'date': date
    };
  }
}
