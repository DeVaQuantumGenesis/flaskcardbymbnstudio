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
  bool animating = false;

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
              child: GestureDetector(
                onTap: () async {
                  setState(() => animating = true);
                  await Future.delayed(const Duration(milliseconds: 150));
                  setState(() {
                    showBack = !showBack;
                    animating = false;
                  });
                },
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) {
                      final rotate = Tween(begin: 0.0, end: 1.0).animate(animation);
                      return AnimatedBuilder(
                        animation: rotate,
                        child: child,
                        builder: (context, child) {
                          final value = rotate.value;
                          final angle = value * 3.14159;
                          return Transform(
                            transform: Matrix4.rotationY(angle),
                            alignment: Alignment.center,
                            child: child,
                          );
                        },
                      );
                    },
                    child: Card(
                      key: ValueKey(showBack),
                      elevation: 6,
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Center(
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
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _mark(false, cards.length),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Again'),
                ),
                FilledButton.icon(
                  onPressed: () => _mark(true, cards.length),
                  icon: const Icon(Icons.check),
                  label: const Text('Known'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${index + 1} / ${cards.length}'),
                  SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(value: (index + 1) / cards.length),
                  ),
                ],
              ),
            ),
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
