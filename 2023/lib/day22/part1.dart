import 'dart:io';

import 'package:collection/collection.dart';

// 1st submission 822 is too high
// 2nd submission 544 is too high after sorting by start.z
// 3rd submission 542 is too high after sorting by end.z
// Sorting by start.z and end.z gives 551
// The issue is that when implementing fall(), we shouldn't stop at the first brick that we find under.

void main() async {
  final file = File('./inputs/22.txt');
  final lines = await file.readAsLines();
  final bricks = getBricks(lines);
  bricks.sortByCompare<(int, int)>(
    (brick) => (brick.start.$3, brick.end.$3),
    (a, b) {
      if (a.$1 == b.$1) {
        return a.$2.compareTo(b.$2);
      }
      return a.$1.compareTo(b.$1);
    },
  );
  final fallen = fall(bricks);
  final result = countCanDisintegrate(fallen);
  print(result);
}

class Brick {
  final (int, int, int) start;
  final (int, int, int) end;
  Brick(this.start, this.end)
      : assert(start.$3 <= end.$3),
        assert(start.$1 <= end.$1),
        assert(start.$2 <= end.$2);

  Brick fallTo(int z) {
    final start = (this.start.$1, this.start.$2, z);
    final end = (this.end.$1, this.end.$2, this.end.$3 - this.start.$3 + z);
    return Brick(start, end);
  }

  bool isUnder(Brick other) {
    final thisIsAlongX = start.$2 == end.$2;
    final otherIsAlongX = other.start.$2 == other.end.$2;
    if (thisIsAlongX) {
      if (otherIsAlongX) {
        return start.$2 == other.start.$2 &&
            start.$1 <= other.end.$1 &&
            end.$1 >= other.start.$1;
      } else {
        // this is along X, other is along Y
        return start.$1 <= other.start.$1 &&
            other.start.$1 <= end.$1 &&
            other.start.$2 <= start.$2 &&
            start.$2 <= other.end.$2;
      }
    } else if (otherIsAlongX) {
      // this is along Y, other is along X
      return other.start.$1 <= start.$1 &&
          start.$1 <= other.end.$1 &&
          start.$2 <= other.start.$2 &&
          other.start.$2 <= end.$2;
    } else {
      // both are along Y
      return start.$1 == other.start.$1 &&
          start.$2 <= other.end.$2 &&
          end.$2 >= other.start.$2;
    }
  }
}

List<Brick> getBricks(List<String> lines) {
  final bricks = <Brick>[];
  for (final line in lines) {
    final [start, end] = line.split('~');
    final brick = Brick(parseCoordinates(start), parseCoordinates(end));
    bricks.add(brick);
  }
  return bricks;
}

(int, int, int) parseCoordinates(String coordinates) {
  final [x, y, z] = coordinates.split(',').map(int.parse).toList();
  return (x, y, z);
}

List<Brick> fall(List<Brick> bricks) {
  final fallenPile = <Brick>[];
  for (final brick in bricks) {
    var maxZ = 0;
    for (var i = fallenPile.length - 1; i >= 0; i--) {
      final fallenBrick = fallenPile[i];
      if (fallenBrick.isUnder(brick) && fallenBrick.end.$3 > maxZ) {
        maxZ = fallenBrick.end.$3;
      }
    }
    fallenPile.add(brick.fallTo(maxZ + 1));
  }
  return fallenPile;
}

int countCanDisintegrate(List<Brick> bricks) {
  var result = 0;
  for (var i = 0; i < bricks.length; i++) {
    final brick = bricks[i];
    final onTop = bricks
        .where((top) => top.start.$3 == brick.end.$3 + 1 && brick.isUnder(top));
    final sameLevel =
        bricks.where((same) => same.end.$3 == brick.end.$3).toList();

    if (onTop.every((brick) => hasMultiSupport(sameLevel, brick))) {
      result++;
    }
  }
  return result;
}

bool hasMultiSupport(List<Brick> bricks, Brick brick) {
  var count = 0;
  for (final other in bricks) {
    if (other.isUnder(brick)) {
      count++;
      if (count >= 2) {
        return true;
      }
    }
  }
  return false;
}
