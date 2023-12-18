import 'dart:io';

void main() async {
  final file = File('./inputs/18.txt');
  final lines = await file.readAsLines();
  final grid = [
    ['S']
  ];

  var x = 0;
  var y = 0;
  String? previousCommand;
  for (final line in lines) {
    final [command, length, _] = line.split(' ');
    final len = int.parse(length);
    switch (command) {
      case 'U':
        for (var i = 1; i <= len; i++) {
          y--;
          if (y == -1) {
            grid.insert(0, List.filled(grid[0].length, '.', growable: true));
            y = 0;
          }
          grid[y][x] = '|';
        }
      case 'R':
        for (var i = 1; i <= len; i++) {
          x++;
          if (x == grid[y].length) {
            for (var j = 0; j < grid.length; j++) {
              grid[j].add('.');
            }
          }
          grid[y][x] = '-';
        }
      case 'D':
        for (var i = 1; i <= len; i++) {
          y++;
          if (y == grid.length) {
            grid.add(List.filled(grid[0].length, '.', growable: true));
          }
          grid[y][x] = '|';
        }
      case 'L':
        for (var i = 1; i <= len; i++) {
          x--;
          if (x == -1) {
            for (var j = 0; j < grid.length; j++) {
              grid[j].insert(0, '.');
            }
            x = 0;
          }
          grid[y][x] = '-';
        }
    }
    if (previousCommand != null) {
      switch (previousCommand) {
        case 'U':
          if (command == 'L') {
            grid[y][x + len] = '7';
          } else if (command == 'R') {
            grid[y][x - len] = 'F';
          }
          break;
        case 'R':
          if (command == 'U') {
            grid[y + len][x] = 'J';
          } else if (command == 'D') {
            grid[y - len][x] = '7';
          }
          break;
        case 'D':
          if (command == 'L') {
            grid[y][x + len] = 'J';
          } else if (command == 'R') {
            grid[y][x - len] = 'L';
          }
          break;
        case 'L':
          if (command == 'U') {
            grid[y + len][x] = 'L';
          } else if (command == 'D') {
            grid[y - len][x] = 'F';
          }
          break;
      }
    }
    previousCommand = command;
  }

  grid[y][x] = getSPipe(grid, (x: x, y: y));

  var result = calculateArea(grid);
  for (final row in grid) {
    print(row.join(''));
  }
  print(result);
}

String getSPipe(List<List<String>> lines, ({int x, int y}) S) {
  final isConnectedNorth = S.y >= 0 //
      ? false
      : ['7', '|', 'F'].contains(lines[S.y - 1][S.x]);
  final isConnectedSouth = ['J', '|', 'L'].contains(lines[S.y + 1][S.x]);
  final isConnectedWest = S.x >= 0 //
      ? false
      : ['-', 'L', 'F'].contains(lines[S.y][S.x - 1]);
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

// From day 10
int calculateArea(List<List<String>> map) {
  var result = 0;
  for (var y = 0; y < map.length; y++) {
    var pipeCount = 0;
    String? lastCorner;
    for (var x = 0; x < map[y].length; x++) {
      switch (map[y][x]) {
        case '7':
          result++;
          if (lastCorner == 'L') {
            pipeCount++;
          } else {
            assert(lastCorner == 'F');
          }
          lastCorner = null;
          break;
        case 'J':
          result++;
          if (lastCorner == 'F') {
            pipeCount++;
          } else {
            assert(lastCorner == 'L');
          }
          break;
        case 'L':
          result++;
          lastCorner = 'L';
          break;
        case 'F':
          result++;
          lastCorner = 'F';
          break;
        case '|':
          result++;
          pipeCount++;
          break;
        case '-':
          result++;
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
