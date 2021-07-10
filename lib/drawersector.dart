import 'package:cycletour/feedscreen.dart';
import 'package:cycletour/shop/purchaseitems.dart';
import 'package:cycletour/userProfile.dart';
import 'package:flutter/material.dart';

import 'loginscreen.dart';
import 'mainscreen.dart';
import 'model/user.dart';

class DrawerSector extends StatefulWidget {
  final User user;

  const DrawerSector({Key key, this.user}) : super(key: key);
  @override
  _DrawerSectorState createState() => _DrawerSectorState();
}

class _DrawerSectorState extends State<DrawerSector> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountEmail: Text(widget.user.email),
          currentAccountPicture: CircleAvatar(
            backgroundColor:
                Theme.of(context).platform == TargetPlatform.android
                    ? Colors.white
                    : Colors.purpleAccent,
            backgroundImage: AssetImage(
              "assets/images/profilepica.png",
            ),
            radius: 50.0,
          ),
          accountName: Text(widget.user.name),
        ),
        ListTile(
            title: Text("Dashboard"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(
                            user: widget.user,
                          )));
            }),
        ListTile(
            title: Text("Purchase Item"),
            trailing: Icon(Icons.shopping_bag,color:Colors.indigoAccent),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => PurchaseItems(
                            user: widget.user,
                          )));
            }),
        ListTile(
            title: Text("Post"),
            trailing: Icon(Icons.explore,color:Colors.indigoAccent),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => FeedScreen(
                            user: widget.user,
                            curtab: 0,
                          )));
            }),
        ListTile(
            title: Text("My Profile"),
            trailing: Icon(Icons.account_box,color:Colors.indigoAccent),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => UserProfile(
                            user: widget.user,
                          )));
            }),
        ListTile(
            title: Text("Logout"),
            trailing: Icon(Icons.logout,color:Colors.indigoAccent),
            onTap: () {
              Navigator.pop(context);
              _logout();
            })
      ],
    ));
  }

  void _logout() {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Do you want logout?',
                  style: TextStyle(),
                ),
                content: new Text(
                  'Are your sure?',
                  style: TextStyle(),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes",
                        style: TextStyle(color: Colors.deepPurpleAccent)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => LoginScreen()));
                    },
                  ),
                  TextButton(
                      child: Text("No",
                          style:
                              TextStyle(color: Colors.deepPurpleAccent)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]),
        context: context);
  }
}
