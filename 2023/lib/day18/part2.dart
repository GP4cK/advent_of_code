import 'dart:io';

void main() async {
  final file = File('./inputs/18.txt');
  final lines = await file.readAsLines();
  final coordinates = [(0, 0)];

  var perimeter = 0;
  for (final line in lines) {
    final (x, y) = coordinates.last;
    final color = line.substring(line.length - 1 - 6, line.length - 1);
    final distance = int.parse(color.substring(0, color.length - 1), radix: 16);
    perimeter += distance;
    switch (color[color.length - 1]) {
      case '0':
        coordinates.add((x + distance, y));
      case '1':
        coordinates.add((x, y + distance));
      case '2':
        coordinates.add((x - distance, y));
      case '3':
        coordinates.add((x, y - distance));
    }
  }

  var result = calculateArea(coordinates);
  print(result + perimeter / 2 + 1);
}

double calculateArea(List<(int, int)> coordinates) {
  var a = 0;
  var b = 0;
  for (var i = 0; i < coordinates.length - 1; i++) {
    a += coordinates[i].$1 * coordinates[i + 1].$2;
  }
  for (var i = 0; i < coordinates.length - 1; i++) {
    b += coordinates[i].$2 * coordinates[i + 1].$1;
  }
  return (a - b) / 2;
}
