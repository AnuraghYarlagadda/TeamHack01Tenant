import 'package:tenant/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tenant/viewProperty.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return (MaterialApp(
      title: "VNR CSE",
      home: Home(),
      debugShowCheckedModeBanner: false,
      routes: {
        "home": (context) => Home(),
        "viewProperty": (context) =>
            ViewProperty(ModalRoute.of(context).settings.arguments),
      },
    ));
  }
}
