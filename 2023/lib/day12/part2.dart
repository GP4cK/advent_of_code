import 'dart:io';

void main() async {
  final file = File('./inputs/12.txt');
  final lines = await file.readAsLines();
  var result = 0;
  for (final line in lines) {
    final parts = line.split(' ');
    final springs = List.filled(5, parts.first).join('?');
    final groups = List.filled(5, parts.last)
        .join(',')
        .split(',')
        .map((value) => int.parse(value))
        .toList();
    final cache = <String, int>{};
    final combinations = getCombinations(springs, groups, cache, 0, 0);
    result += combinations;
  }
  print(result);
}

int getCombinations(
  String springs,
  List<int> groups,
  Map<String, int> cache,
  int springIndex,
  int groupIndex,
) {
  if (springIndex >= springs.length) {
    if (groupIndex < groups.length) {
      return 0;
    }
    return 1;
  }

  final key = '$springIndex,$groupIndex';
  final cachedValue = cache[key];
  if (cachedValue != null) return cachedValue;

  int res = 0;
  final spring = springs[springIndex];
  if (spring == '.') {
    res = getCombinations(springs, groups, cache, springIndex + 1, groupIndex);
  } else {
    if (spring == '?') {
      res =
          getCombinations(springs, groups, cache, springIndex + 1, groupIndex);
    }
    if (groupIndex < groups.length) {
      final end = springIndex + groups[groupIndex];
      if (end <= springs.length) {
        final next = springs.substring(springIndex, end).split('');
        if (next.every((char) => char != '.') &&
            (end >= springs.length || springs[end] != '#')) {
          res += getCombinations(
            springs,
            groups,
            cache,
            end + 1,
            groupIndex + 1,
          );
        }
      }
    }
  }
  cache[key] = res;
  return res;
}
