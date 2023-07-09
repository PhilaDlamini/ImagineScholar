import 'package:flutter/material.dart';
import 'package:imaginine_scholar/announcements/announcements_view.dart';
import 'package:imaginine_scholar/forums/forums_view.dart';
import 'package:imaginine_scholar/posts/posts_view.dart';
import 'package:imaginine_scholar/SharedPref.dart';
import '../models/User.dart' as our;
import 'chats/chats_view.dart';
import 'events/events_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> pages = [];
  our.User? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  //Loads the user
  void loadUser() async {
    try {
      our.User load = our.User.fromJson(await SharedPref.read('user'));
      setState(() {
        user = load;
        print("loaded user! uid is ${user!.uid}");

        pages = <Widget>[
          PostsView(load),
          EventsView(load),
          ChatsView(),
          AnnouncementsView(load),
          ForumsView(load)
        ];
      });
    } on Exception {
      print("Error loading user");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.pages),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_sharp),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send_and_archive_sharp),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi_tethering),
            label: 'Annos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chair),
            label: 'Forums',
          ),
        ],
      ),
    );
  }
}
