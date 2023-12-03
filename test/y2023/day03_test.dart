import 'package:aoc23/y2023/day03.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../common/test.dart';

const example = r'''
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
''';

void main() {
  test('test grid creation', () {
    var grid = Grid(example);
    expect(grid.width, 10);
    expect(grid.height, 10);
    expect(grid[(x: 3, y: 1)], '*');
    expect(grid[(x: 0, y: 0)], 467);
    expect(grid[(x: 6, y: 9)], 598);
    expect(grid.adjacentNumbers((x: 3, y: 1)), {467, 35});
  });
  testPuzzle(day03A, input: example, expected: 4361);
  testPuzzle(day03B, input: example, expected: 467835);
}
