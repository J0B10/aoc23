import 'dart:math';

import 'package:aoc23/common/puzzle_input.dart';

class ScratchCard {
  const ScratchCard(this.id, this.winningNumbers, this.numbers);

  factory ScratchCard.parse(String string) {
    var match =
        RegExp(r'^Card\s+(\d+):\s+(.*)\s+\|\s+(.*)$').firstMatch(string)!;
    var id = int.parse(match.group(1)!);
    var winning = match.group(2)!.split(RegExp(r'\s+')).map(int.parse).toSet();
    var numbers = match.group(3)!.split(RegExp(r'\s+')).map(int.parse).toSet();
    return ScratchCard(id, winning, numbers);
  }

  final int id;

  final Set<int> numbers;
  final Set<int> winningNumbers;

  Set<int> get matchingNumbers =>
      numbers.where(winningNumbers.contains).toSet();

  int get points =>
      matchingNumbers.isEmpty ? 0 : pow(2, matchingNumbers.length - 1).toInt();
}

int day04A(String puzzleInput) =>
    puzzleInput.list(ScratchCard.parse).map((card) => card.points).sum;

int day04B(String puzzleInput) {
  var cards = {
    for (var card in puzzleInput.list(ScratchCard.parse)) card.id: card,
  };
  var inventory = {
    for (var card in cards.values) card: 1,
  };
  var totalCards = 0;
  while (inventory.isNotEmpty) {
    var card = inventory.keys.first;
    var amount = inventory.remove(card)!;
    totalCards += amount;
    var won = card.matchingNumbers.length;
    for (var i = 1; i <= won; i++) {
      var wonCard = cards[card.id + i]!;
      inventory[wonCard] = inventory[wonCard]! + amount;
    }
  }
  return totalCards;
}
