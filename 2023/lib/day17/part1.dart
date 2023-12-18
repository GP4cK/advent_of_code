import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

void main() async {
  final file = File('./inputs/17.txt');
  final lines = await file.readAsLines();
  final grid = lines
      .map((line) => line.split("").map((cell) => int.parse(cell)).toList())
      .toList();

  final frontier = PriorityQueue<QueueItem>();
  frontier.addAll([
    QueueItem(pos: (0, 0), priority: 0, from: Axis.x),
    QueueItem(pos: (0, 0), priority: 0, from: Axis.y),
  ]);
  final costSoFar = <(int, int, Axis), int>{};
  final cameFrom = <(int, int), (int, int)>{};
  costSoFar[(0, 0, Axis.x)] = 0;
  costSoFar[(0, 0, Axis.y)] = 0;
  while (frontier.isNotEmpty) {
    final current = frontier.removeFirst();
    if (current.pos == (grid.first.length - 1, grid.length - 1)) break;
    final neighbors = getNeighbors(grid, current);
    for (final next in neighbors) {
      final newCost =
          costSoFar[(current.pos.$1, current.pos.$2, current.from)]! +
              next.cost;
      final key = (next.pos.$1, next.pos.$2, next.from);
      if (!costSoFar.containsKey(key) || newCost < costSoFar[key]!) {
        costSoFar[key] = newCost;
        final priority = newCost +
            (grid.length - next.pos.$2) +
            (grid.first.length - next.pos.$1);
        frontier.add(
          QueueItem(
            pos: next.pos,
            priority: priority,
            from: next.from,
          ),
        );
        cameFrom[next.pos] = current.pos;
      }
    }
  }

  final result = min(
    costSoFar[(grid.first.length - 1, grid.length - 1, Axis.x)] ?? 9999999999,
    costSoFar[(grid.first.length - 1, grid.length - 1, Axis.y)] ?? 9999999999,
  );
  print(result);
}

class QueueItem implements Comparable<QueueItem> {
  final (int, int) pos;
  final int priority;
  final Axis from;

  QueueItem({
    required this.pos,
    required this.priority,
    required this.from,
  });

  @override
  int compareTo(QueueItem other) {
    return priority - other.priority;
  }
}

enum Axis { x, y }

List<({(int, int) pos, int cost, Axis from})> getNeighbors(
    List<List<int>> grid, QueueItem current) {
  final neighbors = <({(int, int) pos, int cost, Axis from})>[];
  final (x, y) = current.pos;
  switch (current.from) {
    case Axis.y:
      var cost = 0;
      final maxX = min(x + 3, grid.first.length - 1);
      for (var i = x + 1; i <= maxX; i++) {
        cost += grid[y][i];
        neighbors.add((
          pos: (i, y),
          cost: cost,
          from: Axis.x,
        ));
      }

      cost = 0;
      final minX = max(0, x - 3);
      for (var i = x - 1; i >= minX; i--) {
        cost += grid[y][i];
        neighbors.add((
          pos: (i, y),
          cost: cost,
          from: Axis.x,
        ));
      }

    case Axis.x:
      var cost = 0;
      final maxY = min(y + 3, grid.length - 1);
      for (var i = y + 1; i <= maxY; i++) {
        cost += grid[i][x];
        neighbors.add((
          pos: (x, i),
          cost: cost,
          from: Axis.y,
        ));
      }

      cost = 0;
      final minY = max(0, y - 3);
      for (var i = y - 1; i >= minY; i--) {
        cost += grid[i][x];
        neighbors.add((
          pos: (x, i),
          cost: cost,
          from: Axis.y,
        ));
      }
  }
  return neighbors;
}
