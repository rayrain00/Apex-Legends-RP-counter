import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/RecordListPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apex Legends RP Counter',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        accentColor: Colors.redAccent,
      ),
      home: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: RecordListPage(),
      ),
    );
  }
}
