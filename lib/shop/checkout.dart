import 'package:cycletour/model/order.dart';
import 'package:cycletour/model/user.dart';
import 'package:cycletour/shop/purchaseitems.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

import 'billing.dart';

class CheckOut extends StatefulWidget {
  final double total;
  final User user;

  const CheckOut({Key key, this.user, this.total}) : super(key: key);
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  int _radioValue = 0;
  int _optionValue = 2;
  String _name = "Set it by yourself";
  String _phone = "Set it by yourself";
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController _userlocctrl = new TextEditingController();
  String address = "";
  double screenHeight, screenWidth;
  SharedPreferences prefs;
  var df = new DateFormat("dd-MM-yyyy hh:mm a");
  DateTime _date = DateTime.now();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String _setTime, _setDate;
  String _hour, _minute, _time;
  bool _statusCash = true;
  bool _statusOnline = false;
  String _payMethod = "Cash";
  String _payOption = "Deposit";
  double totalPayable, payAmount = 0;
  String buttonText = "ORDER NOW";

  @override
  void initState() {
    super.initState();
    _loadPref();

    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final now = new DateTime.now();
    String today = DateFormat('hh:mm a').format(now);
    String todaybanner = DateFormat('dd/MM/yyyy').format(now);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Payment Checkout'),
        backgroundColor: Color(0x44000000),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: screenWidth,
                    color: Colors.purple[200],
                    child: Image.asset(
                      'assets/images/payment.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    left: 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                              child: Text(
                            todaybanner,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          SizedBox(height: 5),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          Expanded(
            flex: 7,
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "CUSTOMER DETAILS",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("Email:")),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 7,
                              child: Text(widget.user.email),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("Name:")),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 7,
                              child: Text(widget.user.name),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("Phone Number:")),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 7,
                              child: GestureDetector(
                                  onTap: () => {phoneDialog()},
                                  child: Text(_phone)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(
                      children: [
                        Text(
                          "RECEIVED DATE AND TIME",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          width: 300,
                          child: RichText(
                              softWrap: true,
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyText2,
                                  text:
                                      " Our hours of operation are Tuesday to Sunday, from 9am to 8pm. Please expect a preparation time within 1 day, \nif has any adjustment please contact us early.")),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text("Set Date: ")),
                                Container(
                                    height: 40,
                                    child: VerticalDivider(color: Colors.grey)),
                                Expanded(
                                  flex: 7,
                                  child: InkWell(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(color: Colors.grey)
                                          //color: Colors.grey[200]
                                          ),
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 14),
                                        //textAlign: TextAlign.center,
                                        enabled: false,
                                        keyboardType: TextInputType.text,
                                        controller: _dateController,
                                        onSaved: (String val) {
                                          _setDate = val;
                                        },
                                        decoration: InputDecoration(
                                            icon: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 30, 0),
                                              child: Icon(Icons
                                                  .calendar_today_outlined),
                                            ),
                                            disabledBorder:
                                                UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                            contentPadding: EdgeInsets.all(2)),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(flex: 3, child: Text("Set Time: ")),
                              Container(
                                  height: 40,
                                  child: VerticalDivider(color: Colors.grey)),
                              Expanded(
                                flex: 7,
                                child: InkWell(
                                  onTap: () {
                                    _selectTimes(context);
                                  },
                                  child: Container(
                                    //margin: EdgeInsets.only(top: 30),
                                    width: 30,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Colors.grey)),
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 14),
                                      //textAlign: TextAlign.center,
                                      onSaved: (String val) {
                                        _setTime = val;
                                      },
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: _timeController,
                                      decoration: InputDecoration(
                                          icon: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 30, 0),
                                            child: Icon(Icons.timer),
                                          ),
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide.none),
                                          // labelText: 'Time',
                                          contentPadding: EdgeInsets.all(2)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text(
                          "DELIVERY ADDRESS",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                                flex: 6,
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _userlocctrl,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Search/Enter address'),
                                      keyboardType: TextInputType.multiline,
                                      minLines:
                                          4, //Normal textInputField will be displayed
                                      maxLines:
                                          4, // when user presses enter it will adapt to it
                                    ),
                                  ],
                                )),
                            Container(
                                height: 120,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 150,
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        color: Theme.of(context).accentColor,
                                        elevation: 3,
                                        onPressed: () => {_getUserCurrentLoc()},
                                        child: Text("Location",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white)),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      height: 2,
                                    ),
                                    // Container(
                                    //   width: 150,
                                    //   child: MaterialButton(
                                    //     shape: RoundedRectangleBorder(
                                    //         borderRadius:
                                    //             BorderRadius.circular(5)),
                                    //     color: Theme.of(context).accentColor,
                                    //     elevation: 3,
                                    //     onPressed: () async {
                                    //       Delivery _del =
                                    //           await Navigator.of(context).push(
                                    //         MaterialPageRoute(
                                    //           builder: (context) => MapPage(),
                                    //         ),
                                    //       );
                                    //       print(address);
                                    //       setState(() {
                                    //         _userlocctrl.text = _del.address;
                                    //       });
                                    //     },
                                    //     child: Text("Map",
                                    //         style: TextStyle(
                                    //             fontSize: 14,
                                    //             color: Colors.white)),
                                    //   ),
                                    // ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              "PAYMENT METHOD",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Cash"),
                                new Radio(
                                  value: 0,
                                  groupValue: _radioValue,
                                  onChanged: (int value) {
                                    _handleRadioValueChange1(value);
                                  },
                                ),
                                Text("Online"),
                                new Radio(
                                  value: 1,
                                  groupValue: _radioValue,
                                  onChanged: (int value) {
                                    if (_payOption == "Deposit") {
                                      payAmount = widget.total * 0.1;
                                    } else {
                                      payAmount = widget.total;
                                    }

                                    _handleRadioValueChange1(value);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 2,
                        ),
                        Visibility(
                          visible: _statusCash,
                          child: Container(
                            height: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "This payment will be made  by cash \nafter receive items from our shop."),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _statusOnline,
                          child: Container(
                            height: 90,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "Each deposit payment will be charge 10% from the total cost."),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Deposit"),
                                      new Radio(
                                        value: 2,
                                        groupValue: _optionValue,
                                        onChanged: (int value) {
                                          _payOption = "Deposit";
                                          payAmount = widget.total * 0.1;
                                          _handleRadioValueChange2(value);
                                        },
                                      ),
                                      Text("Full Payment"),
                                      new Radio(
                                        value: 3,
                                        groupValue: _optionValue,
                                        onChanged: (int value) {
                                          _payOption = "Full Payment";
                                          payAmount = widget.total;
                                          _handleRadioValueChange2(value);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                SizedBox(height: 10),
                Container(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                      child: Text(
                        "TOTAL AMOUNT PAYABLE : RM " +
                            widget.total.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Visibility(
                      visible: _statusOnline,
                      child: Text(
                        "RM " + payAmount.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                    ),
                    Container(
                      width: screenWidth / 2.5,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Theme.of(context).accentColor,
                        elevation: 3,
                        onPressed: () {
                          _orderDialog();
                        },
                        child: Text(buttonText,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: "Hind")),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          _payMethod = "Cash";
          _payOption = "NA";
          payAmount = 0;
          buttonText = "ORDER NOW";
          _statusOnline = false;
          _statusCash = true;
          break;
        case 1:
          _payMethod = "Online";
          buttonText = "BILLING NOW";
          _statusOnline = true;
          _statusCash = false;
          break;
      }
    });
  }

  void _handleRadioValueChange2(int value) {
    //double totalPayable;
    setState(() {
      _optionValue = value;
      switch (_radioValue) {
        case 2:
          _payOption = "Deposit";
          payAmount = widget.total * 0.1;
          break;
        case 3:
          _payOption = "Full Payment";
          payAmount = widget.total;
          break;
      }
      print(payAmount);
    });
  }

  void phoneDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Your Phone Number?"),
            content: new Container(
              height: 50,
              width: 300,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child:
                    Text("Submit", style: TextStyle(color: Colors.purple[300])),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _phone = phoneController.text;

                  prefs = await SharedPreferences.getInstance();
                  await prefs.setString("phone", _phone);

                  setState(() {});
                },
              ),
            ],
          );
        });
  }

  Future<void> _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    _name = prefs.getString("name") ?? 'Set it by yourself';
    _phone = prefs.getString("phone") ?? 'Set it by yourself';
    setState(() {});
  }

  _getUserCurrentLoc() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: Text("Searching address"), title: Text("Locating..."));
    progressDialog.show();
    await _determinePosition().then((value) => {_getPlace(value)});
    setState(
      () {},
    );
    progressDialog.dismiss();
  }

  void _getPlace(Position pos) async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    // this is all you need
    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    address = name +
        "," +
        subLocality +
        ",\n" +
        locality +
        "," +
        postalCode +
        ",\n" +
        administrativeArea +
        "," +
        country;
    _userlocctrl.text = address;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(days: 1)),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now().add(Duration(days: 1)),
        lastDate: DateTime(2025));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
  }

  Future<Null> _selectTimes(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );

    if (picked != null) {
      if (picked.hour > 19 ||
          picked.hour == 19 && picked.minute > 0 ||
          picked.hour < 9) {
        Fluttertoast.showToast(
            msg: "Invalid time selection",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  void _orderDialog() {
    if (_phone == "Set it by yourself" ||
        _userlocctrl.text == "" ||
        _dateController.text ==
            DateFormat('dd/MM/yyyy').format(DateTime.now())) {
      Fluttertoast.showToast(
          msg: "Not a completed detail",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.deepPurple,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (buttonText == "CONTINUE BILLING") {
      showDialog(
          builder: (context) => new AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: new Text(
                    "Continue billing with total amount payable of RM" +
                        widget.total.toStringAsFixed(2) +
                        "?",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Yes",
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Order _order = new Order(
                            phone: _phone,
                            date: _dateController.text,
                            time: _timeController.text,
                            address: _userlocctrl.text.replaceAll("\n", ""),
                            payMethod: _payMethod,
                            payOption: _payOption,
                            payAmount: payAmount.toStringAsFixed(2),
                            totalPayable: widget.total.toStringAsFixed(2));
                        placeOrder();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                PurchaseItems(user: widget.user),
                          ),
                        );
                      },
                    ),
                    TextButton(
                        child: Text("No",
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ]),
          context: context);
    } else {
      showDialog(
          builder: (context) => new AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: new Text(
                    'Pay RM ' + payAmount.toStringAsFixed(2) + "?",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Yes",
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Order _order = new Order(
                            phone: _phone,
                            date: _dateController.text,
                            time: _timeController.text,
                            address: _userlocctrl.text.replaceAll("\n", ""),
                            payMethod: _payMethod,
                            payOption: _payOption,
                            payAmount: payAmount.toStringAsFixed(2),
                            totalPayable: widget.total.toStringAsFixed(2));
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                Billing(user: widget.user, order: _order),
                          ),
                        );
                      },
                    ),
                    TextButton(
                        child: Text("No",
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ]),
          context: context);
    }
  }

  Future<void> placeOrder() async {
    String email = widget.user.email;
    String total = widget.total.toStringAsFixed(2);

    http.post(
        Uri.parse("https://lowtancqx.com/s269957/nailsalon/php/place_order.php"),
        body: {
          "email": email,
          "total": total,
        }).then((response) {
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Billing Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {});
      } else {
        Fluttertoast.showToast(
            msg: "Billing Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}

