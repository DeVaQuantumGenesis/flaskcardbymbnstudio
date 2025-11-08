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
      body: decks.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_stories, size: 72, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 12),
                    const Text('No decks yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    const Text('Tap + to create your first deck and start studying.', textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: decks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final deck = decks[index];
                final cardCount = ref.read(repositoryProvider).getCards(deck.id).length;
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    title: Text(deck.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (deck.description != null) Text(deck.description!),
                        const SizedBox(height: 6),
                        Text('$cardCount cards', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => DeckDetailScreen(deck: deck),
                        ));
                      },
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DeckDetailScreen(deck: deck),
                    )),
                  ),
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
                // Close dialog first to avoid using BuildContext across async gap
                Navigator.of(ctx).pop();
                await ref.read(decksNotifierProvider.notifier).add(title);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
