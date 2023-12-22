import 'dart:io';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

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
  final result = countChainReaction(fallen);
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

class BrickWithID extends Brick with EquatableMixin {
  final int id;
  final Set<BrickWithID> parents;
  final Set<BrickWithID> children = {};

  BrickWithID.fromBrick(this.id, this.parents, Brick brick)
      : super(brick.start, brick.end);

  @override
  List<Object?> get props => [id];
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

List<BrickWithID> fall(List<Brick> bricks) {
  final fallenPile = <BrickWithID>[];
  var id = 0;
  for (final brick in bricks) {
    var maxZ = 0;
    final parents = <BrickWithID>{};
    for (var i = fallenPile.length - 1; i >= 0; i--) {
      final fallenBrick = fallenPile[i];
      if (fallenBrick.isUnder(brick) && fallenBrick.end.$3 >= maxZ) {
        maxZ = fallenBrick.end.$3;
        addToParents(fallenBrick, parents);
      }
    }
    final newBrick = BrickWithID.fromBrick(
      id++,
      parents,
      brick.fallTo(maxZ + 1),
    );
    for (var parent in parents) {
      parent.children.add(newBrick);
    }
    fallenPile.add(newBrick);
  }
  return fallenPile;
}

void addToParents(BrickWithID brick, Set<BrickWithID> parents) {
  parents.removeWhere((parent) => parent.end.$3 < brick.end.$3);
  parents.add(brick);
}

int countChainReaction(List<BrickWithID> bricks) {
  var count = 0;
  for (final brick in bricks) {
    final disintegratedIDs = {brick.id};
    final toTest = {...brick.children};
    while (toTest.isNotEmpty) {
      final brick = toTest.first;
      toTest.remove(brick);
      if (brick.parents
          .every((parent) => disintegratedIDs.contains(parent.id))) {
        disintegratedIDs.add(brick.id);
        toTest.addAll(brick.children);
      }
    }
    count += disintegratedIDs.length - 1;
  }
  return count;
}
