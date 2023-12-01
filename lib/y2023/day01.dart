import 'package:aoc23/common/pattern_utils.dart';
import 'package:aoc23/common/puzzle_input.dart';

enum Number {
  one(1),
  two(2),
  three(3),
  four(4),
  five(5),
  six(6),
  seven(7),
  eight(8),
  nine(9);

  const Number(this.value);

  factory Number.of(String string) {
    var value = int.tryParse(string);
    if (value != null) {
      assert(value > 0 && value < 10);
      return Number.values.where((element) => element.value == value).first;
    }
    return Number.values.where((element) => element.name == string).first;
  }

  final int value;
}

int day01A(String puzzleInput) {
  var sum = 0;
  for (var line in puzzleInput.lines) {
    var ints = line.split('').map(int.tryParse).whereType<int>().toList();
    sum += ints.first * 10 + ints.last;
  }
  return sum;
}

int day01B(String puzzleInput) {
  var regex = RegExp(r'(\d|one|two|three|four|five|six|seven|eight|nine)');
  var sum = 0;
  for (var line in puzzleInput.lines) {
    var ints = regex
        .overlappingMatches(line)
        .map((match) => Number.of(match.group(0)!).value)
        .toList();
    sum += ints.first * 10 + ints.last;
  }
  return sum;
}
