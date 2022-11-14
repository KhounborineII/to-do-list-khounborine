import 'package:flutter/material.dart';

class Squirrel {
  const Squirrel({required this.name, required this.price});

  final String name;
  final double price; //asking price
  //final Image image; //squirrel image

  String abbrev() {
    return name.substring(0, 1);
  }
}

typedef ToDoListChangedCallback = Function(Item item, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);
typedef ToDoListEditedCallback = Function(Item item);

class SquirrelItem extends StatelessWidget {
  SquirrelItem(
      {required this.item,
      required this.sold,
      required this.onListChanged,
      required this.onEditItem,
      required this.onDeleteItem})
      : super(key: ObjectKey(item));

  final Squirrel item;
  final bool sold;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;
  final ToDoListEditedCallback onEditItem;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.
    if (!sold) return Colors.blue;

    return completed //
        ? Colors.black54
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
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(item, completed);
      },
      onLongPress: completed
          ? () {
              onDeleteItem(item);
            }
          : !completed
              ? () {
                  onEditItem(item);
                }
              : null,
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(item.abbrev()),
      ),
      title: Text(
        item.name,
        style: _getTextStyle(context),
      ),
    );
  }
}
