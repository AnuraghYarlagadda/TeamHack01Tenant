import 'dart:collection';

import "package:flutter/material.dart";
import 'package:tenant/DataModels/Property.dart';
import 'dart:core';
import 'package:url_launcher/url_launcher.dart';

class ViewProperty extends StatefulWidget {
  final LinkedHashMap args;
  const ViewProperty(this.args);
  @override
  _ViewPropertyState createState() => _ViewPropertyState();
}

class _ViewPropertyState extends State<ViewProperty> {
  Property property;
  Future<void> _launched;
  Uri _emailLaunchUri;
  @override
  void initState() {
    super.initState();
    if (widget.args != null) {
      this.property = widget.args["property"];
      _emailLaunchUri = Uri(
          scheme: 'mailto',
          path: this.property.owner_email,
          queryParameters: {
            'subject': 'Bill due Info',
            "body": "Bill Paid was not reflected"
          });
    }
  }

  Future<void> _mail(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(property.propertyName)),
      body: Center(
          child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(15)),
          Text(
            "Leasetime: " + this.property.leasetime,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          Padding(padding: EdgeInsets.all(15)),
          Text(
            "Rent Amount: " + this.property.rent,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          Padding(padding: EdgeInsets.all(15)),
          Text(
            "Owner: " + this.property.owner_email,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          Padding(padding: EdgeInsets.all(15)),
          RaisedButton(
              onPressed: () {
                _mail(_emailLaunchUri.toString());
              },
              child: Text("Raise ticket by mail"))
        ],
      )),
    );
  }
}
