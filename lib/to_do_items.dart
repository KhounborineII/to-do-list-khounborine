import 'package:flutter/material.dart';

class Item {
  const Item({required this.name, this.icon, this.color});

  final String name;
  final IconData? icon;
  final Color? color;

  String abbrev() {
    return name.substring(0, 1);
  }
}

typedef ToDoListChangedCallback = Function(Item item, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);
typedef ToDoListEditedCallback = Function(Item item);

class ToDoListItem extends StatelessWidget {
  ToDoListItem(
      {required this.item,
      required this.completed,
      required this.onListChanged,
      required this.onEditItem,
      required this.onDeleteItem})
      : super(key: ObjectKey(item));

  final Item item;
  final bool completed;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;
  final ToDoListEditedCallback onEditItem;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    if (completed) {
      return Colors.black54;
    } else if (item.color == null){
      return Theme.of(context).primaryColor;
    } else {
      return item.color!;
    }
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
        child: (item.icon == null)
          ?
          Text(item.abbrev())
          :
          Icon(item.icon, color: Colors.white),
      ),
      title: Text(
        item.name,
        style: _getTextStyle(context),
      ),
    );
  }
}
