import 'package:flutter/material.dart';

class Squirrel {
  const Squirrel({required this.name, required this.price});

  final String name;
  final int price; //asking price
  //final Image image; //squirrel image

  String abbrev() {
    return name.substring(
        0, 1); //changed from (0,2) to (0,1) to get first letter only
  }
}

typedef ToDoListChangedCallback = Function(Squirrel item, bool completed);
typedef ToDoListRemovedCallback = Function(Squirrel item);

class SquirrelItem extends StatelessWidget {
  SquirrelItem(
      {required this.item,
      required this.sold,
      //required this.sold, //sold squirrel
      required this.onListChanged,
      required this.onDeleteItem})
      : super(key: ObjectKey(item));

  final Squirrel item;
  final bool sold;
  //final bool sold; //sold squirrel
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return sold //
        ? Colors.black54 //color changed to black54 for test
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!sold) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  Text _getSubtitle(BuildContext context) {
    if (!sold) {
      return Text(item.price.toString());
    } else {
      return Text("SOLD");
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onListChanged(item, sold);
        },
        onLongPress: () {
          //delete item after long press
          onDeleteItem(item);
        },
        leading: CircleAvatar(
          backgroundColor: _getColor(context),
          child: Text(item.abbrev()), //text of circle is abbreviation
        ),
        title: Text(
          item.name, //item text is the Item's name
          style: _getTextStyle(context),
        ),
        subtitle: _getSubtitle(context));
    //Text(item.price.toString()));
  }
}
