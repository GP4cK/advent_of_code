import 'dart:io';

void main() async {
  final file = File('./inputs/06.txt');
  final lines = await file.readAsLines();
  final times = lines[0]
      .replaceAll(RegExp('\\s+'), ' ')
      .substring('Time: '.length)
      .split(' ')
      .map(int.parse)
      .toList();
  final distances = lines[1]
      .replaceAll(RegExp('\\s+'), ' ')
      .substring('Distance: '.length)
      .split(' ')
      .map(int.parse)
      .toList();

  final nbOfWaysToBeat = <int>[];
  for (var i = 0; i < times.length; i++) {
    final time = times[i];
    final distance = distances[i];
    nbOfWaysToBeat.add(0);
    for (var j = 1; j < time; j++) {
      final myDistance = getDistance(j, time);
      if (myDistance > distance) {
        nbOfWaysToBeat[i]++;
      }
    }
  }

  print(nbOfWaysToBeat.fold<int>(1, (acc, value) => acc * value));
}

int getDistance(int pressingTime, int totalTime) {
  final movingTime = totalTime - pressingTime;
  final speed = pressingTime;
  return speed * movingTime;
}
