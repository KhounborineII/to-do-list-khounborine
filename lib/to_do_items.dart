import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class Item {
  const Item({required this.name, required this.index});

  final String name;
  final String index;

  String abbrev() {
    return "8";
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

  Color _getColor() {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.
    if (completed) {
      return Colors.black54;
    } else if (item.index == "0") {
      return Colors.pinkAccent;
    } else if (item.index == "1") {
      return Colors.blue;
    } else if (item.index == "2") {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  Widget? _getIcon() {
    if (item.index == "0") {
      return const Icon(Boxicons.bxs_brain);
    } else if (item.index == "1") {
      return const Icon(BootstrapIcons.list_task);
    } else if (item.index == "2") {
      return const Icon(Icons.warning_amber);
    } else {
      return Text(item.abbrev());
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
          : null,
      leading: CircleAvatar(
        backgroundColor: _getColor(),
        child: _getIcon(),
      ),
      title: Text(
        item.name,
        style: _getTextStyle(context),
      ),
    );
  }
}
