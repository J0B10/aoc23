import 'package:aoc23/common/puzzle_input.dart';

enum Color {
  red,
  blue,
  green;

  factory Color.parse(String string) =>
      Color.values.firstWhere((color) => color.name == string);
}

class Reveal {
  const Reveal(this.amount, this.color);

  factory Reveal.parse(String string) {
    var words = string.split(' ');
    assert(words.length == 2);
    return Reveal(int.parse(words.first), Color.parse(words.last));
  }

  final int amount;
  final Color color;
}

class Game {
  const Game(this.id, this.reveal);

  factory Game.parse(String string) {
    var match = RegExp(r'Game (\d+): (.*)').firstMatch(string);
    assert(match != null);
    var id = int.parse(match!.group(1)!);
    var reveals = match.group(2)!.split(RegExp(r'[,;]\s*')).map(Reveal.parse);
    return Game(id, reveals.toList(growable: false));
  }

  final int id;
  final List<Reveal> reveal;

  int total(Color color) =>
      reveal.where((e) => e.color == color).map((e) => e.amount).max;

  int get power => Color.values.map(total).multiplied;
}

int day02A(String puzzleInput) {
  var games = puzzleInput.list(Game.parse);
  return games
      .where((game) =>
          game.total(Color.red) <= 12 &&
          game.total(Color.green) <= 13 &&
          game.total(Color.blue) <= 14)
      .map((game) => game.id)
      .sum;
}

int day02B(String puzzleInput) {
  var games = puzzleInput.list(Game.parse);
  return games.map((game) => game.power).sum;
}
