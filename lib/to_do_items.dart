// Citations
// Getting sum and min from list: https://stackoverflow.com/a/68603277

import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class Item {
  const Item({required this.name});

  final String name;

  String abbrev() {
    return name.substring(0, 1);
  }
}

class Character {
  Character({required this.name});

  final String name;
  List<int> stats = [0, 0, 0, 0, 0, 0];

  String abbrev() {
    return name.substring(0, 2);
  }

  int diceRoll() {
    Random r = Random();
    return r.nextInt(6) + 1;
  }

  int getStat() {
    List<int> rolls = [diceRoll(), diceRoll(), diceRoll(), diceRoll()];
    int sum = rolls.sum;
    int min = rolls.min;
    return sum - min;
  }

  void populateStats() {
    for (int i = 0; i < stats.length; i++) {
      stats[i] = getStat();
    }
  }
}

typedef ToDoListChangedCallback = Function(Item item, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);

class ToDoListItem extends StatelessWidget {
  ToDoListItem(
      {required this.item,
      required this.completed,
      required this.onListChanged,
      required this.onDeleteItem})
      : super(key: ObjectKey(item));

  final Item item;
  final bool completed;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return completed //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!completed) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(item, completed);
      },
      onLongPress: completed
          ? () {
              onDeleteItem(item);
            }
          : null,
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(item.abbrev()),
      ),
      title: Text(
        item.name,
        style: _getTextStyle(context),
      ),
    );
  }
}
