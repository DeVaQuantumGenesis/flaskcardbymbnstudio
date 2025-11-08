import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/deck.dart';
import '../models/card_model.dart';

class Repository {
  final Box<Deck> decksBox = Hive.box<Deck>('decks');
  final Box<CardModel> cardsBox = Hive.box<CardModel>('cards');
  final _uuid = const Uuid();

  // Decks
  List<Deck> getDecks() {
    return decksBox.values.cast<Deck>().toList();
  }

  Future<Deck> createDeck(String title, {String? description}) async {
    final id = _uuid.v4();
    final deck = Deck(id: id, title: title, description: description);
    await decksBox.put(id, deck);
    return deck;
  }

  Future<void> updateDeck(Deck deck) async {
    await decksBox.put(deck.id, deck.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> deleteDeck(String id) async {
    // delete related cards
    final cardsToDelete = cardsBox.values.where((e) => e.deckId == id).toList();
    for (var c in cardsToDelete) {
      await cardsBox.delete(c.id);
    }
    await decksBox.delete(id);
  }

  // Cards
  List<CardModel> getCards(String deckId) {
    return cardsBox.values.where((c) => c.deckId == deckId).toList();
  }

  Future<CardModel> createCard(String deckId, String front, String back,
      {List<String>? tags}) async {
    final id = _uuid.v4();
    final card = CardModel(id: id, deckId: deckId, front: front, back: back, tags: tags);
    await cardsBox.put(id, card);
    return card;
  }

  Future<void> updateCard(CardModel card) async {
    await cardsBox.put(card.id, card.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> deleteCard(String id) async {
    await cardsBox.delete(id);
  }
}
