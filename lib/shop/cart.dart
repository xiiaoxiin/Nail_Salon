import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cycletour/model/user.dart';
import 'package:cycletour/shop/purchaseitems.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'checkout.dart';


class Cart extends StatefulWidget {
  final User user;

  const Cart({Key key, this.user}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  String _titlecenter = "Empty cart list";
  List _cartList;
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _loadMyCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart List',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (content) => PurchaseItems(user: widget.user)),
            );
          },
        ),
        backgroundColor: Colors.purple[100],
      ),
      body: Center(
        child: Column(children: <Widget>[
          if (_cartList.isEmpty)
            Flexible(child: Center(child: Text(_titlecenter)))
          else
            Flexible(child: OrientationBuilder(builder: (context, orientation) {
              return GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 3 / 1,
                  children: List.generate(_cartList.length, (index) {
                    return Padding(
                      padding: EdgeInsets.all(1),
                      child: Container(
                          child: Card(
                              child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              height: orientation == Orientation.portrait
                                  ? 100
                                  : 150,
                              width: orientation == Orientation.portrait
                                  ? 100
                                  : 150,
                              child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      "https://lowtancqx.com/s269957/nailsalon/images/product_pic/${_cartList[index]['prid']}.jpeg",
                                  placeholder: (context, url) =>
                                      new CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error)),
                            ),
                          ),
                          Container(
                              height: 100,
                              child: VerticalDivider(color: Colors.grey)),
                          Expanded(
                              flex: 6,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_cartList[index]['prname'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 5.0),
                                      Text(
                                          "RM" +
                                              (int.parse(_cartList[index]
                                                          ['cartqty']) *
                                                      double.parse(
                                                          _cartList[index]
                                                              ['prprice']))
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurpleAccent)),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () {
                                                  _updateQty(
                                                      index, "removecart");
                                                }),
                                            Text(_cartList[index]['cartqty']),
                                            IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {
                                                  _updateQty(index, "addcart");
                                                })
                                          ]),
                                    ],
                                  ))),
                          Expanded(
                              flex: 1,
                              child: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteCartDialog(index);
                                  }))
                        ],
                      ))),
                    );
                  }));
            })),
          Container(
            child: Row(
              children: [
                Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Total Payment:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("RM" + _total.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurpleAccent)),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 4,
                  child: ElevatedButton(
                      child: Text("Checkout", style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        _payDialog();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.purple[200],
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10))),
                )
              ],
            ),
          ),
        ]),
      ),
    );

  }

  _loadMyCart() {
    http.post(
        Uri.parse(
            "https://lowtancqx.com/s269957/nailsalon/php/load_user_cart.php"),
        body: {"email": widget.user.email}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "No product available";
        _cartList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _cartList = jsondata["cart"];

        _titlecenter = "";
        _total = 0.0;
        for (int i = 0; i < _cartList.length; i++) {
          _total = _total +
              double.parse(_cartList[i]['prprice']) *
                  int.parse(_cartList[i]['cartqty']);
        }
      }
      setState(() {});
    });
  }

  void _updateQty(int index, String s) {
    http.post(
        Uri.parse(
            "https://lowtancqx.com/s269957/nailsalon/php/update_cart.php"),
        body: {
          "email": widget.user.email,
          "op": s,
          "prid": _cartList[index]['prid'],
          "cartqty": _cartList[index]['cartqty']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadMyCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _deleteCart(int index) {
    http.post(
        Uri.parse(
            "https://lowtancqx.com/s269957/nailsalon/php/delete_cart.php"),
        body: {
          "email": widget.user.email,
          "prid": _cartList[index]['prid']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Deleted Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadMyCart();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Delete Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _deleteCartDialog(int index) {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Delete this item from your cart?',
                  style: TextStyle(),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes",
                        style: TextStyle(color: Colors.indigoAccent)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _deleteCart(index);
                    },
                  ),
                  TextButton(
                      child: Text("No",
                          style:
                              TextStyle(color: Colors.indigoAccent)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]),
        context: context);
  }

  void _payDialog() {
    if (_total == 0.0) {
      Fluttertoast.showToast(
          msg: "Amount not available",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.deepPurple,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      showDialog(
          builder: (context) => new AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: new Text(
                    'Proceed with checkout?',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Yes",
                          style:
                              TextStyle(color: Colors.indigoAccent)),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CheckOut(
                                user: widget.user, total: _total),
                          ),
                        );
                      },
                    ),
                    TextButton(
                        child: Text("No",
                            style: TextStyle(
                                color:Colors.indigoAccent)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ]),
          context: context);
    }
  }
}