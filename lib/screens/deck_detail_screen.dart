import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/deck.dart';
import '../providers.dart';
import 'card_editor_screen.dart';
import 'study_screen.dart';

class DeckDetailScreen extends ConsumerWidget {
  final Deck deck;
  const DeckDetailScreen({super.key, required this.deck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(cardsNotifierProvider(deck.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(deck.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.school),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => StudyScreen(deck: deck),
              ));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final c = cards[index];
          return ListTile(
            title: Text(c.front),
            subtitle: Text(c.back),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await ref.read(cardsNotifierProvider(deck.id).notifier).delete(c.id);
              },
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => CardEditorScreen(deckId: deck.id, card: c),
              ));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CardEditorScreen(deckId: deck.id),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
