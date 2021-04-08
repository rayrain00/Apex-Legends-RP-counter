import 'dart:math';

import 'package:app/enums/Ranks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:numberpicker/numberpicker.dart';

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
        primaryColor: Colors.red,
      ),
      home: MyHomePage(),
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

  Ranks rank = Ranks.bronze;
  int kill = 0;
  int assist = 0;
  int ranking = 1;
  int rp = 0;

  String getRP() {
    int value = 0;

    switch(rank) {
      case Ranks.predetor:
      case Ranks.master:
        value -= 60;
        break;
      case Ranks.diamond:
        value -= 48;
        break;
      case Ranks.platinum:
        value -= 36;
        break;
      case Ranks.gold:
        value -= 36;
        break;
      case Ranks.silver:
        value -= 24;
        break;
      case Ranks.bronze:
        value -= 12;
        break;
    }

    int rate = 10;
    switch(ranking) {
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

    value += rate * min(kill + assist, 6);

    return value.toString();
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
                Text(
                  rank.toShortString(),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Picker picker = Picker(
                      adapter: PickerDataAdapter<String>(pickerdata: Ranks.values.map((rank) {
                        return rank.toShortString();
                      }).toList()),
                      onConfirm: (Picker picker, List _) {
                        for (int i=0; i<Ranks.values.length; i++) {
                          Ranks value = Ranks.values[i];
                          print(value.toShortString() == picker.getSelectedValues()[0]);
                          if (value.toShortString() == picker.getSelectedValues()[0]) {
                            print(value);
                            setState(() { rank = value; });
                            print(rank);
                            return;
                          }
                        }
                      },
                    );
                    picker.show(_scaffoldKey.currentState);
                  },
                  label: const Text('Change'),
                ),
              ],
            ),
            Counter(
              name: 'Ranking',
              counter: ranking,
              setCounter: (value) {
                setState(() { ranking = value; });
              },
              minValue: 1,
              maxValue: 20,
            ),
            Counter(
              name: 'Kill',
              counter: kill,
              setCounter: (value) {
                setState(() { kill = value; });
              },
            ),
            Counter(
              name: 'Assist',
              counter: assist,
              setCounter: (value) {
                setState(() { assist = value; });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'RP',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  getRP(),
                  style: TextStyle(fontSize: 20),
                ),
              ],
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
                setCounter(counter - 1);
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
                setCounter(counter + 1);
              }
            ),
          ],
        ),
      ],
    );
  }
}
