import 'package:flutter/material.dart';

class Item {
  const Item({required this.name, required this.price});

  final String name;
  final int price;

  String abbrev() {
    return name.substring(
        0, 1); //changed from (0,2) to (0,1) to get first letter only
  }
}

typedef ToDoListChangedCallback = Function(Item item, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);

class ToDoListItem extends StatelessWidget {
  ToDoListItem(
      {required this.item,
      required this.completed,
      required this.onListChanged,
      required this.onDeleteItem})
      : super(key: ObjectKey(item));

  final Item item;
  final bool completed;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return completed //
        ? Colors.black54 //color changed to black54 for test
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!completed) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(item, completed);
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
    );
  }
}
