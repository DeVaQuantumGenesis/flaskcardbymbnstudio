import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/deck.dart';
import 'models/card_model.dart';
import 'repositories/repository.dart';

final repositoryProvider = Provider<Repository>((ref) => Repository());

final decksNotifierProvider = StateNotifierProvider<DecksNotifier, List<Deck>>(
  (ref) => DecksNotifier(ref),
);

class DecksNotifier extends StateNotifier<List<Deck>> {
  final Ref ref;
  DecksNotifier(this.ref) : super([]) {
    load();
  }

  void load() {
    final repo = ref.read(repositoryProvider);
    state = repo.getDecks();
  }

  Future<void> add(String title, {String? description}) async {
    final repo = ref.read(repositoryProvider);
    final deck = await repo.createDeck(title, description: description);
    state = [...state, deck];
  }

  Future<void> update(Deck deck) async {
    final repo = ref.read(repositoryProvider);
    await repo.updateDeck(deck);
    state = state.map((d) => d.id == deck.id ? deck : d).toList();
  }

  Future<void> delete(String id) async {
    final repo = ref.read(repositoryProvider);
    await repo.deleteDeck(id);
    state = state.where((d) => d.id != id).toList();
  }
}

final cardsNotifierProvider = StateNotifierProvider.family<CardsNotifier, List<CardModel>, String>(
  (ref, deckId) => CardsNotifier(ref, deckId),
);

class CardsNotifier extends StateNotifier<List<CardModel>> {
  final Ref ref;
  final String deckId;
  CardsNotifier(this.ref, this.deckId) : super([]) {
    load();
  }

  void load() {
    final repo = ref.read(repositoryProvider);
    state = repo.getCards(deckId);
  }

  Future<void> add(String front, String back, {List<String>? tags}) async {
    final repo = ref.read(repositoryProvider);
    final card = await repo.createCard(deckId, front, back, tags: tags);
    state = [...state, card];
  }

  Future<void> update(CardModel card) async {
    final repo = ref.read(repositoryProvider);
    await repo.updateCard(card);
    state = state.map((c) => c.id == card.id ? card : c).toList();
  }

  Future<void> delete(String id) async {
    final repo = ref.read(repositoryProvider);
    await repo.deleteCard(id);
    state = state.where((c) => c.id != id).toList();
  }
}
