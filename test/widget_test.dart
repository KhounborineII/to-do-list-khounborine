// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/to_do_items.dart';

void main() {
  test('Character abbreviation should be first letter', () {
    Character c = Character(name: "Lennox");
    expect(c.abbrev(), "L");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('ToDoListItem has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: CharacterListItem(
      c: Character(name: "test"),
      onListChanged: (Character c) {},
      onDeleteItem: (Character c) {},
      onEditItem: (Character c) {},
    ))));
    final textFinder = find.text('test');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);
  });

  testWidgets('CharacterListItem has a Circle Avatar with abbreviation',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: CharacterListItem(
      c: Character(name: "test"),
      onListChanged: (Character c) {},
      onDeleteItem: (Character c) {},
      onEditItem: (Character c) {},
    ))));
    final abbvFinder = find.text('t');
    final avatarFinder = find.byType(CircleAvatar);

    CircleAvatar circ = tester.firstWidget(avatarFinder);
    Text ctext = circ.child as Text;

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(abbvFinder, findsOneWidget);
    expect(ctext.data, "t");
  });

  testWidgets('Clicking and Typing adds character to CharacterList',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CharacterList()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("hi"), findsNothing);

    await tester.enterText(find.byType(TextField), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    final listCharFinder = find.byType(CharacterListItem);

    expect(listCharFinder, findsNWidgets(1));
  });

  testWidgets('Editing a character already in the list', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CharacterList()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("hi"), findsNothing);

    await tester.enterText(find.byType(TextField), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    final listCharFinder = find.byType(CharacterListItem);

    expect(listCharFinder, findsNWidgets(1));

    await tester.longPress(find.byType(ListTile));
    await tester.pump();
    expect(find.text("hi"), findsNWidgets(1));

    await tester.enterText(find.byType(TextField), 'i work');
    await tester.pump();
    expect(find.text("i work"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("i work"), findsOneWidget);

    final listItemFinder = find.byType(CharacterListItem);

    expect(listItemFinder, findsOneWidget);
  });

  // One to test the tap and press actions on the items?
}
