import 'drawersector.dart';
import 'package:cycletour/posts/latestfeed.dart';
import 'package:cycletour/posts/yourfeed.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart'
    show ConvexAppBar, TabItem, TabStyle;
import 'mainscreen.dart';
import 'package:cycletour/model/user.dart';
import 'package:cycletour/posts/newfeed.dart';

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
  String maintitle = "NailSalon Feed";
  TabController controller;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.curtab;
    tabchildren = [
      LatestFeed(user: widget.user),
      NewFeed(user: widget.user),
      YourFeed(user: widget.user)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        bottomNavigationBar: ConvexAppBar(
            style: TabStyle.flip,
            initialActiveIndex: currentIndex, //
            onTap: onTabTapped,
            backgroundColor: Colors.purple[100],
            items: [
              TabItem(title: "Latest Feed", icon: Icons.people),
              TabItem(title: "New Feed", icon: Icons.camera),
              TabItem(title: "Your Feed", icon: Icons.emoji_events),
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
        maintitle = "Latest Feed";
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
