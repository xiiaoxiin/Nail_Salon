import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:cycletour/model/user.dart';


class UserProfile extends StatefulWidget {
  final User user;

  const UserProfile({Key key, this.user}) : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  double screenHeight,screenWidth;
  String pathAsset = 'assests/profilepica.png';
  String titlecenter="Loading";
  List userlist;

  @override
  void initState() {
    super.initState();
    _loaduserprofile();
  }
  @override
  Widget build(BuildContext context) {
    return widget.user.name ==null ? Scaffold(
      body: Container(),
    ) :SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          flexibleSpace: Image(
            image: AssetImage("assests/salon.png"),
            fit: BoxFit.cover,
          ),
          centerTitle: true,
          title: Text(
            "USER PROFILE",
            style: TextStyle(
              fontWeight:FontWeight.bold,
              color: Colors.black87,
              fontSize: 24,
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assests/nailpic.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Divider(
                  height: 30,
                  thickness: 1.0,
                  color: Colors.grey[800],
                ),
              ),
              Stack(
                children: [
                  Center(
                    child: Container(
                      height: 390,
                      width: 350,
                      child: new Container(
                        child:Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assests/dec1.jpg"),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 1.0,
                            ),
                            boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))],
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text("Username:",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(widget.user.name,
                          style: TextStyle(
                            fontSize: 14,
                          ),),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text("Email:",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(widget.user.email,
                          style: TextStyle(
                            fontSize: 14,
                          ),),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text("Phone Number:",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text("Add phone number",
                          style: TextStyle(
                            fontSize: 14,
                          ),),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text("Address:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
                        width: 390,
                        child: Text("Add address",
                          style: TextStyle(
                            fontSize: 14,
                          ),),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loaduserprofile() {
        http.post(
        Uri.parse("https://wxxsspecial983.com/findme/php/load_user.php"),
        body: {
          "email": widget.user.email,
        }).then((res){
      print(res.body);
      if (res.body=="nodata"){
        userlist=null;
        titlecenter="No information found";
      }
      else{
        setState(() {
          var jsondata=json.decode(res.body);
          userlist = jsondata["user"];

        });
      }
    }).catchError((err){
      print(err);
    });
  }

}
