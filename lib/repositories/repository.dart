import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/deck.dart';
import '../models/card_model.dart';

class Repository {
  final Box decksBox = Hive.box('decks');
  final Box cardsBox = Hive.box('cards');
  final _uuid = const Uuid();

  // Decks
  List<Deck> getDecks() {
    return decksBox.values.map((e) => Deck.fromMap(Map.castFrom(e))).toList();
  }

  Future<Deck> createDeck(String title, {String? description}) async {
    final id = _uuid.v4();
    final deck = Deck(id: id, title: title, description: description);
    await decksBox.put(id, deck.toMap());
    return deck;
  }

  Future<void> updateDeck(Deck deck) async {
    await decksBox.put(deck.id, deck.copyWith(updatedAt: DateTime.now()).toMap());
  }

  Future<void> deleteDeck(String id) async {
    // delete related cards
    final cardsToDelete = cardsBox.values.where((e) => Map.castFrom(e)['deckId'] == id).toList();
    for (var c in cardsToDelete) {
      final map = Map.castFrom(c);
      await cardsBox.delete(map['id']);
    }
    await decksBox.delete(id);
  }

  // Cards
  List<CardModel> getCards(String deckId) {
    return cardsBox.values
        .map((e) => CardModel.fromMap(Map.castFrom(e)))
        .where((c) => c.deckId == deckId)
        .toList();
  }

  Future<CardModel> createCard(String deckId, String front, String back,
      {List<String>? tags}) async {
    final id = _uuid.v4();
    final card = CardModel(id: id, deckId: deckId, front: front, back: back, tags: tags);
    await cardsBox.put(id, card.toMap());
    return card;
  }

  Future<void> updateCard(CardModel card) async {
    await cardsBox.put(card.id, card.copyWith(updatedAt: DateTime.now()).toMap());
  }

  Future<void> deleteCard(String id) async {
    await cardsBox.delete(id);
  }
}
