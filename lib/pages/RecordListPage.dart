import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/Counter.dart';
import '../enums/Rank.dart';
import '../models/Record.dart';

class RecordListPage extends StatefulWidget {
  @override
  _RecordListPageState createState() => _RecordListPageState();
}

class _RecordListPageState extends State<RecordListPage> {
  List<Record> records = [];

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  int getRP(Record record) {
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
    return value;
  }

  void loadRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Record> newRecords = [];
    final List<String> recordStrings = prefs.getStringList(RECORDS_KEY) ?? [];
    recordStrings.forEach((recordString) {
      final Map<String, dynamic> recordMap = jsonDecode(recordString);
      final Record newRecord = Record.fromJson(recordMap);
      newRecords.add(newRecord);
    });
    setState(() => records = newRecords);
  }

  void updateRecords(List<Record> newRecords) async {
    setState(() => records = newRecords);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recordStrings = [];
    newRecords.forEach((record) {
      recordStrings.add(jsonEncode(record.toJson()));
    });
    prefs.setStringList(RECORDS_KEY, recordStrings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apex Legends RP Counter'),
      ),
      body: 0 < records.length ? ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final Record record = records[index];
          return ExpansionTile(
            title: Text('#${record.ranking.toString()}  ${record.rp.toString()} RP  ${record.kill.toString()} kill  ${record.assist.toString()} assist  ${record.damage.toString()} damage'),
            subtitle: Text('${DateFormat('yyyy-MM-dd kk:mm').format(record.playedAt)}'),
            trailing: Icon(Icons.edit),
            children: [
              Counter(
                name: 'Ranking',
                counter: record.ranking,
                setCounter: (value) {
                  Record newRecord = records[index];
                  newRecord.ranking = value;
                  newRecord.rp = getRP(newRecord);
                  List<Record> newRecords = records;
                  newRecords[index] = newRecord;
                  updateRecords(newRecords);
                },
                minValue: 1,
                maxValue: 20,
              ),
              Counter(
                name: 'Kill',
                counter: record.kill,
                setCounter: (value) {
                  Record newRecord = records[index];
                  newRecord.kill = value;
                  newRecord.rp = getRP(newRecord);
                  List<Record> newRecords = records;
                  newRecords[index] = newRecord;
                  updateRecords(newRecords);
                },
              ),
              Counter(
                name: 'Assist',
                counter: record.assist,
                setCounter: (value) {
                  Record newRecord = records[index];
                  newRecord.assist = value;
                  newRecord.rp = getRP(newRecord);
                  List<Record> newRecords = records;
                  newRecords[index] = newRecord;
                  updateRecords(newRecords);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Damage'),
                  SizedBox(
                    width: 170,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        Record newRecord = records[index];
                        newRecord.damage = int.parse(value);
                        List<Record> newRecords = records;
                        newRecords[index] = newRecord;
                        updateRecords(newRecords);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    child: const Text('Played at'),
                  ),
                  OutlinedButton(
                    child: Text(DateFormat('yyyy-M-dd').format(record.playedAt)),
                    onPressed: () async {
                      DateTime dateTime = await showDatePicker(
                        context: context,
                        initialDate: record.playedAt,
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2030),
                      );
                      DateTime newPlayedAt = DateTime(dateTime.year, dateTime.month, dateTime.day, record.playedAt.hour, record.playedAt.minute);
                      Record newRecord = records[index];
                      newRecord.playedAt = newPlayedAt;
                      List<Record> newRecords = records;
                      newRecords[index] = newRecord;
                      updateRecords(newRecords);
                    },
                  ),
                  OutlinedButton(
                    child: Text(DateFormat('kk:mm').format(record.playedAt)),
                    onPressed: () async {
                      TimeOfDay timeOfDay = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(record.playedAt));
                      DateTime newPlayedAt = DateTime(record.playedAt.year, record.playedAt.month, record.playedAt.day, timeOfDay.hour, timeOfDay.minute);
                      Record newRecord = records[index];
                      newRecord.playedAt = newPlayedAt;
                      List<Record> newRecords = records;
                      newRecords[index] = newRecord;
                      updateRecords(newRecords);
                    }
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  List<Record> newRecords = records;
                  newRecords.removeAt(index);
                  updateRecords(newRecords);
                },
                icon: Icon(Icons.remove),
                label: Text('Delete'),
              )
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: records.length,
      ) : Center(child: Text('No data')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          List<Record> newRecords = records;
          Record newRecord = Record();
          newRecord.rp = getRP(newRecord);
          newRecord.playedAt = DateTime.now();
          newRecords.add(newRecord);
          updateRecords(newRecords);
        },
      ),
    );
  }
}