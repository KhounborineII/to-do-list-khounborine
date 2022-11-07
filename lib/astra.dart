import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';
import 'package:to_dont_list/main.dart';
import 'dart:math';

class AstraPage extends StatefulWidget {
  AstraPage({required this.items}) : super(key: ObjectKey(items));

  final List<Item> items;

  @override
  State<AstraPage> createState() => _AstraPage();
}

String cardTitle = "";
String cardText = "";
String fortuneCommand = "";
Color mainColor = Colors.black;
Color iconColor = Colors.black;
int generatedInt = 0;
IconData arcana = Icons.wb_sunny;
var random = Random();
Item fortuneItem = Item(name: "none");
TextStyle titleStyle =
    TextStyle(color: mainColor, fontWeight: FontWeight.w900, fontSize: 35);

void generateRandomNumber() {
  generatedInt = random.nextInt(6) + 1;
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

void generateFortune() {
  generatedInt = random.nextInt(3);
  switch (cardTitle) {
    case "The Balance":
      switch (generatedInt) {
        case 0:
          cardText = "The Balance shines brightly! Make a new friend today.";
          fortuneCommand = "Make a new friend";
          break;

        case 1:
          cardText =
              "The Balance brings good fortune. Perhaps it is time to invest.";
          fortuneCommand = "Invest in the Market";
          break;

        case 2:
          cardText =
              "The Balance favors the bold! Risk big and Reap your rewards!";
          fortuneCommand = "Gamble BIG";
      }
      break;

    case "The Spire":
      switch (generatedInt) {
        case 0:
          cardText =
              "The Spire stands tall! Take a moment of reprieve, for you deserve it.";
          fortuneCommand = "Meditate for 1 Hour";
          break;

        case 1:
          cardText =
              "The Spire looms closer, beware its anger! Protect yourself.";
          fortuneCommand = "Wear comfortable clothes today";
          break;

        case 2:
          cardText =
              "The Spire seeks your resolve. Are you prepared to be tested?";
          fortuneCommand = "Study while standing for 1 Hour";
      }
      break;

    case "The Spear":
      switch (generatedInt) {
        case 0:
          cardText = "The Spear calls you forth, eagerly! Prepare yourself!";
          fortuneCommand = "Cardio for 1 Hour";
          break;

        case 1:
          cardText = "The Spear swings wildly in rage! Match its anger!";
          fortuneCommand = "Abdominal Exercises for 1 Hour";
          break;

        case 2:
          cardText = "The Spear trains in solitude! Join in its struggle.";
          fortuneCommand = "Lift weights with a friend for 1 Hour";
      }
      break;

    case "The Arrow":
      switch (generatedInt) {
        case 0:
          cardText =
              "The Arrow shimmers in its quiver! One must be prepared to complete one's task.";
          fortuneCommand = "Study for 1 Hour";
          break;

        case 1:
          cardText =
              "The Arrow is not alone on its journey; and neither are you!";
          fortuneCommand = "Hang out with friends today";
          break;

        case 2:
          cardText = "The Arrow reaches for its target! Reach it first.";
          fortuneCommand = "Do 1 friendly deed today";
      }
      break;

    case "The Ewer":
      switch (generatedInt) {
        case 0:
          cardText =
              "The Ewer is brimming full! Hydrate yourself in its splendor!";
          fortuneCommand = "Drink some water";
          break;

        case 1:
          cardText =
              "The Ewer is half full or is it half empty?! Either way, cleanse thyself!";
          fortuneCommand = "Take a Shower";
          break;

        case 2:
          cardText = "The Ewer will cleanse all! Help it in its work!";
          fortuneCommand = "Wash your hands";
      }
      break;

    case "The Bole":
      switch (generatedInt) {
        case 0:
          cardText = "The Bole brings great favor! Bring favor in return!";
          fortuneCommand = "Go touch some grass";
          break;

        case 1:
          cardText = "The Bole sprouts gloriously! Rejoice in its victory.";
          fortuneCommand = "Pick some flowers";
          break;

        case 2:
          cardText = "The Bole gives graciously! Give thanks to the generous.";
          fortuneCommand = "Hug a Tree";
      }
      break;
  }
}

class _AstraPage extends State<AstraPage> {
  @override
  void initState() {
    super.initState();
    cardGeneration();
  }

  void cardGeneration() {
    setState(() {
      generateRandomNumber();
      generateCard();
      generateFortune();
      titleStyle = TextStyle(
          color: mainColor, fontWeight: FontWeight.w900, fontSize: 35);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(cardTitle, style: titleStyle),
        Icon(arcana, color: mainColor, size: 300),
        Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 20),
          child: Text(
            "$cardText\n Fortune: $fortuneCommand.",
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                    key: const Key("AnotherCardButton"),
                    onPressed: cardGeneration,
                    child: const Text("Give me Another"))),
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                    key: const Key("ArcanaAddButton"),
                    onPressed: () => {
                          fortuneItem = Item(name: fortuneCommand),
                          widget.items.add(fortuneItem),
                          Navigator.pop(context),
                        },
                    child: const Text("Add to My List")))
          ],
        )
      ],
    )));
  }
}
