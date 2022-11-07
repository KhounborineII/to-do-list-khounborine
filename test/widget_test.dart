// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/to_do_items.dart';
import 'package:to_dont_list/astra.dart';

void main() {
  test('Item abbreviation should be first letter', () {
    const item = Item(name: "add more todos");
    expect(item.abbrev(), "a");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('ToDoListItem has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: const Item(name: "test"),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onEditItem: (Item item) {},
                onDeleteItem: (Item item) {}))));
    final textFinder = find.text('test');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);
  });

  testWidgets('ToDoListItem has a Circle Avatar with abbreviation',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: const Item(name: "test"),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onEditItem: (Item item) {},
                onDeleteItem: (Item item) {}))));
    final abbvFinder = find.text('t');
    final avatarFinder = find.byType(CircleAvatar);

    CircleAvatar circ = tester.firstWidget(avatarFinder);
    Text ctext = circ.child as Text;

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(abbvFinder, findsOneWidget);
    expect(circ.backgroundColor, Colors.black54);
    expect(ctext.data, "t");
  });

  testWidgets('Default ToDoList has one item', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsOneWidget);
  });

  testWidgets('Clicking and Typing adds item to ToDoList', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    // Pump after every action to rebuild the widgets
    await tester.tap(find.byIcon(Icons.person_add));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text("hi"), findsNothing);

    await tester.enterText(find.byType(TextField), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(2));
  });

  // One to test the tap and press actions on the items?

  testWidgets('Editing an item already in the list', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byType(TextField), findsNothing);
    expect(find.text("add more todos"), findsOneWidget);

    await tester.longPress(find.byType(ListTile));
    await tester.pump();
    expect(find.text("add more todos"), findsNWidgets(2));
    //Finds two since the ListTile contains the text as well as the TextField

    await tester.enterText(find.byType(TextField), 'i work');
    await tester.pump();
    expect(find.text("i work"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("i work"), findsOneWidget);

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsOneWidget);
  });

  testWidgets('Testing the Cancel button before adding an Item',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    // Pump after every action to rebuild the widgets
    await tester.tap(find.byIcon(Icons.person_add));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text("hi"), findsNothing);

    await tester.enterText(find.byType(TextField), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.tap(find.byKey(const Key("CancelButton")));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text("hi"), findsNothing);

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(1));
  });

  testWidgets('Arcana Page properly appears', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    // Pump after every action to rebuild the widgets
    await tester.tap(find.byIcon(Icons.auto_awesome));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(Icon), findsOneWidget);

    await tester.tap(find.byKey(const Key("AnotherCardButton")));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(Icon), findsOneWidget);
  });

  testWidgets('Arcana Todos are properly added', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    // Pump after every action to rebuild the widgets
    await tester.tap(find.byIcon(Icons.auto_awesome));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(ElevatedButton), findsNWidgets(2));

    await tester.tap(find.byKey(const Key("ArcanaAddButton")));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(1));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await tester.tap(find.byIcon(Icons.person_add));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await tester.tap(find.byKey(const Key("CancelButton")));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(listItemFinder, findsNWidgets(2));
  });
}
