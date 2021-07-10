import 'dart:async';
import 'package:cycletour/model/order.dart';
import 'package:cycletour/model/user.dart';
import 'package:cycletour/shop/purchaseitems.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class Billing extends StatefulWidget {
  final User user;
  final Order order;

  const Billing({Key key,  this.user, this.order}) : super(key: key);

  @override
  _BillingState createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: (){Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) =>
                          PurchaseItems(user: widget.user)));}),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl:
                      'https://lowtancqx.com/s269957/nailsalon/php/generate_bill.php?email=' +
                          widget.user.email +
                          '&mobile=' +
                          widget.order.phone +
                          '&name=' +
                          widget.user.name +
                          '&amount=' +
                          widget.order.payAmount +
                          '&total=' +
                          widget.order.totalPayable,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              )
                
              
            ],
          ),
        ),
      ),
    );
  }
}