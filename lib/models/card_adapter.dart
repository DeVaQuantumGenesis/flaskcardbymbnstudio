import 'package:hive/hive.dart';
import 'card_model.dart';

class CardModelAdapter extends TypeAdapter<CardModel> {
  @override
  final int typeId = 1;

  @override
  CardModel read(BinaryReader reader) {
    final id = reader.readString();
    final deckId = reader.readString();
    final front = reader.readString();
    final back = reader.readString();
    final tags = reader.readList().map((e) => e as String).toList();
    final createdMs = reader.readInt();
    final updatedMs = reader.readInt();
    return CardModel(
      id: id,
      deckId: deckId,
      front: front,
      back: back,
      tags: tags,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedMs),
    );
  }

  @override
  void write(BinaryWriter writer, CardModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.deckId);
    writer.writeString(obj.front);
    writer.writeString(obj.back);
    writer.writeList(obj.tags);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    writer.writeInt(obj.updatedAt.millisecondsSinceEpoch);
  }
}
