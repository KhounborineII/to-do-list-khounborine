// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:to_dont_list/to_do_items.dart';

class CharacterList extends StatefulWidget {
  const CharacterList({super.key});

  @override
  State createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New Character'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration:
                  const InputDecoration(hintText: "Enter character name"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("CancelButton"),
                style: noStyle,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    _inputController.clear();
                  });
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("OKButton"),
                    style: yesStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              _handleNewItem(valueText);
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('OK'),
                  );
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayTextEditDialog(BuildContext context, Character c) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Character Name'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration: const InputDecoration(hintText: "Edit the name"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("CancelButton"),
                style: noStyle,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    _inputController.clear();
                  });
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("OKButton"),
                    style: yesStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              _handleEditItemHelper(c, valueText);
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('OK'),
                  );
                },
              ),
            ],
          );
        });
  }

  String valueText = "";

  final List<Character> chars = [];
  final List<Character> replacement = [];

  final _charSet = <Character>{};

  void _handleListChanged(Character c) {
    setState(() {
      chars.remove(c);
      _charSet.remove(c);
      chars.insert(0, c);
    });
  }

  void _handleDeleteItem(Character c) {
    setState(() {
      print("Deleting item");
      chars.remove(c);
    });
  }

  void _handleNewItem(String charText) {
    setState(() {
      print("Adding new item");
      Character c = Character(name: charText);
      c.populateStats();
      print(c.stats.toString());
      chars.insert(0, c);
      _inputController.clear();
    });
  }

  void _handleEditItem(Character c) {
    setState(() {
      print("Editing an available character");
    });
    _inputController.text = c.name;
    _displayTextEditDialog(context, c);
    _inputController.clear();
  }

  void _handleEditItemHelper(Character c, String valueText) {
    setState(() {
      int replacer = chars.indexOf(c);
      List<int> replicaStats = c.stats;
      replacement.add(Character(name: valueText));
      replacement[0].stats = replicaStats;
      chars.replaceRange(replacer, replacer + 1, replacement);
      replacement.clear();
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('DnD Character List'),
          backgroundColor: Colors.red,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: chars.map((c) {
            return CharacterListItem(
              c: c,
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
              onEditItem: _handleEditItem,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const FaIcon(FontAwesomeIcons.diceD20),
            onPressed: () {
              _displayTextInputDialog(context);
            }));
  }
}

void main() {
  runApp(MaterialApp(
    title: 'DnD Character List',
    home: const CharacterList(),
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.red,
      fontFamily: 'Georgia',

      //text styling
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrangeAccent),
    ),
  ));
}
