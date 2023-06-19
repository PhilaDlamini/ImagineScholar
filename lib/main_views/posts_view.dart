import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imaginine_scholar/main_views/post_details_view.dart';
import 'package:imaginine_scholar/main_views/quoted_post_view.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/Post.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key});
  @override
  State<StatefulWidget> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    var ref = FirebaseDatabase.instance.ref();

    //read the lists of posts
    ref.child('posts').get().then((snapshot) {
      if (snapshot.value != null) {
        for (var child in snapshot.children) {
          var postData = child.value as Map<dynamic, dynamic>;
          var post = Post.fromDict(postData);
          posts.insert(0, post);
        }
      } else {
        // Data does not exist at the specified path
        print('No data found');
      }
    }).catchError((error) {
      // Handle any errors that occur during the read operation
      print('Error reading data: $error');
    });

    //attach listener to data
    ref.onChildAdded.listen((event) {
        // var data = event.snapshot.value as Map<dynamic, dynamic>;
        // posts.add(Post.fromDict(data));
    });

    //TODO: sort posts
    // posts.postsort((a, b) => DateTime.parse(a.timestamp).compareTo(DateTime.parse(b.timestamp)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print("Adding a new post!");
          },
          ),
          IconButton(
            icon: Icon(Icons.opacity),
            onPressed: () {
              print("Going to opportunities view");
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
            child: ListView.separated(
                itemCount: posts.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return PostView(posts[index]);
                })),
      ),
    );
  }
}

//Displays the actual post itself
class PostView extends StatelessWidget {
  final Post post;
  PostView(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetailsView(post)),
        );
      },
      child: Padding (
        padding: EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post.authorURL),
                  maxRadius: 20,
                ),
                Padding(padding: EdgeInsets.only(left: 16),
                child: Text(
                  post.author,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ),
                Spacer(),
                Text(post.getDisplayTime())
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 56, bottom: 8),
              child: Text(post.content,
                style: TextStyle(fontSize: 15),
              ),
            ),
            if (post.quotedPostId != null) QuotedPostView(post.quotedPostId!),
            Padding(
              padding: EdgeInsets.only(left: 46),
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.heart_broken),
                        onPressed: () {
                          print("Love button clicked!");
                        },
                      ),
                      Text("${post.likedURLs?.length ?? 0}")
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          print("Love button clicked!");
                        },
                      ),
                      Text("${post.comments?.length ?? 0}")
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.repeat),
                    onPressed: () {
                      print("clicked to repost!");
                    },
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}