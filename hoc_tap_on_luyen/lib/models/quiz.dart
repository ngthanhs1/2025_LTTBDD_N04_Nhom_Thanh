class Topic {
  final String id;
  final String name;
  final String? createdBy;
  final DateTime createdAt;

  Topic({
    required this.id,
    required this.name,
    this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'createdBy': createdBy,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  static Topic fromDoc(String id, Map<String, dynamic> data) => Topic(
    id: id,
    name: (data['name'] ?? '') as String,
    createdBy: data['createdBy'] as String?,
    createdAt: DateTime.fromMillisecondsSinceEpoch(
      (data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch) as int,
    ),
  );
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
  });

  Map<String, dynamic> toMap() => {
    'text': text,
    'options': options,
    'correctIndex': correctIndex,
  };

  static Question fromDoc(String id, Map<String, dynamic> data) => Question(
    id: id,
    text: (data['text'] ?? '') as String,
    options: List<String>.from(data['options'] ?? const <String>[]),
    correctIndex: (data['correctIndex'] ?? 0) as int,
  );
}
