import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import 'deck_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(decksNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
      ),
      body: ListView.builder(
        itemCount: decks.length,
        itemBuilder: (context, index) {
          final deck = decks[index];
          return ListTile(
            title: Text(deck.title),
            subtitle: deck.description != null ? Text(deck.description!) : null,
            trailing: IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => DeckDetailScreen(deck: deck),
                ));
              },
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => DeckDetailScreen(deck: deck),
              ));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDeckDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDeckDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Deck'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Deck title'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                await ref.read(decksNotifierProvider.notifier).add(title);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
