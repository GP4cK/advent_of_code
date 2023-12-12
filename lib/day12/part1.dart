import 'dart:io';

void main() async {
  final file = File('./inputs/12.txt');
  final lines = await file.readAsLines();
  var result = 0;
  for (final line in lines) {
    final parts = line.split(' ');
    final springs = parts.first;
    final counts =
        parts.last.split(',').map((value) => int.parse(value)).toList();
    final combinations = getCombinations(springs, counts, null);
    result += combinations;
  }
  print(result);
}

int getCombinations(String springs, List<int> counts, bool? insideGroup) {
  assert(insideGroup == null || !insideGroup || counts.isNotEmpty);
  switch ((
    springsIsEmpty: springs.isEmpty,
    countsIsEmpty: counts.isEmpty,
    isInsideGroup: insideGroup
  )) {
    case (springsIsEmpty: true, countsIsEmpty: true, isInsideGroup: null):
    case (springsIsEmpty: true, countsIsEmpty: true, isInsideGroup: false):
      return 1;
    case (springsIsEmpty: true, countsIsEmpty: false, isInsideGroup: _):
    case (springsIsEmpty: _, countsIsEmpty: true, isInsideGroup: true):
      return 0;
    case (springsIsEmpty: false, countsIsEmpty: true, isInsideGroup: null):
    case (springsIsEmpty: false, countsIsEmpty: true, isInsideGroup: false):
      return springs.split('').any((spring) => spring == '#') ? 0 : 1;
    case (springsIsEmpty: false, countsIsEmpty: false, isInsideGroup: null):
      {
        switch (springs[0]) {
          case '#':
            if (counts[0] == 1) {
              return getCombinations(
                  springs.substring(1), counts.sublist(1), false);
            }
            counts[0]--;
            return getCombinations(
                springs.substring(1), counts.sublist(0), true);
          case '.':
            return getCombinations(
                springs.substring(1), counts.sublist(0), null);
          case '?':
            final ok =
                getCombinations(springs.substring(1), counts.sublist(0), null);
            final int ko;
            if (counts[0] == 1) {
              ko = getCombinations(
                  springs.substring(1), counts.sublist(1), false);
            } else {
              counts[0]--;
              ko = getCombinations(
                  springs.substring(1), counts.sublist(0), true);
            }
            return ok + ko;
          default:
            throw Exception('Invalid spring: ${springs[0]}');
        }
      }
    case (springsIsEmpty: false, countsIsEmpty: false, isInsideGroup: true):
      if (springs[0] == '.') return 0;
      if (counts.first == 1) {
        return getCombinations(springs.substring(1), counts.sublist(1), false);
      }
      counts[0]--;
      return getCombinations(springs.substring(1), counts.sublist(0), true);
    case (springsIsEmpty: false, countsIsEmpty: false, isInsideGroup: false):
      if (springs[0] == '#') return 0;
      return getCombinations(springs.substring(1), counts.sublist(0), null);
  }
}
