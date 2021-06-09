import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cycletour/model/user.dart';
import 'package:cycletour/shop/additems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Purchase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PurchaseItems();
  }
}

class PurchaseItems extends StatefulWidget {
  final User user;

  const PurchaseItems({Key key, this.user}) : super(key: key);
  @override
  _PurchaseItemsState createState() => _PurchaseItemsState();
}

class _PurchaseItemsState extends State<PurchaseItems> {
  double screenHeight, screenWidth;
  int cartitem = 0;
  TextEditingController _searchCtrl = new TextEditingController();
  List _productList = [];
  String _titlecenter = "Loading...";
  GlobalKey<NavigatorState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _testasync();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (_key.currentState.canPop()) {
          _key.currentState.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Purchase Item',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton.icon(
                onPressed: () => {_goToCart()},
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                label: Text(
                  cartitem.toString(),
                  style: TextStyle(color: Colors.white),
                )),
          ],
          backgroundColor: Colors.purple[100],
        ),
        body: Center(
          child: Column(children: [
            Container(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Search Items',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () => _loadProduct(_searchCtrl.text)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                    ),
                  ],
                )),
            if (_productList.isEmpty)
              Flexible(child: Center(child: Text(_titlecenter)))
            else
              Flexible(
                  child: OrientationBuilder(builder: (context, orientation) {
                return StaggeredGridView.countBuilder(
                    padding: EdgeInsets.all(10),
                    crossAxisCount: 2,
                    itemCount: _productList.length,
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.fit(1),
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Column(
                        children: [
                          Container(
                            child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height:
                                            orientation == Orientation.portrait
                                                ? 100
                                                : 150,
                                        width:
                                            orientation == Orientation.portrait
                                                ? 100
                                                : 150,
                                        child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl:
                                                "https://lowtancqx.com/s269957/nailsalon/images/product_pic/${_productList[index]['prid']}.jpeg",
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error)),
                                      ),
                                      Text(
                                          titleSub(
                                              _productList[index]['prname']),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey[800])),
                                      Text(
                                          "Items Type: " +
                                              _productList[index]['prtype'],
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueGrey[800])),
                                      Text(
                                          "Price: RM " +
                                              double.parse(_productList[index]
                                                      ['prprice'])
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueGrey[800])),
                                      Text(
                                          "Quantity: " +
                                              _productList[index]['prqty'],
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blueGrey[800])),
                                      Container(
                                          child: ElevatedButton(
                                        onPressed: () => {addToCart(index)},
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.purple[200])),
                                        child: Text(
                                          "Add to Cart",
                                        ),
                                      ))
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      );
                    });
              })),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.upload_outlined),
          backgroundColor: Colors.purple[300],
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddItems()));
          },
        ),
      ),
    );
  }

  String titleSub(String title) {
    if (title.length > 15) {
      return title.substring(0, 15) + "...";
    } else {
      return title;
    }
  }

  _loadProduct(String prname) {
    http.post(
        Uri.parse(
            "https://lowtancqx.com/s269957/nailsalon/php/load_products.php"),
        body: {"prname": prname}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "Not product available";
        _productList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _productList = jsondata["products"];
        _titlecenter = "";
      }
      setState(() {});
    });
  }

  Future<void> _testasync() async {
    _loadProduct("all");
  }

  addToCart(int index) async {
    String prid = _productList[index]['prid'];

    http.post(
        Uri.parse("https://lowtancqx.com/s269957/nailsalon/php/insert_cart.php"),
        body: {
          // "name": name,
          // "email": email,
          "prid": prid
        }).then((response) {
      print(response.body);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadCart();
      }
    });
  }

  void _loadCart() {
        http.post(Uri.parse("https://lowtancqx.com/s269957/nailsalon/php/loadcartitem.php"),
        body: {
         
          }).then((response) {
      setState(() {
        cartitem = int.parse(response.body);
        print(cartitem);
      });
    });
  }

  _goToCart() async {}
}
