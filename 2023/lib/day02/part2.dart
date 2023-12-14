import 'dart:io';

void main() async {
  final file = File('./inputs/02.txt');
  final lines = await file.readAsLines();
  var result = 0;
  for (var i = 0; i < lines.length; i++) {
    final [_, rounds] = lines[i].split(':');
    result += getPower(rounds);
  }
  print(result);
}

int getPower(String rounds) {
  final hands = rounds.split(';');
  final max = {
    'red': 0,
    'blue': 0,
    'green': 0,
  };
  for (final hand in hands) {
    final cubes = hand.split(',');
    for (final cube in cubes) {
      final [nbStr, color] = cube.trim().split(' ');
      final nb = int.parse(nbStr);
      if (nb > max[color]!) max[color] = nb;
    }
  }
  return max['red']! * max['blue']! * max['green']!;
}
