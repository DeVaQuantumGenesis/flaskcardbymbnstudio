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
      body: cards.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.style, size: 64, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 12),
                    const Text('No cards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    const Text('Add cards to this deck to start studying.', textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: cards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final c = cards[index];
                return Dismissible(
                  key: ValueKey(c.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) {
                    // Return the future directly to avoid using the parent BuildContext across an async gap
                    return showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete card?'),
                        content: const Text('This will remove the card permanently.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
                        ],
                      ),
                    ).then((value) => value == true);
                  },
                  onDismissed: (_) async {
                    final messenger = ScaffoldMessenger.of(context);
                    await ref.read(cardsNotifierProvider(deck.id).notifier).delete(c.id);
                    messenger.showSnackBar(const SnackBar(content: Text('Card deleted')));
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(c.front, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(c.back, maxLines: 2, overflow: TextOverflow.ellipsis),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => CardEditorScreen(deckId: deck.id, card: c),
                      )),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            icon: const Icon(Icons.school),
            label: const Text('Study'),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => StudyScreen(deck: deck))),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CardEditorScreen(deckId: deck.id))),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
