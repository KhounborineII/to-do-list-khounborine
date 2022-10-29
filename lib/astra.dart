import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';
import 'package:to_dont_list/main.dart';
import 'dart:math';

class AstraPage extends StatefulWidget {
  const AstraPage({super.key});

  @override
  State<AstraPage> createState() => _AstraPage();
}

String cardTitle = "";
Color mainColor = Colors.black;
Color iconColor = Colors.black;
int generatedInt = 0;
IconData arcana = Icons.wb_sunny;

void generateRandomNumber() {
  var random = Random();
  generatedInt = random.nextInt(5) + 1;
  print(generatedInt);
}

void generateCard() {
  switch (generatedInt) {
    case 1:
      cardTitle = "The Spire";
      mainColor = Colors.yellow;
      arcana = Icons.bolt;
      break;

    case 2:
      cardTitle = "The Balance";
      mainColor = Colors.orange;
      arcana = Icons.brightness_high;
      break;

    case 3:
      cardTitle = "The Ewer";
      mainColor = Colors.blue;
      arcana = Icons.water;
      break;

    case 4:
      cardTitle = "The Arrow";
      mainColor = Colors.lightBlue;
      arcana = Icons.north_east;
      break;

    case 5:
      cardTitle = "The Spear";
      mainColor = const Color.fromARGB(255, 60, 53, 241);
      arcana = Icons.ac_unit;
      break;

    case 6:
      cardTitle = "The Bole";
      mainColor = Colors.green;
      arcana = Icons.nature;
      break;
  }
}

TextStyle titleStyle =
    TextStyle(color: mainColor, fontWeight: FontWeight.w900, fontSize: 35);

class _AstraPage extends State<AstraPage> {
  @override
  void initState() {
    super.initState();
    generateRandomNumber();
    generateCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(cardTitle, style: titleStyle),
        Icon(arcana, color: mainColor, size: 300)
      ],
    )));
  }
}
