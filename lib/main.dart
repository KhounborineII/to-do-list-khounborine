// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

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
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
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
                              _handleNewItem(name, int.parse(price));
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

  void _handleNewItem(String itemText, int itemPrice) {
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
              onListChanged: _handleSquirrelSelling);
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
