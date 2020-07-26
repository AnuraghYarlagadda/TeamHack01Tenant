import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tenant/DataModels/Property.dart';
import 'package:tenant/Utils/login.dart';
import 'package:tenant/Utils/signin.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  bool userLoggedIn;
  FirebaseUser user;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String userEmail, userName;
  final fb = FirebaseDatabase.instance;

  var properties;
  @override
  void initState() {
    super.initState();
    this.user = null;
    this.userLoggedIn = null;
    this.properties = new List<Property>();
    checkUserStatus();
  }

  checkUserStatus() async {
    await googleSignIn.isSignedIn().then((onValue) {
      setState(() {
        this.userLoggedIn = onValue;
      });
    });
    if (this.userLoggedIn == true) {
      await getUserDetails();
    }
  }

  getUserDetails() async {
    await FirebaseAuth.instance.currentUser().then((onValue) async {
      setState(() {
        this.user = onValue;
        this.userEmail = onValue.email;
        this.userName = onValue.displayName;
        Fluttertoast.showToast(
            msg: "Welcome " + this.userName,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.cyan,
            textColor: Colors.white);
      });
      print(this.userEmail);
      await getTenantProperties(this.userEmail);
    });
  }

  void handleClick(String value) async {
    await signOutGoogle().then((onValue) {
      print(onValue);
      Navigator.of(context).pushReplacementNamed("home");
    });
  }

  getTenantProperties(String email) async {
    final ref = fb.reference();
    await ref.child("owners").once().then((onValue) {
      try {
        if (onValue.value != null) {
          for (LinkedHashMap<dynamic, dynamic> property
              in onValue.value.values) {
            for (LinkedHashMap<dynamic, dynamic> propertyVal
                in property["property"].values) {
              Property property = Property.fromJson(propertyVal);
              if (property.tenant_email != null &&
                  property.tenant_email == this.userEmail) {
                this.setState(() {
                  this.properties.add(property);
                });
              }
            }
          }
          print(this.properties.length);
        }
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          leading: Icon(Icons.home),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return ['Sign-Out'].map((String choice) {
                  return PopupMenuItem<String>(
                    enabled: this.userLoggedIn,
                    height: MediaQuery.of(context).size.height / 18,
                    value: choice,
                    child: Text(
                      choice,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: this.userLoggedIn == null
            ? Center(
                child: SpinKitFadingCube(color: Colors.pink),
              )
            : this.userLoggedIn == false
                ? Login()
                : this.user == null
                    ? Center(
                        child: SpinKitFadingCube(color: Colors.pink),
                      )
                    : this.properties.length == 0
                        ? Center(
                            child: SpinKitFadingCube(color: Colors.pink),
                          )
                        : Scrollbar(
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: this.properties.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      child: Card(
                                          elevation: 5,
                                          child: ExpansionTile(
                                              title: Text(
                                                  "Property Name: " +
                                                      this
                                                          .properties[index]
                                                          .propertyName,
                                                  style: GoogleFonts.ptSansNarrow(
                                                      textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight
                                                              .w700))),
                                              subtitle: Text("Location: " + this.properties[index].location,
                                                  style: GoogleFonts.inconsolata(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight
                                                              .w600))),
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 10, 5),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "Leasetime: " +
                                                              this
                                                                  .properties[
                                                                      index]
                                                                  .leasetime,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        Text(
                                                          "Rent Amount: " +
                                                              this
                                                                  .properties[
                                                                      index]
                                                                  .rent,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        Text(
                                                          "Owner" +
                                                              this
                                                                  .properties[
                                                                      index]
                                                                  .owner_email,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ],
                                                    ))
                                              ])));
                                })));
  }
}
