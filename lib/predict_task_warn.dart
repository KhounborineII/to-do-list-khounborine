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

  String ptw(int s, int i) {
    if (s == 0) {
      return predict[i];
    } else if (s == 1) {
      return warn[i];
    } else {
      return task[i];
    }
  }
}
