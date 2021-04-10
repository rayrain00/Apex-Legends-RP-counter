import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../models/Record.dart';

class ChartPage extends StatefulWidget {
  final List<Record> records;

  ChartPage({
    this.records,
  });

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<charts.Series> seriesList = [];
  bool animate = true;

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() async {
    List<LinearRecord> data = [];
    widget.records.forEach((record) {
      data.add(LinearRecord(record.playedAt, record.rp));
    });

    List<charts.Series<LinearRecord, DateTime>> chartData = [
      charts.Series<LinearRecord, DateTime>(
        id: 'record',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearRecord record, _) => record.time,
        measureFn: (LinearRecord record, _) => record.rp,
        data: data,
      )
    ];

    setState(() => seriesList = chartData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 48,
          horizontal: 16,
        ),
        // child: charts.TimeSeriesChart(
        //   seriesList,
        //   animate: animate,
        //   dateTimeFactory: const charts.LocalDateTimeFactory(),
        // ),
      ),
    );
  }
}

class LinearRecord {
  final DateTime time;
  final int rp;

  LinearRecord(this.time, this.rp);
}