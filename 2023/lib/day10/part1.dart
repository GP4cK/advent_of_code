import 'dart:io';

void main() async {
  final file = File('./inputs/10.txt');
  final lines = await file.readAsLines();
  final S = findS(lines);
  final steps = goFromStoS(lines, S);
  print(steps / 2);
}

({int x, int y}) findS(List<String> lines) {
  for (var y = 0; y < lines.length; y++) {
    for (var x = 0; x < lines[y].length; x++) {
      if (lines[y][x] == 'S') {
        return (x: x, y: y);
      }
    }
  }
  throw Exception('S not found');
}

enum Direction {
  north,
  east,
  south,
  west,
}

int goFromStoS(List<String> lines, ({int x, int y}) S) {
  var steps = 1;
  var position = (x: S.x, y: S.y - 1);
  var from = Direction.south;
  while (position != S) {
    switch (lines[position.y][position.x]) {
      case '-':
        if (from == Direction.west) {
          position = (x: position.x + 1, y: position.y);
        } else {
          position = (x: position.x - 1, y: position.y);
        }
        break;
      case '|':
        if (from == Direction.north) {
          position = (x: position.x, y: position.y + 1);
        } else {
          position = (x: position.x, y: position.y - 1);
        }
        break;
      case 'F':
        if (from == Direction.east) {
          position = (x: position.x, y: position.y + 1);
          from = Direction.north;
        } else {
          position = (x: position.x + 1, y: position.y);
          from = Direction.west;
        }
        break;
      case 'L':
        if (from == Direction.north) {
          position = (x: position.x + 1, y: position.y);
          from = Direction.west;
        } else {
          position = (x: position.x, y: position.y - 1);
          from = Direction.south;
        }
        break;
      case '7':
        if (from == Direction.south) {
          position = (x: position.x - 1, y: position.y);
          from = Direction.east;
        } else {
          position = (x: position.x, y: position.y + 1);
          from = Direction.north;
        }
        break;
      case 'J':
        if (from == Direction.west) {
          position = (x: position.x, y: position.y - 1);
          from = Direction.south;
        } else {
          position = (x: position.x - 1, y: position.y);
          from = Direction.east;
        }
        break;
    }
    steps++;
  }

  return steps;
}
