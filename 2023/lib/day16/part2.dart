import 'dart:io';

late final List<String> lines;
final energized = <List<Tile>>[];

late final List<bool> top;
late final List<bool> right;
late final List<bool> bottom;
late final List<bool> left;

void main() async {
  final file = File('./inputs/16.txt');
  lines = await file.readAsLines();

  top = List<bool>.filled(lines[0].length, false);
  right = List<bool>.filled(lines.length, false);
  bottom = List<bool>.filled(lines[0].length, false);
  left = List<bool>.filled(lines.length, false);

  var max = 0;
  for (var i = 0; i < top.length; i++) {
    if (top[i]) continue;
    initEnergized();
    travel(i, 0, Move.down);
    final score = getScore();
    if (score >= max) max = score;
  }

  for (var i = 0; i < right.length; i++) {
    if (right[i]) continue;
    initEnergized();
    travel(lines.first.length - 1, i, Move.left);
    final score = getScore();
    if (score >= max) max = score;
  }

  for (var i = 0; i < bottom.length; i++) {
    if (bottom[i]) continue;
    initEnergized();
    travel(i, lines.length - 1, Move.up);
    final score = getScore();
    if (score >= max) max = score;
  }

  for (var i = 0; i < left.length; i++) {
    if (left[i]) continue;
    initEnergized();
    travel(0, i, Move.right);
    final score = getScore();
    if (score >= max) max = score;
  }

  print(max);
}

void initEnergized() {
  energized.clear();
  for (final line in lines) {
    final row = <Tile>[];
    for (var i = 0; i < line.length; i++) {
      switch (line[i]) {
        case '/':
          row.add(ForwardSlash());
        case '\\':
          row.add(BackSlash());
        default:
          row.add(RegularTile());
      }
    }
    energized.add(row);
  }
}

int getScore() {
  final result = energized.fold<int>(0, (acc, line) {
    var count = 0;
    for (var i = 0; i < line.length; i++) {
      if (line[i].visited) {
        count++;
      }
    }
    return acc + count;
  });
  return result;
}

enum Move { up, down, left, right }

abstract class Tile {
  bool get visited;
  void visit(Move move);
  bool visitedBy(Move move);
}

class RegularTile extends Tile {
  bool visitedY = false;
  bool visitedX = false;

  @override
  bool get visited => visitedY || visitedX;

  @override
  void visit(Move move) {
    if (move == Move.up || move == Move.down) {
      visitedY = true;
    } else {
      visitedX = true;
    }
  }

  @override
  bool visitedBy(Move move) {
    if (move == Move.up || move == Move.down) {
      return visitedY;
    } else {
      return visitedX;
    }
  }
}

class ForwardSlash extends Tile {
  bool visitedJ = false;
  bool visitedF = false;

  @override
  bool get visited => visitedJ || visitedF;

  @override
  void visit(Move move) {
    if (move == Move.up || move == Move.left) {
      visitedF = true;
    } else {
      visitedJ = true;
    }
  }

  @override
  bool visitedBy(Move move) {
    if (move == Move.up || move == Move.left) {
      return visitedF;
    } else {
      return visitedJ;
    }
  }
}

class BackSlash extends Tile {
  bool visited7 = false;
  bool visitedL = false;

  @override
  bool get visited => visited7 || visitedL;

  @override
  void visit(Move move) {
    if (move == Move.right || move == Move.up) {
      visited7 = true;
    } else {
      visitedL = true;
    }
  }

  @override
  bool visitedBy(Move move) {
    if (move == Move.right || move == Move.up) {
      return visited7;
    } else {
      return visitedL;
    }
  }
}

void travel(int x, int y, Move move) {
  if (x < 0) {
    left[y] = true;
  } else if (y < 0) {
    top[x] = true;
  } else if (y >= lines.length) {
    bottom[x] = true;
  } else if (x >= lines[y].length) {
    right[y] = true;
  }
  if (x < 0 || y < 0 || y >= lines.length || x >= lines[y].length) return;

  final tile = energized[y][x];
  if (tile.visitedBy(move)) return;
  tile.visit(move);

  if (move == Move.right || move == Move.left) {
    switch (lines[y][x]) {
      case '.':
      case '-':
        return travel(
          x + (move == Move.right ? 1 : -1),
          y,
          move,
        );
      case '/':
        return travel(
          x,
          y + (move == Move.right ? -1 : 1),
          move == Move.right ? Move.up : Move.down,
        );
      case '\\':
        return travel(
          x,
          y + (move == Move.right ? 1 : -1),
          move == Move.right ? Move.down : Move.up,
        );
      case '|':
        travel(x, y - 1, Move.up);
        travel(x, y + 1, Move.down);
    }
  } else {
    switch (lines[y][x]) {
      case '.':
      case '|':
        return travel(
          x,
          y + (move == Move.down ? 1 : -1),
          move,
        );
      case '/':
        return travel(
          x + (move == Move.down ? -1 : 1),
          y,
          move == Move.down ? Move.left : Move.right,
        );
      case '\\':
        return travel(
          x + (move == Move.down ? 1 : -1),
          y,
          move == Move.down ? Move.right : Move.left,
        );
      case '-':
        travel(x - 1, y, Move.left);
        travel(x + 1, y, Move.right);
    }
  }
}
