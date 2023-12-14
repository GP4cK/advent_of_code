import 'dart:io';

void main() async {
  final file = File('./inputs/06.txt');
  final lines = await file.readAsLines();
  final time =
      int.parse(lines[0].replaceAll(' ', '').substring('Time:'.length));
  final distance =
      int.parse(lines[1].replaceAll(' ', '').substring('Distance:'.length));

  var nbOfWaysToBeat = 0;
  for (var i = 1; i < time; i++) {
    final myDistance = getDistance(i, time);
    if (myDistance > distance) {
      nbOfWaysToBeat++;
    }
  }

  print(nbOfWaysToBeat);
}

int getDistance(int pressingTime, int totalTime) {
  final movingTime = totalTime - pressingTime;
  final speed = pressingTime;
  return speed * movingTime;
}
