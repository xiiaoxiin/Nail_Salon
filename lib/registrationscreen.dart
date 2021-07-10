import 'package:cycletour/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  ProgressDialog pr;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordControllera = new TextEditingController();
  TextEditingController _passwordControllerb = new TextEditingController();
  double screenHeight, screenWidth;
  bool _isChecked = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Registration...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(40, 10, 40, 5),
                child: Image.asset(
                  'assets/images/nail.png',
                  height: 150,
                  width: 300,
                )),
            SizedBox(height: 5),
            Card(
              margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(
                  children: [
                    Text(
                      'Registration',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    TextField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelText: 'Name', icon: Icon(Icons.person)),
                    ),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email Address', icon: Icon(Icons.email)),
                    ),
                    TextField(
                      controller: _passwordControllera,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.lock),
                        suffix: InkWell(
                          onTap: _togglePass,
                          child: Icon(Icons.visibility),
                        ),
                      ),
                      obscureText: true,
                    ),
                    TextField(
                      controller: _passwordControllerb,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        icon: Icon(Icons.lock),
                        suffix: InkWell(
                          onTap: _togglePass,
                          child: Icon(Icons.visibility),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool value) {
                              _onChange(value);
                            },
                          ),
                          GestureDetector(
                            onTap: _showEULA,
                                                        child: Text('I Agree to Terms  ',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                            )),
                                                      ),
                                                    ]), //
                                                MaterialButton(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    minWidth: 140,
                                                    height: 40,
                                                    child: Text('Register',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        )),
                                                    onPressed: _onRegister,
                                                    color: Colors.purple[300]),
                                                SizedBox(height: 8),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Text('Already Register?', style: TextStyle(fontSize: 13)),
                                          onTap: _alreadyRegister,
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                                  )),
                                );
                              }
                            
                              void _alreadyRegister() {
                                Navigator.pop(context);
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (content) => LoginScreen()));
                              }
                            
                              void _onRegister() {
                                String _name = _nameController.text.toString();
                                String _email = _emailController.text.toString();
                                String _passworda = _passwordControllera.text.toString();
                                String _passwordb = _passwordControllerb.text.toString();
                            
                                if (_name.isEmpty ||
                                    _email.isEmpty ||
                                    _passworda.isEmpty ||
                                    _passwordb.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Email/Password is empty",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.deepPurple,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  return;
                                } //checking the data integrity
                            
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                        title: Text("Register new user"),
                                        content: Text("Are your sure?"),
                                        actions: [
                                          TextButton(
                                            child: Text("Yes"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              var passworda = _passworda;
                                              _registerUser(_name, _email, passworda);
                                            },
                                          ),
                                          TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              }),
                                        ],
                                      );
                                    });
                              }
                            
                              Future<void> _registerUser(String name, String email, String password) async {
                                pr = ProgressDialog(context,
                                    type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
                                await pr.show();
                                http.post(
                                    Uri.parse(
                                        "https://lowtancqx.com/s269957/nailsalon/php/register_user.php"),
                                    body: {
                                      "name": name,
                                      "email": email,
                                      "password": password
                                    }).then((response) {
                                  print(response.body);
                                  if (response.body == "success") {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Registration Success. Please check your email for verification link",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.deepPurple,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    //FocusScope.of(context).unfocus();
                                    //_passwordControllerb.clear();
                                    Navigator.of(context);
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (content) => LoginScreen()));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Registration Failed",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.deepPurple,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    pr.hide().then((isHidden) {
                                      print(isHidden);
                                    });
                                  }
                                });
                              }
                            
                              void _togglePass() {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              }
                            
                              void _onChange(bool value) {
                                setState(() {
                                  _isChecked = value;
                                  //savepref(value);
                                });
                              }
                            
                              void _showEULA() {
                                    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("EULA"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and lowtancqx This EULA agreement governs your acquisition and use of our NailSalon software (Software) directly from lowtancqx or indirectly through a lowtancqx authorized reseller or distributor (a Reseller). Please read this EULA agreement carefully before completing the installation process and using the NailSalon software. It provides a license to use the NailSalon software and contains warranty information and liability disclaimers. If you register for a free trial of the NailSalon software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the NailSalon software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by lowtancqx herewith regardless of whether other software is referred to or described herein. The terms also apply to any lowtancqx updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for NailSalon. lowtancqx shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of lowtancqx. lowtancqx reserves the right to grant licences to use the Software to third parties"
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: new Text(
                "Close",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
