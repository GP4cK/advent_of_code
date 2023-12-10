import 'dart:io';

void main() async {
  final file = File('./inputs/10.txt');
  final lines = await file.readAsLines();
  final S = findS(lines);
  final map = lines.map((line) => line.split('')).toList();
  final pipe = getSPipe(map, S);
  map[S.y][S.x] = pipe;
  final loop = goFromStoS(map, S);
  replaceJunk(map, loop);
  final result = calculateArea(map);
  print(result);
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

String getSPipe(List<List<String>> lines, ({int x, int y}) S) {
  final isConnectedNorth = ['7', '|', 'F'].contains(lines[S.y - 1][S.x]);
  final isConnectedSouth = ['J', '|', 'L'].contains(lines[S.y + 1][S.x]);
  final isConnectedWest = ['-', 'L', 'F'].contains(lines[S.y][S.x - 1]);
  final isConnectedEast = ['-', '7', 'J'].contains(lines[S.y][S.x + 1]);
  switch ((
    isConnectedNorth,
    isConnectedEast,
    isConnectedSouth,
    isConnectedWest
  )) {
    case (true, true, false, false):
      return 'L';
    case (true, false, true, false):
      return '|';
    case (true, false, false, true):
      return 'J';
    case (false, true, true, false):
      return 'F';
    case (false, true, false, true):
      return '-';
    case (false, false, true, true):
      return '7';
    default:
      throw Exception('S is not connected');
  }
}

Map<int, Set<int>> goFromStoS(List<List<String>> map, ({int x, int y}) S) {
  var position = (x: S.x, y: S.y);
  Direction from;
  switch (map[S.y][S.x]) {
    case '-':
    case '7':
      from = Direction.west;
      break;
    case '|':
    case 'L':
      from = Direction.north;
      break;
    case 'F':
      from = Direction.south;
      break;
    case 'J':
      from = Direction.west;
      break;
    default:
      throw Exception('S is not connected');
  }
  final result = <int, Set<int>>{};
  do {
    result.putIfAbsent(position.y, () => <int>{});
    result[position.y]!.add(position.x);
    switch (map[position.y][position.x]) {
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
      default:
        throw Exception('Unknown pipe ${map[position.y][position.x]}');
    }
  } while ((position != S));

  return result;
}

void replaceJunk(List<List<String>> map, Map<int, Set<int>> loop) {
  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[y].length; x++) {
      if (map[y][x] != '.' && (!loop.containsKey(y) || !loop[y]!.contains(x))) {
        map[y][x] = '.';
      }
    }
  }
}

int calculateArea(List<List<String>> map) {
  var result = 0;
  for (var y = 0; y < map.length; y++) {
    final temp = result;
    var pipeCount = 0;
    String? lastCorner;
    for (var x = 0; x < map[y].length; x++) {
      switch (map[y][x]) {
        case '7':
          if (lastCorner == 'L') {
            pipeCount++;
          } else {
            assert(lastCorner == 'F');
          }
          lastCorner = null;
          break;
        case 'J':
          if (lastCorner == 'F') {
            pipeCount++;
          } else {
            assert(lastCorner == 'L');
          }
          break;
        case 'L':
          lastCorner = 'L';
          break;
        case 'F':
          lastCorner = 'F';
          break;
        case '|':
          pipeCount++;
          break;
        case '-':
          break;
        case '.':
          if (pipeCount % 2 == 1) result++;
          break;
        default:
          throw Exception('Unknown pipe ${map[y][x]}');
      }
    }
  }
  return result;
}
