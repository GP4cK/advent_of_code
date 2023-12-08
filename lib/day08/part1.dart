import 'dart:io';

void main() async {
  final file = File('./inputs/08.txt');
  final lines = await file.readAsLines();
  final instructions = lines[0];

  final map = <String, ({String left, String right})>{};
  for (var i = 2; i < lines.length; i++) {
    final line = lines[i];
    final parts = line.split(' = ');
    final [left, right] =
        parts[1].substring(1, parts[1].length - 1).split(', ');
    map[parts[0]] = (left: left, right: right);
  }

  var steps = 0;
  var index = 0;
  var position = 'AAA';
  while (position != 'ZZZ') {
    final choices = map[position]!;
    final instruction = instructions[index];
    if (instruction == 'L') {
      position = choices.left;
    } else {
      position = choices.right;
    }
    index++;
    if (index == instructions.length) {
      index = 0;
      steps += instructions.length;
    }
  }

  print(steps + index);
}
