import 'dart:math';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 100,
            child: Center(
              child: Text(name),
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
                itemHeight: 24,
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
      ),
    );
  }
}