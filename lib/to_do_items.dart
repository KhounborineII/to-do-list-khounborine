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
    return name.substring(0, 1);
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

  void swap(int a, int b) {
    int c = a;
    a = b;
    b = c;
  }

  List<int> bubbleSort(List<int> ints) {
    bool sorted = false;
    while (!sorted) {
      sorted = true;
      for (int i = 0; i < stats.length - 1; i++) {
        if (stats[i] > stats[i] + 1) {
          swap(stats[i], stats[i] + 1);
          sorted = false;
        }
      }
    }
    return ints;
  }

  void populateStats() {
    for (int i = 0; i < stats.length; i++) {
      stats[i] = getStat();
    }
    stats = bubbleSort(stats);
  }

  String printStats() {
    String s = "";
    for (int i = 0; i < stats.length; i++) {
      String num = stats[i].toString();
      s += "$num\n";
    }
    return s;
  }
}

typedef CharacterListChangedCallback = Function(Character c);
typedef CharacterListRemovedCallback = Function(Character c);

class CharacterListItem extends StatelessWidget {
  CharacterListItem(
      {required this.c,
      required this.onListChanged,
      required this.onDeleteItem})
      : super(key: ObjectKey(c));

  final Character c;
  final CharacterListChangedCallback onListChanged;
  final CharacterListRemovedCallback onDeleteItem;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    return const TextStyle(color: Colors.black54);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(c.name),
          content: Text(c.printStats()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      onLongPress: () {
        onDeleteItem(c);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(c.abbrev()),
      ),
      title: Text(
        c.name,
        style: _getTextStyle(context),
      ),
    );
  }
}
