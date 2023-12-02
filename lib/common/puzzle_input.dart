import 'dart:async';
import 'dart:math' as math;

/// Type alias for puzzle functions.
///
/// A puzzle function solves an aoc puzzle for the provided [puzzleInput].
/// The solution of the puzzle is returned as an [int].
typedef Puzzle = FutureOr<dynamic> Function(String puzzleInput);

/// Extension on [String] that provides utility methods for easier parsing of
/// aoc puzzle inputs.
extension PuzzleInput on String {
  /// This [String] without the trailing newline character.
  String get _noEOF => endsWith('\n') ? substring(0, length - 1) : this;

  /// This [String] split into lines.
  ///
  /// A newline character at the end of the string is ignored.
  List<String> get lines => _noEOF.split('\n');

  /// Separates this [String] at blank lines and returns the resulting groups.
  List<String> get groups => _noEOF.split(RegExp(r'\n\s*\n', multiLine: true));

  /// Identical to [lines], but converts each line to type [T] using the provided [mapper].
  ///
  /// Returns the list of objects derived from the lines of this [String].
  List<T> list<T>(T Function(String) mapper) => lines.map(mapper).toList();

  /// Parses the lines of this [String] to [int] using [int.parse] and returns the resulting list.
  List<int> get ints => list(int.parse);

  /// Parses the lines of this [String] to [double] using [double.parse] and returns the resulting list.
  List<double> get doubles => list(double.parse);
}

/// Extensions on any [Iterable] of numeric values for easier calculations on them.
extension NumericPuzzle<T extends num> on Iterable<T> {

  /// Calculate the minimum value of this [Iterable].
  T get min => reduce(math.min);

  /// Calculate the maximum value of this [Iterable].
  T get max => reduce(math.max);

  /// Identical to [reduce], but allows [combine] function to return a [num] instead of a [T].
  ///
  /// The result is then cast to [T] using `toInt()` or `toDouble()` depending on the type of [T].
  T _reduceAndCast(num Function(T a, T b) combine) => reduce((a, b) {
      var result = combine(a, b);
      if (T.runtimeType == int) return result.toInt() as T;
      if (T.runtimeType == double) return result.toDouble() as T;
      return result as T;
    });

  /// Calculate the sum of all values in this [Iterable].
  T get sum => _reduceAndCast((a, b) => a + b);

  /// Multiply all values of this [Iterable] and return the result.
  T get multiplied => _reduceAndCast((a, b) => a * b);
}

/// A range of numbers. Can be iterated over.
class Range extends Iterable<int> {
  /// Creates a new [Range] from [from] to [to] (inclusive).
  ///
  /// So `Range(from: 0, to: 3)` will yield the numbers `0, 1, 2, 3`.
  const Range({required this.from, required this.to});

  /// Creates a new Range of [amount] numbers starting at [start] (0 by default).
  ///
  /// So `Range.count(4)` will yield the numbers `0, 1, 2, 3`.
  factory Range.count(int amount, {int start = 0}) =>
      Range(from: start, to: start + amount - 1);

  /// The first number in this range.
  final int from;
  /// The last number in this range.
  final int to;

  @override
  Iterator<int> get iterator => _RangeIterator(this);

  Range get reversed => Range(from: to, to: from);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Range &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          to == other.to;

  @override
  int get hashCode => from.hashCode ^ to.hashCode;

  @override
  String toString() => '$from to $to';
}

/// Iterator for [Range].
class _RangeIterator implements Iterator<int> {
  _RangeIterator(this._range);

  final Range _range;
  int? _current;

  @override
  int get current => _current!;

  @override
  bool moveNext() {
    if (_current == null) {
      _current = _range.from;
      return true;
    } else if (_range.to >= _range.from && _current! < _range.to) {
      _current = _current! + 1;
      return true;
    } else if (_range.to < _range.from && _current! > _range.to){
      _current = _current! - 1;
      return true;
    } else {
      return false;
    }
  }
}
