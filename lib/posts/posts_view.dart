import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imaginine_scholar/posts/post_details_view.dart';
import 'package:imaginine_scholar/posts/quoted_post_view.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/Post.dart';
import 'create_posts_view.dart';
import '../models/User.dart' as our;

class PostsView extends StatefulWidget {
  final our.User user;
  const PostsView(this.user, {super.key});

  @override
  State<StatefulWidget> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    var ref = FirebaseDatabase.instance.ref();

    //Listen for post updates
    ref.child('posts').onChildChanged.listen((event) {
      var postData = event.snapshot.value as Map<dynamic, dynamic>;
      var post = Post.fromDict(postData);
      setState(() {
        posts.removeWhere((e) => e.id == post.id);
        posts.add(post);
      });
    });

    ref.child('posts').onChildRemoved.listen((event) {
      var postData = event.snapshot.value as Map<dynamic, dynamic>;
      var post = Post.fromDict(postData);
      setState(() {
        posts.removeWhere((e) => e.id == post.id);
      });
    });

    ref.child('posts').onChildAdded.listen((event) {
      var postData = event.snapshot.value as Map<dynamic, dynamic>;
      var post = Post.fromDict(postData);
      setState(() {
        posts.removeWhere((e) => e.id == post.id);
        posts.add(post);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CreatePostView(widget.user, null)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.opacity),
            onPressed: () {
              print("Going to opportunities view");
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int index) {
                  return PostView(posts[index], widget.user);
                })),
      ),
    );
  }
}

//Displays the actual post itself
class PostView extends StatelessWidget {
  final our.User user;
  final Post post;

  const PostView(this.post, this.user, {super.key});

  //Returns the hear icon
  Icon getHeartIcon() {
    if (post.likes == null || !post.likes!.contains(user!.uid)) {
      return const Icon(Icons.favorite_border);
    }
    return const Icon(Icons.favorite, color: Colors.red);
  }

  //Updates the like
  void _updateLike() {
    var ref = FirebaseDatabase.instance.ref().child('posts');
    List<String> likes = post.likes ?? [];
    List<String> likedUrls = post.likedURLs ?? [];

    //Send like if not liked
    if (!likes.contains(user.uid)) {
      likes.add(user.uid);
      likedUrls.add(user.imageURL);

      ref.child(post.id).child('likes').set(likes).then((_) {
        print("sent like");
      }).catchError((error) {
        print("Error sending like");
      });

      ref.child(post.id).child('likedURLs').set(likedUrls).then((_) {
        print("sent liked urls");
      }).catchError((error) {
        print("Error sending like url");
      });
    } else {
      //Remove likes
      likedUrls.remove(user.imageURL);
      likes.remove(user.uid);

      ref.child(post.id).child('likes').set(likes).then((_) {
        print("removed like");
      }).catchError((error) {
        print("Error removing like");
      });

      ref.child(post.id).child('likedURLs').set(likedUrls).then((_) {
        print("removed liked urls");
      }).catchError((error) {
        print("Error removing like url");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetailsView(post, user)),
        );
      },
      child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(post.authorURL),
                    maxRadius: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      post.author,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Text(post.getDisplayTime())
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 56, bottom: 8),
                child: Text(
                  post.content,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              if (post.quotedPostId != null)
                Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: QuotedPostView(post.quotedPostId!),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 46),
                child: Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: getHeartIcon(),
                          onPressed: _updateLike,
                        ),
                        Text("${post.likedURLs?.length ?? 0}")
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.comment),
                          onPressed: () {
                            print("Love button clicked!");
                          },
                        ),
                        Text("${post.comments?.length ?? 0}")
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.repeat_rounded),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CreatePostView(user, post)),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
