import 'dart:io';

const map = {
  'red': 12,
  'green': 13,
  'blue': 14,
};

void main() async {
  final file = File('./inputs/02.txt');
  final lines = await file.readAsLines();
  var result = 0;
  for (var i = 0; i < lines.length; i++) {
    final [_, rounds] = lines[i].split(':');
    if (isPossible(rounds)) result += i + 1;
  }
  print(result);
}

bool isPossible(String rounds) {
  final hands = rounds.split(';');
  for (final hand in hands) {
    final cubes = hand.split(',');
    for (final cube in cubes) {
      final [nb, color] = cube.trim().split(' ');
      if (int.parse(nb) > map[color]!) return false;
    }
  }
  return true;
}
