import 'dart:io';
import 'dart:math';

List<String> splitAndTrim(String str) {
  return str.split(' ').map((nb) => nb.trim()).where((nb) => nb != '').toList();
}

void main() async {
  final file = File('./inputs/04.txt');
  final lines = await file.readAsLines();
  num result = 0;
  for (final line in lines) {
    final [_, allNumbers] = line.split(': ');
    final [winningNumbers, numbers] = allNumbers.split(' | ');
    final winningNumbersSplit = splitAndTrim(winningNumbers);
    final count = splitAndTrim(numbers).fold(0, (previousValue, number) {
      if (winningNumbersSplit.contains(number)) return previousValue + 1;
      return previousValue;
    });
    if (count > 0) result += pow(2, count - 1);
  }
  print(result);
}
