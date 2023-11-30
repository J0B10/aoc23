import 'package:http/http.dart' as http;

late String _session;

/// The session cookie used to fetch puzzle input from the Advent of Code website.
///
/// Value can only be set but not read.
set session(String session) => _session = session;

/// Creates the URI for fetching the puzzle input for the given [day] from the Advent of Code website.
///
/// Uri is: `https://adventofcode.com/2022/day/${DAY}/input`
Uri inputUri(int day) => Uri.https('adventofcode.com', '2022/day/$day/input');

/// Fetches the puzzle input for the given [day] from the Advent of Code website.
///
/// Day must be between 1 and 25 (inclusive).
Future<String> getPuzzleInput(int day) => http.read(inputUri(day), headers: {
    'Cookie': 'session=$_session',
  });
