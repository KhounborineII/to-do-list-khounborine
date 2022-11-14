// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/to_do_items.dart';

void main() {
  test('Item abbreviation should be first letter', () {
    const item = Squirrel(name: "Squirrel", price: 6);
    expect(item.abbrev(), "S");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('SquirrelItem has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: SquirrelItem(
      item: const Squirrel(name: "test", price: 4),
      sold: true,
      onListChanged: (Squirrel item, bool completed) {},
      onPriceIncrease: (Squirrel item) {},
    ))));
    final textFinder = find.text('test');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);
  });

  testWidgets('SquirrelItem has a Circle Avatar with abbreviation',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: SquirrelItem(
      item: const Squirrel(name: "test", price: 0),
      sold: false,
      onListChanged: (Squirrel item, bool sold) {},
      onPriceIncrease: (Squirrel item) {},
    ))));
    final abbvFinder = find.text('t');
    final avatarFinder = find.byType(CircleAvatar);

    CircleAvatar circ = tester.firstWidget(avatarFinder);
    Text ctext = circ.child as Text;

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(abbvFinder, findsOneWidget);
    expect(circ.backgroundColor, Colors.blue);
    expect(ctext.data, "t");
  });

  testWidgets('Default SquirrelCatalogue has three items', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SquirrelShopping()));

    final listItemFinder = find.byType(SquirrelItem);

    expect(listItemFinder, findsNWidgets(3));
  });

  // One to test the tap and press actions on the items?
  testWidgets("Squirrel Item has Name and Price", (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: SquirrelItem(
      item: const Squirrel(name: "test", price: 10),
      sold: false,
      onListChanged: (Squirrel item, bool sold) {},
      onPriceIncrease: (Squirrel item) {},
    ))));
    final nameFinder = find.text("test");
    final priceFinder = find.text("10.0");

    expect(nameFinder, findsOneWidget);
    expect(priceFinder, findsOneWidget);
  });

  testWidgets("Add Squirrel Item", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SquirrelShopping()));
    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    expect(find.text("hi"), findsNothing);

    await tester.enterText(
        find.widgetWithText(TextField, "type Name here"), "Test Squirrel");
    await tester.pump();
    await tester.enterText(
        find.widgetWithText(TextField, "type Price here"), "9");
    await tester.pump();

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.byType(SquirrelItem), findsNWidgets(4));
  });
}
