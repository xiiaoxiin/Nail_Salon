import 'package:cycletour/drawersector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'model/user.dart';

class UserProfile extends StatefulWidget {
  final User user;

  const UserProfile({Key key, this.user}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'User Profile',
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 150.0,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 20.0,
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 120.0,
                              width: 120.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60.0),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 3.0,
                                      offset: Offset(0, 4.0),
                                      color: Colors.black38),
                                ],
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/profilepica.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1, 
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: Colors.purple[100],
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.account_circle_sharp),
                              title: Text("Name"),
                              subtitle: Text(widget.user.name),
                              trailing: Icon(Icons.arrow_forward_ios_sharp),
                            ),
                            Divider(
                              height: 10.0,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Icon(Icons.email),
                              title: Text("Email Address"),
                              subtitle: Text(widget.user.email),
                            ),
                            Divider(
                              height: 10.0,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Icon(Icons.phone),
                              title: Text("Phone Number"),
                              subtitle: Text("Create now"),
                              trailing: Icon(Icons.arrow_forward_ios_sharp),
                            ),
                            Divider(
                              height: 10.0,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Icon(Icons.location_on),
                              title: Text("Address"),
                              subtitle: Text("Create now"),
                              trailing: Icon(Icons.arrow_forward_ios_sharp),
                            ),
                            Divider(
                              height: 3.0,
                              color: Colors.grey,
                            ),
                          ],
                        ))),
                SizedBox(
                  height: 10.0,
                ),
                Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.edit_attributes),
                              title: Text("Change Password",
                                  style: TextStyle(fontSize: 20)),
                              trailing: Icon(Icons.edit),
                              onLongPress: () => {},
                            ),
                          ],
                        ))),
              ],
            ),
          ),
        ));
  }
}
