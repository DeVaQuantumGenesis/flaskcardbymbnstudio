// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flaskcardbymbnstudio/main.dart';
import 'package:flaskcardbymbnstudio/models/deck_adapter.dart';
import 'package:flaskcardbymbnstudio/models/card_adapter.dart';
import 'package:flaskcardbymbnstudio/models/deck.dart';
import 'package:flaskcardbymbnstudio/models/card_model.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
  // Initialize Hive and open boxes used by the app (test environment)
  await Hive.initFlutter();
  Hive.registerAdapter(DeckAdapter());
  Hive.registerAdapter(CardModelAdapter());
  await Hive.openBox<Deck>('decks');
  await Hive.openBox<CardModel>('cards');

  await tester.pumpWidget(const ProviderScope(child: FlashcardApp()));
  // AppBar title should be present
  expect(find.text('Flashcards'), findsOneWidget);
  });
}
