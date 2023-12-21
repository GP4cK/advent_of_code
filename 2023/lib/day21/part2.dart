import 'dart:collection';
import 'dart:io';
import 'dart:math';

// 26501365 % 131 = 65
// The square is 131 x 131

// f(x) = ax^2 + bx + c
// f(65) = 3885 = 4225a + 65b + c
// f(65+131*2) = 96215 = 106929a + 327b + c
// f(65+131*4) = 311345 = 106929a + 327b + c
// So: a = 15350/17161, b = 30415/17161, c=-160240/17161
// f(26501365) = 628206330073385

// a65^2 + b65 + c = 3885
// a(65+131)^2 + b(65+131) + c = 34354
// a(65+131*2)^2 + b(65+131*2) + c = 96215
// a(65+131*4)^2 + b(65+131*4) + c = 311345

void main() async {
  const a = 15350 / 17161;
  const b = 30415 / 17161;
  const c = -160240 / 17161;
  const x = 26501365;
  print(a * pow(x, 2) + b * x + c);
  const fileName = './inputs/21.txt';
  final file = File(fileName);
  final lines = await file.readAsLines();
  final S = findS(lines);
  final reached = {S: 0};
  var reachedEven = <(int, int)>{};

  final maxSteps = fileName.endsWith('21a.txt') ? 6 : 65 + 131 * 2;
  for (var steps = 0; steps < maxSteps; steps++) {
    final frontier = Queue.of(reached.entries
        .where((entry) => entry.value == steps)
        .map((entry) => entry.key));
    while (frontier.isNotEmpty) {
      final current = frontier.removeFirst();
      for (final next in getNeighbors(lines, current)) {
        reached.putIfAbsent(next, () => steps + 1);
        if ((steps + 1) % 2 == 1 && !reachedEven.contains(next)) {
          reachedEven.add(next);
        }
      }
    }
  }
  // debugPrint(lines, reachedEven);
  print(reachedEven.length);
}

(int, int) findS(List<String> lines) {
  for (var y = 0; y < lines.length; y++) {
    for (var x = 0; x < lines[y].length; x++) {
      if (lines[y][x] == 'S') return (x, y);
    }
  }
  throw Exception('No S found');
}

Set<(int, int)> getNeighbors(List<String> lines, (int, int) current) {
  final result = <(int, int)>{};
  final (x, y) = current;
  if (lines[(y - 1) % lines.length][x % lines.length] != '#') {
    result.add((x, y - 1));
  }
  if (lines[(y + 1) % lines.length][x % lines.length] != '#') {
    result.add((x, y + 1));
  }
  if (lines[y % lines.length][(x - 1) % lines.length] != '#') {
    result.add((x - 1, y));
  }
  if (lines[y % lines.length][(x + 1) % lines.length] != '#') {
    result.add((x + 1, y));
  }
  return result;
}

void debugPrint(List<String> lines, Set<(int, int)> reached) {
  var rowIndex = 0;
  final result = lines.map((line) {
    var colIndex = 0;
    final row = line.split('').map((cell) {
      final replaced = reached.contains((colIndex, rowIndex)) ? 'O' : cell;
      colIndex++;
      return replaced;
    }).join();
    rowIndex++;
    return row;
  });

  for (final row in result) {
    print(row);
  }
  print('');
}
