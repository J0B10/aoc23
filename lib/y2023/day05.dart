import 'dart:isolate';

import 'package:aoc23/common/puzzle_input.dart';

abstract interface class Conversion {
  bool accepts(int value);

  int call(int value);
}

class RangeConversion implements Conversion {
  const RangeConversion(this.destStart, this.sourceStart, this.length);

  factory RangeConversion.parse(String string) {
    var args = string.split(RegExp(r'\s+')).map(int.parse).toList();
    assert(args.length == 3);
    return RangeConversion(args[0], args[1], args[2]);
  }

  final int destStart;
  final int sourceStart;
  final int length;

  @override
  int call(int value) {
    if (!accepts(value)) return value;
    return destStart + (value - sourceStart);
  }

  @override
  bool accepts(int value) =>
      value >= sourceStart && value < sourceStart + length;
}

class ConversionsMap implements Conversion {
  const ConversionsMap(this.description, this.conversions);

  factory ConversionsMap.parse(String string) {
    var lines = string.lines;
    var description = lines.first.split(' ').first;
    var conversions = lines.skip(1).map(RangeConversion.parse).toList();
    return ConversionsMap(description, conversions);
  }

  final String description;
  final List<RangeConversion> conversions;

  @override
  int call(int value) => conversions(value);

  @override
  bool accepts(int value) => true;
}

extension CallAll on List<Conversion> {
  int call(int value) {
    var val = value;
    for (var conversion in where((conversion) => conversion.accepts(value))) {
      val = conversion(val);
    }
    return val;
  }
}

int day05A(String puzzleInput) {
  var seeds = puzzleInput.lines.first
      .split(RegExp(r'\s+'))
      .skip(1)
      .map(int.parse)
      .toList();
  var maps = puzzleInput.groups.skip(1).map(ConversionsMap.parse).toList();
  var locations = seeds.map((seed) => maps(seed)).toList();
  return locations.min;
}

Future<int> day05B(String puzzleInput) async {
  var seedValues = puzzleInput.lines.first
      .split(RegExp(r'\s+'))
      .skip(1)
      .map(int.parse)
      .toList();
  var maps = puzzleInput.groups.skip(1).map(ConversionsMap.parse).toList();

  var seedRanges = <Range>[];
  for (var i = 0; i < seedValues.length; i += 2) {
    seedRanges.add(Range.count(seedValues[i + 1], start: seedValues[i]));
  }
  var results = await Future.wait([
    for (var range in seedRanges)
      Isolate.run(() {
        var results = range.map((seed) => maps(seed)).toList();
        return results.min;
      }),
  ]);
  return results.min;
}
