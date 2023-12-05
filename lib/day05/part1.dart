import 'dart:io';

void main() async {
  final file = File('./inputs/05.txt');
  final lines = await file.readAsLines();
  final seeds = lines[0].substring('seeds: '.length).split(' ');
  final maps = getMaps(lines.sublist(2));
  var minLocation = double.infinity;
  for (var seed in seeds) {
    final result = getLocation(maps, int.parse(seed)).toDouble();
    if (result < minLocation) {
      minLocation = result;
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
  print('seed: $seed');
  var result = seed;
  for (var map in maps) {
    print('\t${map.title}');
    for (var range in map.ranges) {
      if (range.srcStart <= result && result < range.srcStart + range.range) {
        result = range.dstStart + (result - range.srcStart);
        break;
      }
    }
    print('\t$result');
  }
  return result;
}
