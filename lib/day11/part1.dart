import 'dart:io';

void main() async {
  final file = File('./inputs/11.txt');
  final lines =
      (await file.readAsLines()).map((line) => line.split('')).toList();
  expandSpace(lines);
  final galaxies = getGalaxies(lines);
  final result = getShortestLength(galaxies);
  print(result);
}

void expandSpace(List<List<String>> lines) {
  final indicesOfEmptyRows = [];
  final indicesOfEmptyColumns = [];
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.every((char) => char == '.')) {
      indicesOfEmptyRows.add(i);
    }
  }
  for (var i = 0; i < lines.first.length; i++) {
    if (lines.map((line) => line[i]).every((char) => char == '.')) {
      indicesOfEmptyColumns.add(i);
    }
  }

  for (var i = indicesOfEmptyRows.length - 1; i >= 0; i--) {
    final index = indicesOfEmptyRows[i];
    lines.insert(index, List.filled(lines.first.length, '.', growable: true));
  }

  for (var i = indicesOfEmptyColumns.length - 1; i >= 0; i--) {
    final index = indicesOfEmptyColumns[i];
    for (final line in lines) {
      line.insert(index, '.');
    }
  }
}

List<({int x, int y})> getGalaxies(List<List<String>> lines) {
  final galaxies = <({int x, int y})>[];
  for (var i = 0; i < lines.length; i++) {
    for (var j = 0; j < lines[i].length; j++) {
      if (lines[i][j] == '#') galaxies.add((x: j, y: i));
    }
  }
  return galaxies;
}

int getShortestLength(List<({int x, int y})> galaxies) {
  var result = 0;
  for (var i = 0; i < galaxies.length - 1; i++) {
    final start = galaxies[i];
    for (var j = i + 1; j < galaxies.length; j++) {
      final end = galaxies[j];
      final distance = (end.x - start.x).abs() + end.y - start.y;
      result += distance;
    }
  }
  return result;
}
