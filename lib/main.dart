import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';
import 'package:to_dont_list/astra.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
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
                    if (valueText != "") {
                      _handleNewItem(valueText);
                      Navigator.pop(context);
                    }
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

  final _itemSet = <Item>{};

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      items.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet.add(item);
        items.add(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
        items.insert(0, item);
      }
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
    });
  }

  void _handleNewItem(String itemText) {
    setState(() {
      print("Adding new item");
      Item item = Item(name: itemText);
      items.insert(0, item);
      _inputController.clear();
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
          title: const Text('To Do List'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items.map((item) {
            return ToDoListItem(
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
    title: 'To Do List',
    home: ToDoList(),
  ));
}
