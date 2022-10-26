import 'dart:math';

import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

class predict_task_warn {
  // Predict Array
  final predict = [
    "You have a secret admirer, find them.",
    "Flattery wil go far tonight, try it",
    "You will have a good day"
  ];
  // Task Array
  final task = ["Clean something", "Practice self-care", "Run 1 mile"];
  // Warning Array
  final warn = [
    "Beware of incoming weather",
    "Don't behave with manners poor",
    "Change is inevitable, except from vending machines"
  ];

  String ptw(int s) {
    Random rand = Random();
    if (s == 0) {
      return predict[rand.nextInt(predict.length)];
    } else if (s == 1) {
      return warn[rand.nextInt(warn.length)];
    } else {
      return task[rand.nextInt(task.length)];
    }
  }
}
