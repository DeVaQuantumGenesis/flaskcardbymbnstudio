import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/card_model.dart';
import '../providers.dart';

class CardEditorScreen extends ConsumerStatefulWidget {
  final String deckId;
  final CardModel? card;
  const CardEditorScreen({super.key, required this.deckId, this.card});

  @override
  ConsumerState<CardEditorScreen> createState() => _CardEditorScreenState();
}

class _CardEditorScreenState extends ConsumerState<CardEditorScreen> {
  late final TextEditingController _frontController;
  late final TextEditingController _backController;

  @override
  void initState() {
    super.initState();
    _frontController = TextEditingController(text: widget.card?.front ?? '');
    _backController = TextEditingController(text: widget.card?.back ?? '');
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.card != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Card' : 'New Card')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _frontController,
              decoration: const InputDecoration(labelText: 'Front', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _backController,
              decoration: const InputDecoration(labelText: 'Back', border: OutlineInputBorder()),
              maxLines: 6,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _frontController.clear();
                      _backController.clear();
                    },
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final front = _frontController.text.trim();
                      final back = _backController.text.trim();
                      if (front.isEmpty || back.isEmpty) return;
                      final notifier = ref.read(cardsNotifierProvider(widget.deckId).notifier);
                      final navigator = Navigator.of(context);
                      if (isEditing) {
                        final updated = widget.card!.copyWith(front: front, back: back);
                        await notifier.update(updated);
                      } else {
                        await notifier.add(front, back);
                      }
                      if (!mounted) return;
                      navigator.pop();
                    },
                    child: Text(isEditing ? 'Save' : 'Create'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
