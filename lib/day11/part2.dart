import 'dart:io';
import 'dart:math';

void main() async {
  final file = File('./inputs/11.txt');
  final lines =
      (await file.readAsLines()).map((line) => line.split('')).toList();
  final [emptyRows, emptyCols] = expandSpace(lines);
  final galaxies = getGalaxies(lines);
  final result = getShortestLength(galaxies, emptyRows, emptyCols);
  print(result);
}

List<List<int>> expandSpace(List<List<String>> lines) {
  final indicesOfEmptyRows = <int>[];
  final indicesOfEmptyColumns = <int>[];
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

  return [indicesOfEmptyRows, indicesOfEmptyColumns];
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

const amplifier = 999999;

int getShortestLength(
    List<({int x, int y})> galaxies, List<int> emptyRows, List<int> emptyCols) {
  var result = 0;
  for (var i = 0; i < galaxies.length - 1; i++) {
    final start = galaxies[i];
    for (var j = i + 1; j < galaxies.length; j++) {
      final end = galaxies[j];
      final minX = min(start.x, end.x);
      final maxX = max(start.x, end.x);
      final x = emptyCols.where((index) => minX < index && index < maxX).length;
      final y =
          emptyRows.where((index) => start.y < index && index < end.y).length;
      final distance = (end.x - start.x).abs() +
          end.y -
          start.y +
          x * amplifier +
          y * amplifier;
      result += distance;
    }
  }
  return result;
}
