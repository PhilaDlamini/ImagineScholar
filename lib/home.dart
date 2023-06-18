import 'package:flutter/material.dart';
import 'package:imaginine_scholar/main_views/announcements_view.dart';
import 'package:imaginine_scholar/main_views/forums_view.dart';
import 'package:imaginine_scholar/main_views/posts_view.dart';

import 'main_views/chats_view.dart';
import 'main_views/events_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> pages = <Widget>[
    PostsView(),
    EventsView(),
    ChatsView(),
    AnnouncementsView(),
    ForumsView()
  ];

  //updates the selected item
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
            label: 'Events',
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
