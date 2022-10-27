import 'dart:math';

import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

class predict_task_warn {
  // Predict Array
  final predict = [
    "You have a secret admirer, find them.",
    "Flattery wil go far tonight, try it.",
    "You will have a good day.",
    "The world will end.",
    "You will get a pet soon.",
    "You will make a new friend.",
    "It is going to rain tonight.",
    "You will enjoy a cookie later.",
    "The night will be long for you.",
    "You are going to ace your next text."
  ];
  // Task Array
  final task = [
    "Clean something.",
    "Practice self-care.",
    "Run 1 mile.",
    "Do 2 hours of homework.",
    "Throw a football.",
    "Ride your bike.",
    "Drink some coffee.",
    "Go buy groceries.",
    "Go to Target.",
    "Buy a bidet."
  ];
  // Warning Array
  final warn = [
    "Beware of incoming weather",
    "Don't behave with manners poor",
    "Change is inevitable, except from vending machines",
    "Everyone seems normal until you get to know them.",
    "Your road to glory will be rocky but fulfilling.",
    "Stop eating now. Food poisoning no fun.",
    "You think it’s a secret, but they know.",
    "An alien of some sort will be appearing to you shortly."
  ];

  //ptw now works by giving it the index, and then picking a random index from the list of the first index
  String ptw(int s, Random rand) {
    if (s == 0) {
      return predict[rand.nextInt(predict.length)];
    } else if (s == 1) {
      return warn[rand.nextInt(warn.length)];
    } else {
      return task[rand.nextInt(task.length)];
    }
  }
}
