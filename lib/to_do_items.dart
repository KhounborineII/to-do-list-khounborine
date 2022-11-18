// Citations
// Getting sum and min from list: https://stackoverflow.com/a/68603277

import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class Character {
  Character({required this.name});

  String name;
  List<int> stats = [0, 0, 0, 0, 0, 0];

  String abbrev() {
    return name.substring(0, 1);
  }

  void populateStats() {
    Random r = Random();
    for (int i = 0; i < stats.length; i++) {
      List<int> rolls = [
        r.nextInt(6) + 1,
        r.nextInt(6) + 1,
        r.nextInt(6) + 1,
        r.nextInt(6) + 1
      ];
      int sum = rolls.sum;
      int min = rolls.min;
      stats[i] = sum - min;
    }
    stats.sort();
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
typedef CharacterListEditCallback = Function(Character c);

class CharacterListItem extends StatelessWidget {
  CharacterListItem(
      {required this.c,
      required this.onListChanged,
      required this.onDeleteItem,
      required this.onEditItem})
      : super(key: ObjectKey(c));

  final Character c;
  final CharacterListChangedCallback onListChanged;
  final CharacterListRemovedCallback onDeleteItem;
  final CharacterListEditCallback onEditItem;

  Color _getColor(BuildContext context) {
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
              onPressed: () => {onDeleteItem(c), Navigator.pop(context)},
              child: const Text("Delete"),
            ),
            TextButton(
              onPressed: () => {c.populateStats(), Navigator.pop(context)},
              child: const Text('Reroll'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      onLongPress: () {
        onEditItem(c);
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
