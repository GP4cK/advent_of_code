import 'dart:io';

const cards = 'J23456789TQKA';

void main() async {
  final file = File('./inputs/07.txt');
  final lines = await file.readAsLines();
  final ranked = <(String hand, int bid)>[];
  for (final line in lines) {
    final [hand, bid] = line.split(' ');
    insertInRanked(ranked, hand, int.parse(bid));
  }
  var result = 0;
  for (var i = 0; i < ranked.length; i++) {
    result += ranked[i].$2 * (i + 1);
  }
  print(result);
}

void insertInRanked(List<(String hand, int bid)> ranked, String hand, int bid) {
  for (var i = 0; i < ranked.length; i++) {
    if (!beats(hand, ranked[i].$1)) {
      ranked.insert(i, (hand, bid));
      return;
    }
  }
  ranked.add((hand, bid));
}

bool beats(String hand1, String hand2) {
  final type1 = getHandType(hand1);
  final type2 = getHandType(hand2);
  if (type1.score > type2.score) {
    return true;
  }
  if (type1.score < type2.score) {
    return false;
  }
  for (var i = 0; i < hand1.length; i++) {
    final card1 = hand1[i];
    final card2 = hand2[i];
    if (cards.indexOf(card1) > cards.indexOf(card2)) {
      return true;
    }
    if (cards.indexOf(card1) < cards.indexOf(card2)) {
      return false;
    }
  }
  throw Exception('Impossible to compare $hand1 and $hand2');
}

enum HandType {
  fiveOfKind(6),
  fourOfKind(5),
  fullHouse(4),
  threeOfKind(3),
  twoPair(2),
  onePair(1),
  highCard(0);

  const HandType(this.score);
  final int score;
}

HandType getHandType(String hand) {
  final map = <String, int>{};
  for (var i = 0; i < hand.length; i++) {
    final card = hand[i];
    if (map[card] == null) {
      map[card] = 1;
    } else {
      map[card] = map[card]! + 1;
    }
  }

  if (map.length == 1) return HandType.fiveOfKind;
  final jokers = map['J'] ?? 0;
  if (map.length == 2) {
    if (jokers > 0) return HandType.fiveOfKind;
    if (map.values.contains(4)) return HandType.fourOfKind;
    return HandType.fullHouse;
  }
  if (map.length == 3) {
    if (map.values.contains(3)) {
      if (jokers > 0) return HandType.fourOfKind;
      return HandType.threeOfKind;
    }
    if (jokers == 2) return HandType.fourOfKind;
    if (jokers == 1) return HandType.fullHouse;
    return HandType.twoPair;
  }
  if (map.length == 4) {
    if (jokers > 0) return HandType.threeOfKind;
    return HandType.onePair;
  }
  if (jokers > 0) return HandType.onePair;
  return HandType.highCard;
}
