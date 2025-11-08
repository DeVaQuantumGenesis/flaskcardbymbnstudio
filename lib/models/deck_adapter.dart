import 'package:hive/hive.dart';
import 'deck.dart';

class DeckAdapter extends TypeAdapter<Deck> {
  @override
  final int typeId = 0;

  @override
  Deck read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final hasDescription = reader.readBool();
    final description = hasDescription ? reader.readString() : null;
    final createdMs = reader.readInt();
    final updatedMs = reader.readInt();
    return Deck(
      id: id,
      title: title,
      description: description,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedMs),
    );
  }

  @override
  void write(BinaryWriter writer, Deck obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeBool(obj.description != null);
    if (obj.description != null) writer.writeString(obj.description!);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    writer.writeInt(obj.updatedAt.millisecondsSinceEpoch);
  }
}
