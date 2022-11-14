// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';
import 'package:to_dont_list/astra.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SquirrelShopping extends StatefulWidget {
  const SquirrelShopping({super.key});

  @override
  State createState() => _SquirrelShoppingState();
}

class _SquirrelShoppingState extends State<SquirrelShopping> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _priceInputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Item To Add'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration:
                  const InputDecoration(hintText: "type something here"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    _handleNewItem(valueText);
                    Navigator.pop(context);
                  });
                },
                controller: _nameInputController,
                decoration:
                    const InputDecoration(label: Text("type Name here")),
              ),
              TextField(
                keyboardType: TextInputType
                    .number, //https://stackoverflow.com/questions/49577781/how-to-create-number-input-field-in-flutter
                onChanged: (value) {
                  setState(() {
                    price = value;
                  });
                },
                controller: _priceInputController,
                decoration:
                    const InputDecoration(label: Text("type Price here")),
              )
            ]),
            actions: <Widget>[
              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _nameInputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("CancelButton"),
                    style: noStyle,
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Cancel'),
                  );
                },
              ),
              ElevatedButton(
                key: const Key("CancelButton"),
                style: noStyle,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    _priceInputController
                        .clear(); //clear text fields after cancel
                    _nameInputController.clear();
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayTextEditDialog(BuildContext context, Item item) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Item To Edit'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration:
                  const InputDecoration(hintText: "type something here"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    _handleEditItemHelper(item, valueText);
                    Navigator.pop(context);
                  });
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("CancelButton"),
                    style: noStyle,
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Cancel'),
                  );
                },
              ),
            ],
          );
        });
  }

  String valueText = "";

  final List<Item> items = [const Item(name: "add more todos")];
  final List<Item> replacement = [];

  final _itemSet = <Squirrel>{};

  void _handleSquirrelSelling(Squirrel item, bool sold) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      if (!sold) {
        print("Selling");
        _itemSet.add(item);
        //items.add(item);
        print(items);
      }
    });
  }

  void _handleNewItem(String itemText, double itemPrice) {
    //, int itemPrice
    setState(() {
      print("Adding new item");
      Item item = Item(name: itemText);
      items.insert(0, item);
      _priceInputController.clear();
      _nameInputController.clear();
    });
  }

  void _handleEditItem(Item item) {
    setState(() {
      print("Editing an available item");
    });
    _inputController.text = item.name;
    _displayTextEditDialog(context, item);
  }

  void _handleEditItemHelper(Item item, String valueText) {
    setState(() {
      int replacer = items.indexOf(item);
      replacement.add(Item(name: valueText));
      items.replaceRange(replacer, replacer + 1, replacement);
      replacement.clear();
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Squirrel Store Catalogue'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: items.map((item) {
          return SquirrelItem(
              item: item,
              completed: _itemSet.contains(item),
              onListChanged: _handleListChanged,
              onEditItem: _handleEditItem,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          backgroundColor: Colors.blue,
          children: [
            SpeedDialChild(
                child: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
                label: "Add Personal Todo",
                backgroundColor: Colors.blueAccent,
                onTap: () {
                  _displayTextInputDialog(context);
                }),
            SpeedDialChild(
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.yellow,
                ),
                label: "Add Arcana Todo",
                backgroundColor: Colors.blueAccent,
                onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => AstraPage(items: items))))
                    }),
          ],
        ));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Squirrel Store Catalogue',
    home: SquirrelShopping(),
  ));
}

// "You could have the app be a fortune recorder, 
//  so the magic 8 ball is the way you get to add things to the list?"

// Have a class that holds a huge list of "predictions", "tasks", and "warnings" 
// - When you press the button on the bottom, 
//    it will add a new item to the list from that list. 
// If you manually type something into the task list, 
//  append a magic eight ball saying to the end of the to do item.