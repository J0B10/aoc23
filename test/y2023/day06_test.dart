import 'package:aoc23/y2023/day06.dart';

import '../common/test.dart';

const example = '''
Time:      7  15   30
Distance:  9  40  200
''';

void main() {
  testPuzzle(day06A, input: example, expected: 288);
  testPuzzle(day06B, input: example, expected: 71503);
}
