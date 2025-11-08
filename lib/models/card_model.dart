class CardModel {
  final String id;
  final String deckId;
  final String front;
  final String back;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  CardModel({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : tags = tags ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  CardModel copyWith({
    String? id,
    String? deckId,
    String? front,
    String? back,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CardModel(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      front: front ?? this.front,
      back: back ?? this.back,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'deckId': deckId,
        'front': front,
        'back': back,
        'tags': tags,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CardModel.fromMap(Map<dynamic, dynamic> map) => CardModel(
        id: map['id'] as String,
        deckId: map['deckId'] as String,
        front: map['front'] as String,
        back: map['back'] as String,
        tags: (map['tags'] as List?)?.map((e) => e as String).toList() ?? [],
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
}
