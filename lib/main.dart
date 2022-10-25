// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';
import 'package:to_dont_list/predict_task_warn.dart';
import 'dart:math';

List<Item> items = [const Item(name: "add more todos")];

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

typedef ListAddCallback = Function();

class DecisionMaker extends StatefulWidget {
  const DecisionMaker({super.key, required this.onListAdd});

  final ListAddCallback onListAdd;
  @override
  State createState() => _DecisionMakerState();
}

// removed code from here because the reason the screen wasnt changing is because the set state was here
class _DecisionMakerState extends State<DecisionMaker> {
  String answer = "Click Me";
  predict_task_warn predictTaskWarn = predict_task_warn();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: TextButton(
            onPressed: widget.onListAdd, child: Text("No Ideas?: $answer")));
  }
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    final _random = new Random();
    var _magic8 = [
      "- Yes, Definitely",
      "- Without a Doubt",
      "- Signs Point to Yes",
      "- Maybe",
      "- Outlook not so good",
      "- Very Doubtful"
    ];

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
                    _handleNewItem(valueText + _magic8[_random.nextInt(6)]);
                    Navigator.pop(context);
                    valueText = "";
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

  final _itemSet = <Item>{};

  int numCompleted = 0;

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
        numCompleted++;
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

  // moved this from within it's class to here so the set state would call the correct build
  void _randomInRange() {
    final randon = Random();
    int max = 3;
    predict_task_warn ptw = predict_task_warn();

    setState(() {
      Item item =
          Item(name: (ptw.ptw(randon.nextInt(max), randon.nextInt(max))));
      items.insert(0, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Items completed: $numCompleted'),
        ),
        body: ListView(
          key: ObjectKey(items.first),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items.map((item) {
            return ToDoListItem(
              item: item,
              completed: _itemSet.contains(item),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _displayTextInputDialog(context);
            }),
        bottomNavigationBar: DecisionMaker(onListAdd: _randomInRange));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'To Do List',
    home: ToDoList(),
  ));
}

// "You could have the app be a fortune recorder, 
//  so the magic 8 ball is the way you get to add things to the list?"

// Have a class that holds a huge list of "predictions", "tasks", and "warnings" 
// - When you press the button on the bottom, 
//    it will add a new item to the list from that list. 
// If you manually type something into the task list, 
//  append a magic eight ball saying to the end of the to do item.