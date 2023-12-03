import 'package:aoc23/common/puzzle_input.dart';

class Grid {
  Grid(this.raw);

  final String raw;

  late final int height = raw.lines.length;

  late final int _raw_width = raw.indexOf('\n') + 1;

  late final Map<({int x, int y}), int> numbers = {
    for (var match in RegExp(r'\d+').allMatches(raw))
      for (var i in Range(from: match.start, to: match.end - 1))
        coordinates(i): int.parse(match.group(0)!),
  };

  late final Map<({int x, int y}), String> symbols = {
    for (var match in RegExp(r'[^\d.\s]').allMatches(raw))
      coordinates(match.start): match.group(0)!,
  };

  int get width => _raw_width - 1;

  ({int x, int y}) coordinates(int index) => (
        x: index % _raw_width,
        y: index ~/ _raw_width,
      );

  dynamic operator [](({int x, int y}) coordinates) =>
      symbols[coordinates] ?? numbers[coordinates];

  Set<int> adjacentNumbers(({int x, int y}) coords) => [
        (y: coords.y + 1, x: coords.x + 0),
        (y: coords.y + 1, x: coords.x + 1),
        (y: coords.y + 0, x: coords.x + 1),
        (y: coords.y - 1, x: coords.x + 1),
        (y: coords.y - 1, x: coords.x + 0),
        (y: coords.y - 1, x: coords.x - 1),
        (y: coords.y + 0, x: coords.x - 1),
        (y: coords.y + 1, x: coords.x - 1),
      ].map((coords) => numbers[coords]).whereType<int>().toSet();

  List<Gear> get gears => symbols.entries
          .where((entry) => entry.value == '*')
          .map((entry) => entry.key)
          .expand((coords) {
        var adjacent = adjacentNumbers(coords);
        if (adjacent.length != 2) return <Gear>[];
        return [Gear(coords, adjacent.first, adjacent.last)];
      }).toList();
}

class Gear {
  const Gear(this.coordinates, this.part1, this.part2);

  final ({int x, int y}) coordinates;
  final int part1;
  final int part2;

  int get ratio => part1 * part2;
}

int day03A(String puzzleInput) {
  var grid = Grid(puzzleInput);
  return grid.symbols.keys
      .map((symbol) => grid.adjacentNumbers(symbol).sum)
      .sum;
}

int day03B(String puzzleInput) =>
    Grid(puzzleInput).gears.map((gear) => gear.ratio).sum;
