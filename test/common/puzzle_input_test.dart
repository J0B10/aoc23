import 'package:aoc23/common/puzzle_input.dart';
import 'package:test/test.dart';

void main() {
  test('Range to string', () {
    expect(const Range(from: 3, to: 10).toString(), '3 to 10');
  });
  test('Reversed Range to string', () {
    expect(const Range(from: -4, to: 5).reversed.toString(), '5 to -4');
  });
  test('Iterate Range', () {
    const range = Range(from: 0, to: 2);
    var iterator = range.iterator;
    expect(iterator.moveNext(), true);
    expect(iterator.current, 0);
    expect(iterator.moveNext(), true);
    expect(iterator.current, 1);
    expect(iterator.moveNext(), true);
    expect(iterator.current, 2);
    expect(iterator.moveNext(), false);
  });
  test('Iterate reversed Range', () {
    var range = Range(from: 0, to: 2).reversed;
    var iterator = range.iterator;
    expect(iterator.moveNext(), true);
    expect(iterator.current, 2);
    expect(iterator.moveNext(), true);
    expect(iterator.current, 1);
    expect(iterator.moveNext(), true);
    expect(iterator.current, 0);
    expect(iterator.moveNext(), false);
  });
  test('Range as list', () {
    var range = Range.count(3).toList();
    expect(range, const [0, 1, 2]);
  });
  test('Range equality', () {
    var range = Range(from: 0, to: 2);
    var other = Range(from: 2, to: 0);
    expect(range == other, false);
    expect(other.reversed, range);
  });
  test('Range count constructor', () {
    var range = Range(from: 0, to: 3);
    var count = Range.count(4);
    expect(count, range);
    expect(count.reversed, range.reversed);
    expect(Range.count(5, start: 1), Range(from: 1, to: 5));
  });
}
