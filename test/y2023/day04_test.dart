import 'package:aoc23/common/puzzle_input.dart';
import 'package:aoc23/y2023/day04.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../common/test.dart';

const example = '''
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
''';

void main() {
  test('parsing scratch cards', () {
    var card = ScratchCard.parse(example.lines.first);
    expect(card.id, 1);
    expect(card.winningNumbers, {41, 48, 83, 86, 17});
    expect(card.numbers, {83, 86, 6, 31, 17, 9, 48, 53});
    expect(card.matchingNumbers, {48, 83, 17, 86});
    expect(card.points, 8);
  });
  testPuzzle(day04A, input: example, expected: 13);
  testPuzzle(day04B, input: example, expected: 30);
}
