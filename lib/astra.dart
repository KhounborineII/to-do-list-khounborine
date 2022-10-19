import 'dart:html';

import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';
import 'package:to_dont_list/main.dart';

class astraPage extends StatefulWidget {
  const astraPage({super.key});

  @override
  State<astraPage> createState() => _astraPage();
}

String cardTitle = "";
Color titleColor = Colors.white;




class _astraPage extends State<astraPage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(cardTitle,
              style: titleStyle),
          ],
        )
      )
    )
  }
}


TextStyle titleStyle = TextStyle(
  color: titleColor,
  fontWeight: FontWeight.w900,
  fontSize: 75);

