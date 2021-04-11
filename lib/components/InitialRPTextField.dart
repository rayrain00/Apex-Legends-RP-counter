import 'package:Apex_Legends_RP_Counter/models/Record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialRPTextField extends StatefulWidget {
  @override
  _InitialRPTextFieldState createState() => _InitialRPTextFieldState();
}

class _InitialRPTextFieldState extends State<InitialRPTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int rp = prefs.getInt(INITIAL_RP_KEY) ?? 0;
    _controller.text = rp.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt(INITIAL_RP_KEY, int.parse(value));
      }
    );
  }
}