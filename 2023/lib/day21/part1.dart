import 'dart:collection';
import 'dart:io';

void main() async {
  const fileName = './inputs/21.txt';
  final file = File(fileName);
  final lines = await file.readAsLines();
  final S = findS(lines);
  final reached = {S: 0};
  var reachedEven = <(int, int)>{};

  final maxSteps = fileName.endsWith('21a.txt') ? 6 : 64;
  for (var steps = 0; steps < maxSteps; steps++) {
    final frontier = Queue.of(reached.entries
        .where((entry) => entry.value == steps)
        .map((entry) => entry.key));
    while (frontier.isNotEmpty) {
      final current = frontier.removeFirst();
      for (final next in getNeighbors(lines, current)) {
        reached.putIfAbsent(next, () => steps + 1);
        if ((steps + 1) % 2 == 0 && !reachedEven.contains(next)) {
          reachedEven.add(next);
        }
      }
    }
  }
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
  if (y > 0 && lines[y - 1][x] != '#') result.add((x, y - 1));
  if (y < lines.length - 1 && lines[y + 1][x] != '#') result.add((x, y + 1));
  if (x > 0 && lines[y][x - 1] != '#') result.add((x - 1, y));
  if (x < lines[y].length - 1 && lines[y][x + 1] != '#') result.add((x + 1, y));
  return result;
}
