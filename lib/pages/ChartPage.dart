import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<charts.Series<dynamic, DateTime>> seriesList = [];
  bool animate = true;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    setData();
  }

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void setData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentRP = prefs.getInt(INITIAL_RP_KEY) ?? 0;

    List<LinearRecord> data = [];
    widget.records.forEach((record) {
      currentRP += record.rp;
      data.add(LinearRecord(record.playedAt, currentRP));
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
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              final String path = await localPath;
              final String fileName = 'image.jpg';
              await screenshotController.captureAndSave(path, fileName: fileName);
              final RenderBox box = context.findRenderObject() as RenderBox;
              await Share.shareFiles(
                ['$path/$fileName'],
                subject: 'sample subject',
                sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 48,
          horizontal: 16,
        ),
        child: Screenshot(
          controller: screenshotController,
          child: charts.TimeSeriesChart(
            seriesList,
            animate: animate,
            primaryMeasureAxis: charts.NumericAxisSpec(
              tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
            ),
            defaultRenderer: charts.LineRendererConfig(includeArea: true),
            dateTimeFactory: const charts.LocalDateTimeFactory(),
          ),
        ),
      ),
    );
  }
}

class LinearRecord {
  final DateTime time;
  final int rp;

  LinearRecord(this.time, this.rp);
}