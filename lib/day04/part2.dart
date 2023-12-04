import 'dart:io';

List<String> splitAndTrim(String str) {
  return str.split(' ').map((nb) => nb.trim()).where((nb) => nb != '').toList();
}

void main() async {
  final file = File('./inputs/04.txt');
  final lines = await file.readAsLines();
  final points = <int>[];
  for (final line in lines) {
    final [_, allNumbers] = line.split(': ');
    final [winningNumbers, numbers] = allNumbers.split(' | ');
    final winningNumbersSplit = splitAndTrim(winningNumbers);
    final count = splitAndTrim(numbers).fold(0, (previousValue, number) {
      if (winningNumbersSplit.contains(number)) return previousValue + 1;
      return previousValue;
    });
    points.add(count);
  }
  final cards = points.map((_) => 1).toList();
  for (var i = 0; i < cards.length; i++) {
    final cardPoints = points[i];
    final multiplier = cards[i];
    for (var j = 1; j <= cardPoints; j++) {
      cards[i + j] += multiplier;
    }
  }
  final result =
      cards.fold(0, (previousValue, element) => previousValue + element);
  print(result);
}
