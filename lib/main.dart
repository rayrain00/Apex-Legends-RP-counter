import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/Counter.dart';
import 'enums/Rank.dart';
import 'models/Record.dart';
import 'pages/RecordListPage.dart';

const List<String> RANKS = ['Bronze', 'Silver', 'Gold', 'Plutinum', 'Diamond', 'Master', 'Predetor'];

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
