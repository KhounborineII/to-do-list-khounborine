// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';
import 'dart:math';
import 'package:boxicons/boxicons.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
            title: const Text('Squirrel To Add'),
            content: Column(children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() {
                    name = value;
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
                    key: const Key("OKButton"),
                    style: yesStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              _handleNewItem(name, double.parse(price));
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('OK'),
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

  String name = "";
  String price = "";

  final List<Squirrel> items = [
    const Squirrel(name: "Bob", price: 3), //init with multiple
    const Squirrel(name: "Claude", price: 7),
    const Squirrel(name: "Nuts", price: 9)
  ];

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
      Squirrel item = Squirrel(name: itemText, price: itemPrice);
      //Item isn't const with String value, Item name is the value of itemText
      items.insert(0, item);
      _priceInputController.clear();
      _nameInputController.clear();
    });
  }

  Future<void> _handleAuction(Squirrel item) async {
    final TextEditingController _pricecontroller = TextEditingController();
    var original = item.price;
    var proposed = 0.0;
    var error = "";
    if (_itemSet.contains(item)) {
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Squirrel Auction for ${item.name}'),
              content: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        if (double.parse(value) > original) {
                          proposed = double.parse(value);
                        } else if (double.parse(value) < original) {
                          error =
                              "You must insert a price higher than the original";
                        } else {
                          error = "Please insert a correct value";
                        }
                      });
                    },
                    controller: _pricecontroller,
                    decoration: const InputDecoration(
                        label: Text("Type proposed bidding price")),
                  ),
                ],
              ),
              actions: <Widget>[
                // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _pricecontroller,
                  builder: (context, value, child) {
                    return ElevatedButton(
                      key: const Key("OKButton"),
                      style: yesStyle,
                      onPressed: value.text.isNotEmpty
                          ? () {
                              setState(() {
                                if (proposed > original) {
                                  if (items.contains(item)) {
                                    items.remove(item);
                                  }
                                  _handleNewItem(item.name, proposed);
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: error,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              });
                            }
                          : null,
                      child: const Text('OK'),
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
                      _pricecontroller.clear(); //clear text fields after cancel
                    });
                  },
                ),
              ],
            );
          });
    }
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
              sold: _itemSet.contains(item),
              onListChanged: _handleSquirrelSelling,
              onPriceIncrease: _handleAuction);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _displayTextInputDialog(context);
          }),
    );
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