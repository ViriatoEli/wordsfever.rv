class Player {
  final String name;
  int score;
  int lives;
  bool isEliminated;

  Player({
    required this.name,
    this.score = 0,
    this.lives = 3,
    this.isEliminated = false,
  });

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  Player copyWith({String? name, int? score, int? lives, bool? isEliminated}) {
    return Player(
      name: name ?? this.name,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      isEliminated: isEliminated ?? this.isEliminated,
    );
  }
}
