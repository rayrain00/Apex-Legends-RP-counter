import 'dart:convert';
import 'dart:math';

import 'package:Apex_RP_Counter/models/Record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enums/Rank.dart';

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
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Record record = Record();

  @override
  void initState() {
    super.initState();
    loadRecord();
  }

  void loadRecord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String recordString = prefs.getString(RECORD_KEY);
    Map<String, dynamic> recordMap = jsonDecode(recordString);
    Record newRecord = Record.fromJson(recordMap);
    updateRecord(newRecord);
  }

  void updateRecord(Record newRecord) {
    setState(() => record = newRecord);
    updateRP();
  }

  void updateRP() {
    int value = 0;

    switch(record.rank) {
      case Rank.predetor:
      case Rank.master:
        value -= 60;
        break;
      case Rank.diamond:
        value -= 48;
        break;
      case Rank.platinum:
        value -= 36;
        break;
      case Rank.gold:
        value -= 36;
        break;
      case Rank.silver:
        value -= 24;
        break;
      case Rank.bronze:
        value -= 12;
        break;
    }

    int rate = 10;
    switch(record.ranking) {
      case 1:
        value += 100;
        rate = 25;
        break;
      case 2:
        value += 60;
        rate = 20;
        break;
      case 3:
        value += 40;
        rate = 20;
        break;
      case 4:
        value += 40;
        rate = 15;
        break;
      case 5:
        value += 30;
        rate = 15;
        break;
      case 6:
        value += 30;
        rate = 12;
        break;
      case 7:
      case 8:
        value += 20;
        rate = 12;
        break;
      case 9:
      case 10:
        value += 10;
        rate = 12;
        break;
      case 11:
      case 12:
      case 13:
        value += 5;
        break;
    }

    value += rate * min(record.kill + record.assist, 6);

    Record newRecord = record;
    newRecord.rp = value;
    setState(() => record = newRecord);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Apex Legends RP Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Rank',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Picker picker = Picker(
                      adapter: PickerDataAdapter<String>(pickerdata: Rank.values.map((rank) {
                        return rank.toShortString();
                      }).toList()),
                      onConfirm: (Picker picker, List _) {
                        Record newRecord = record;
                        newRecord.rank = parseStringToRank[picker.getSelectedValues()[0]];
                        updateRecord(newRecord);
                      },
                    );
                    picker.show(_scaffoldKey.currentState);
                  },
                  child: Text(record.rank.toShortString()),
                ),
              ],
            ),
            Counter(
              name: 'Ranking',
              counter: record.ranking,
              setCounter: (value) {
                Record newRecord = record;
                newRecord.ranking = value;
                updateRecord(newRecord);
              },
              minValue: 1,
              maxValue: 20,
            ),
            Counter(
              name: 'Kill',
              counter: record.kill,
              setCounter: (value) {
                Record newRecord = record;
                newRecord.kill = value;
                updateRecord(newRecord);
              },
            ),
            Counter(
              name: 'Assist',
              counter: record.assist,
              setCounter: (value) {
                Record newRecord = record;
                newRecord.assist = value;
                updateRecord(newRecord);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Damage',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      Record newRecord = record;
                      newRecord.damage = int.parse(value);
                      updateRecord(newRecord);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'RP',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  record.rp.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Record newRecord = record;
                newRecord.playedAt = DateTime.now();
                updateRecord(newRecord);

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString(RECORD_KEY, jsonEncode(record.toJson()));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Saved!'),
                ));
              },
              icon: Icon(Icons.save),
              label: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class Counter extends StatelessWidget {
  final String name;
  final int counter;
  final Function setCounter;
  final int minValue;
  final int maxValue;
  
  Counter({
    this.name,
    this.counter,
    this.setCounter,
    this.minValue = 0,
    this.maxValue = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                setCounter(max(counter - 1, minValue));
              }
            ),
            NumberPicker(
              minValue: minValue,
              maxValue: maxValue,
              value: counter,
              onChanged: (value) {
                setCounter(value);
              },
              itemHeight: 32,
            ),
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                setCounter(min(counter + 1, maxValue));
              }
            ),
          ],
        ),
      ],
    );
  }
}
