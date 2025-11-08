import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/deck.dart';
import '../models/card_model.dart';
import '../providers.dart';

class StudyScreen extends ConsumerStatefulWidget {
  final Deck deck;
  const StudyScreen({super.key, required this.deck});

  @override
  ConsumerState<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends ConsumerState<StudyScreen> {
  int index = 0;
  bool showBack = false;

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(cardsNotifierProvider(widget.deck.id));
    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Study: ${widget.deck.title}')),
        body: const Center(child: Text('No cards in this deck.')),
      );
    }
    final CardModel current = cards[index % cards.length];

    return Scaffold(
      appBar: AppBar(title: Text('Study: ${widget.deck.title}')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                child: InkWell(
                  onTap: () => setState(() => showBack = !showBack),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        showBack ? current.back : current.front,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _mark(false, cards.length),
                  icon: const Icon(Icons.close),
                  label: const Text('Again'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _mark(true, cards.length),
                  icon: const Icon(Icons.check),
                  label: const Text('Known'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('${index + 1} / ${cards.length}'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _mark(bool known, int total) {
    setState(() {
      showBack = false;
      index = (index + 1) % total;
    });
  }
}
