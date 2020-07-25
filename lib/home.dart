import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  @override
  void initState() {
    super.initState();
    this.user = null;
    this.userLoggedIn = null;
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
    });
  }

  void handleClick(String value) async {
    await signOutGoogle().then((onValue) {
      print(onValue);
      Navigator.of(context).pushReplacementNamed("home");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
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
        body:
            this.userLoggedIn == false ? Login() : Text("Hi" + this.userName));
  }
}
