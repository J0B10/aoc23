import 'package:aoc23/y2023/day01.dart';

import '../common/test.dart';

const example1 = '''
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
''';


const example2 = '''
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
''';


void main() {
  testPuzzle(day01A, input: example1, expected: 142);
  testPuzzle(day01B, input: example2, expected: 281);
}
