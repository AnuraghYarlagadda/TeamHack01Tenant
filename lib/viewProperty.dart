import 'dart:collection';

import "package:flutter/material.dart";

class ViewProperty extends StatefulWidget {
  final LinkedHashMap args;
  const ViewProperty(this.args);
  @override
  _ViewPropertyState createState() => _ViewPropertyState();
}

class _ViewPropertyState extends State<ViewProperty> {
  @override
  void initState() {
    super.initState();
    if (widget.args != null) {
      print(widget.args);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
