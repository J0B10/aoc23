
/// Extension on [Pattern] to check if it matches a string exactly.
///
/// Only provides a single extension method [exactMatch].
extension ExactMatch on Pattern {

  /// Checks if this [Pattern] matches the [input] exactly.
  ///
  /// If this [Pattern] is a [String], returns if it is equal to the [input].
  /// If this [Pattern] is a [RegExp], returns if expression matches the entire [input].
  /// If type is neither [String] nor [RegExp], throws an [UnimplementedError].
  bool exactMatch(String input) {
    switch (this) {
      case String s:
        return s == input;
      case RegExp regExp:
        return regExp
            .allMatches(input)
            .any((match) => match.group(0)?.length == input.length);
      default:
        throw UnimplementedError('not implemented for $runtimeType');
    }
  }

  /// Matches this pattern against the string repeatedly to lazily
  /// find all matches, including matches that overlap.
  Iterable<Match> overlappingMatches(String input) =>
      _GenericIterable(_IterOverlappingMatches(this, input));
}

class _IterOverlappingMatches implements Iterator<Match> {
  _IterOverlappingMatches(this._regExp, this._input);

  final Pattern _regExp;
  final String _input;

  Match? _current;

  @override
  Match get current => _current!;

  @override
  bool moveNext() {
    var start = _current != null ? _current!.start + 1 : 0;
    _current = _regExp.allMatches(_input, start).firstOrNull;
    return _current != null;
  }
}

class _GenericIterable<T> extends Iterable<T> {
  _GenericIterable(this.iterator);

  @override
  final Iterator<T> iterator;
}
