import 'dart:io' show Platform, exit, exitCode, stderr;
import 'dart:mirrors';

import 'package:ansicolor/ansicolor.dart';
import 'package:aoc23/common/aoc_api.dart' as aoc_api;
import 'package:aoc23/common/puzzle_input.dart';
import 'package:aoc23/y2023/day01.dart';
import 'package:aoc23/y2023/day02.dart';
import 'package:aoc23/y2023/day03.dart';
import 'package:aoc23/y2023/day04.dart';
import 'package:args/args.dart';

/// All puzzles supported by the cli. **Add new puzzles here!**
const Set<Puzzle> puzzles = {
  day01A,
  day01B,
  day02A,
  day02B,
  day03A,
  day03B,
  day04A,
  day04B,
};

/// Argument used to specify the day of the puzzle to run.
const argDay = 'day';

/// Argument used to specify the session cookie to use for authentication.
const argSession = 'session';

/// Argument used to specify if part 1 of the puzzle should be run.
const argPart1 = 'part1';

/// Argument used to specify if part 2 of the puzzle should be run.
const argPart2 = 'part2';

/// Argument used to specify if execution time should be tracked.
const argTiming = 'timings';

/// Environment variable used to specify the session cookie to use for authentication.
const envSession = 'AOC_SESSION';

/// Green ANSI color.
final green = AnsiPen()..green();

/// Yellow ANSI color.
final yellow = AnsiPen()..yellow(bold: true);

/// Red ANSI color.
final red = AnsiPen()..red();

/// Command line argument parser.
final parser = ArgParser()
  ..addOption(
    argDay,
    abbr: 'd',
    mandatory: true,
    help: 'Day of the puzzle to run (1 to 25)',
  )
  ..addOption(
    argSession,
    abbr: 's',
    aliases: ['token', 'cookie'],
    mandatory: false,
    help: 'Session cookie used to authenticate against Advent Of Code API'
        ' (Can also be specified by setting $envSession environment variable)',
  )
  ..addFlag(
    argPart1,
    abbr: 'a',
    help: 'If part 1 of the puzzle should be run',
  )
  ..addFlag(
    argPart2,
    abbr: 'b',
    help: 'If part 2 of the puzzle should be run',
  )
  ..addFlag(
    argTiming,
    abbr: 't',
    help: 'If exceution time of the puzzles should be tracked',
  );

/// Main entry point for the Advent of Code Dart CLI.
void main(List<String> arguments) async {
  var results = parser.parse(arguments);

  _parseSession(results);

  var day = int.tryParse(results[argDay]);
  if (day == null || day < 1  || day > 25) {
    stderr.writeln(red('Invalid day: ${results[argDay]}'));
    exit(2);
  }

  var taskA = results[argPart1] || !(results[argPart2] as bool);
  var taskB = results[argPart2] || !(results[argPart1] as bool);

  if (taskA) {
    var input = await aoc_api.getPuzzleInput(day);
    await runPuzzle(day, task: 'A', input: input, trackTime: results[argTiming]);
  }

  if (taskB) {
    var input = await aoc_api.getPuzzleInput(day);
    await runPuzzle(day, task: 'B', input: input, trackTime: results[argTiming]);
  }
}

/// Runs the puzzle for the given [day] and [task] with the provided [input].
///
/// [task] must be either `A` (for part 1) or `B` (for part 2).
///
/// If no puzzle is found for the given [day] and [task],
/// an error is printed to stderr and the program exits with code 2.
///
/// If you want to track and log execution time of the puzzle, set [trackTime] to true.
Future<void> runPuzzle(int day, {required String input, String task = 'A', bool trackTime = false}) async {
  var puzzle = selectPuzzle(day, task);
  if (puzzle == null) {
    stderr.writeln(red('Puzzle not found for day $day, part $task'));
    exit(2);
  }
  var timer = trackTime ? Stopwatch() : null;
  try {
    timer?.start();
    var result = await puzzle(input);
    timer?.stop();
    var time = timer?.elapsed;
    var dayPrefix = '[Day ${day.toString().padLeft(2, '0')}${task.toUpperCase()}]';
    print('${green(dayPrefix)} Result: ${yellow("'$result'")}');
   if (time != null) print('${green(dayPrefix)} Execution Time: ${red(time)}\n');
  } on Exception catch (e) {
    stderr
      ..writeln(red('Error while running puzzle $day$task:'))
      ..writeln(red(e));
    exitCode = 1;
  }
}

/// Selects the puzzle for the given [day] and [task].
///
/// [task] must be either `A` (for part 1) or `B` (for part 2).
///
/// If no puzzle is found for the given [day] and [task],
/// `null` is returned.
Puzzle? selectPuzzle(int day, String task) {
  var partDay = day.toString().padLeft(2, '0');
  var partTask = task.toUpperCase();
  assert(partTask == 'A' || partTask == 'B');
  var selectionName = Symbol('day$partDay$partTask');
  return puzzles.where((puzzle) {
    var mirror = reflect(puzzle) as ClosureMirror;
    var puzzleName = mirror.function.simpleName;
    return puzzleName == selectionName;
  }).firstOrNull;
}

/// Parses the session cookie from the given [results] and sets it in the [aoc_api] library.
///
/// If no session cookie is found, an error is printed to stderr and the program exits with code 2.
void _parseSession(ArgResults results) {
  var session =
      results[argSession] ?? Platform.environment[envSession];
  if (session == null) {
    stderr.writeln(red('AOC session cookie must be provided'));
    exit(2);
  }
  aoc_api.session = session;
}
