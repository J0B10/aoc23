/// Utility functions for testing.
library;
import 'dart:mirrors';

import 'package:aoc23/common/puzzle_input.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

/// Run a [test] on any [Puzzle] function with the given [input] and [expected] result.
///
/// The test description will be the name of the function and is determined using reflection.
void testPuzzle(Puzzle puzzle, {required String input, required int expected}) {
  var mirror = reflect(puzzle) as ClosureMirror;
  var name = MirrorSystem.getName(mirror.function.simpleName);
  test(name, () async {
    var result = await puzzle(input);
    expect(result, expected);
  });
}
