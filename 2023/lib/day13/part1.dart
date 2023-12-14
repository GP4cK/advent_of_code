import 'dart:io';

void main() async {
  final file = File('./inputs/13.txt');
  final lines = await file.readAsLines();
  final patterns = getPatterns(lines);
  var result = 0;
  for (final pattern in patterns) {
    final value = findMirror(pattern);
    result += value;
  }
  print(result);
}

List<List<String>> getPatterns(List<String> lines) {
  final patterns = <List<String>>[];
  var start = 0;
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].isEmpty) {
      patterns.add(lines.sublist(start, i));
      start = i + 1;
    }
  }
  patterns.add(lines.sublist(start));
  return patterns;
}

int findMirror(List<String> pattern) {
  var value = lookForVerticalMirrors(pattern);
  if (value != null) return value;
  final inverted = invert(pattern);
  value = lookForVerticalMirrors(inverted);
  return value! * 100;
}

int? lookForVerticalMirrors(List<String> lines) {
  final candidates = <int>{};
  for (var i = 0; i < lines.first.length - 1; i++) {
    candidates.add(i);
  }

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    testMirror(line, candidates);
    if (candidates.isEmpty) return null;
  }
  if (candidates.length > 1) {
    throw Exception('More than one candidate');
  }
  return candidates.first + 1;
}

void testMirror(String line, Set<int> candidates) {
  final toRemove = <int>{};
  for (final candidate in candidates) {
    var isPossible = true;
    for (var i = 0;
        candidate - i >= 0 && candidate + i + 1 < line.length && isPossible;
        i++) {
      if (line[candidate - i] != line[candidate + i + 1]) isPossible = false;
    }
    if (!isPossible) toRemove.add(candidate);
  }
  candidates.removeAll(toRemove);
}

List<String> invert(List<String> lines) {
  final result = <String>[];
  for (var i = 0; i < lines.first.length; i++) {
    var newLine = '';
    for (var j = 0; j < lines.length; j++) {
      newLine += lines[j][i];
    }
    result.add(newLine);
  }
  return result;
}
