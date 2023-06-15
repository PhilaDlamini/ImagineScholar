
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key});
  @override
  State<StatefulWidget> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text("Posts view")
      ),
    );
  }
}
