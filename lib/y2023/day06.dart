import 'dart:math';

import 'package:aoc23/common/puzzle_input.dart';

class BoatRace {
  const BoatRace(this.time, this.recordDistance);

  final int time;
  final int recordDistance;

  int distance(int chargeTime) => (time - chargeTime) * chargeTime;

  /// Calculate the allowed range of charge times for the boat to win.
  ///
  /// The range is calculated by solving the following equation for `chargeTime`:
  /// `recordDistance < (time - chargeTime) * chargeTime`
  Range get winningChargeTimes {
    var min = (time - sqrt(time * time - 4 * recordDistance)) / 2;
    var max = (time + sqrt(time * time - 4 * recordDistance)) / 2;
    return Range(from: min.ceil(), to: max.floor());
  }
}

List<BoatRace> parseA(String input) {
  var times =
      input.lines.first.split(RegExp(r'\s+')).skip(1).map(int.parse).toList();
  var distances =
      input.lines.last.split(RegExp(r'\s+')).skip(1).map(int.parse).toList();
  assert(times.length == distances.length);
  return [
    for (var i = 0; i < times.length; i++) BoatRace(times[i], distances[i]),
  ];
}

int day06A(String puzzleInput) => parseA(puzzleInput)
    .map((race) => race.winningChargeTimes.length)
    .multiplied;

BoatRace parseB(String input) {
  var time = int.parse(
    input.lines.first.replaceAll(RegExp(r'\s+'), '').split(':').last,
  );
  var distance = int.parse(
    input.lines.last.replaceAll(RegExp(r'\s+'), '').split(':').last,
  );
  return BoatRace(time, distance);
}

int day06B(String puzzleInput) => parseB(puzzleInput).winningChargeTimes.length;
