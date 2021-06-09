import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:cycletour/drawersector.dart';
import 'package:flutter/material.dart';

import 'mainscreen.dart';
import 'model/user.dart';
import 'posts/latestfeed.dart';
import 'posts/newfeed.dart';
import 'posts/yourfeed.dart';

class FeedScreen extends StatefulWidget {
  final User user;
  final int curtab;
  const FeedScreen({Key key, this.user, this.curtab}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int currentIndex;
  List<Widget> tabchildren;
  String maintitle = "  Posts";
  TabController controller;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.curtab;
    tabchildren = [LatestFeed(), NewFeed(), YourFeed()];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        bottomNavigationBar: ConvexAppBar(
            style: TabStyle.reactCircle,
            height: 50,
            initialActiveIndex: currentIndex, //
            onTap: onTabTapped,
            activeColor: Colors.white,
            backgroundColor: Colors.purple[100],
            items: [
              TabItem(icon: Icons.people),
              TabItem(icon: Icons.filter_vintage),
              TabItem(icon: Icons.emoji_events),
            ]),
        appBar: AppBar(
          title: Text(
            'Feed',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.purple[100],
        ),
        drawer: DrawerSector(user: widget.user),
        body: tabchildren[currentIndex],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
      if (currentIndex == 0) {
        maintitle = "Posts";
      }
      if (currentIndex == 1) {
        maintitle = "New Feed";
      }
      if (currentIndex == 2) {
        maintitle = "Your Feed";
      }
    });
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
            builder: (content) => MainScreen(
                  user: widget.user,
                )));
    return false;
  }
}
