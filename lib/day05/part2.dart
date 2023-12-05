import 'dart:io';

void main() async {
  final file = File('./inputs/05.txt');
  final lines = await file.readAsLines();
  final numbers =
      lines[0].substring('seeds: '.length).split(' ').map(int.parse).toList();
  final seedRanges = <(int start, int range)>[];
  for (var i = 0; i < numbers.length; i += 2) {
    seedRanges.add((numbers[i], numbers[i + 1]));
  }
  final maps = getMaps(lines.sublist(2));
  var minLocation = double.infinity;
  for (var (start, range) in seedRanges) {
    print('start: $start, range: $range');
    for (var seed = start; seed < start + range; seed++) {
      final result = getLocation(maps, seed).toDouble();
      if (result < minLocation) {
        minLocation = result;
      }
    }
  }
  print(minLocation.toInt());
}

class Range {
  final int dstStart;
  final int srcStart;
  final int range;

  const Range({
    required this.dstStart,
    required this.srcStart,
    required this.range,
  });
}

class RangeMap {
  final String title;
  final List<Range> ranges = [];

  RangeMap(this.title);
}

List<RangeMap> getMaps(List<String> lines) {
  final maps = <RangeMap>[];
  RangeMap? map;
  for (var line in lines) {
    if (line.isEmpty) {
      continue;
    } else if (int.tryParse(line[0]) != null) {
      final [dst, src, range] = line.split(' ');
      map!.ranges.add(
        Range(
          dstStart: int.parse(dst),
          srcStart: int.parse(src),
          range: int.parse(range),
        ),
      );
    } else {
      final title = line.split(' ')[0];
      map = RangeMap(title);
      maps.add(map);
    }
  }
  return maps;
}

int getLocation(List<RangeMap> maps, int seed) {
  var result = seed;
  for (var map in maps) {
    for (var range in map.ranges) {
      if (range.srcStart <= result && result < range.srcStart + range.range) {
        result = range.dstStart + (result - range.srcStart);
        break;
      }
    }
  }
  return result;
}
