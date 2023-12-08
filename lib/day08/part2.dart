import 'dart:io';
import 'dart:math';

// Using LCM shouldn't be the correct way but it works for the input.
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

  final startingPoints = map.keys.where((key) => key.endsWith('A'));
  final moves = <num>[];
  for (final startingPoint in startingPoints) {
    var steps = 0;
    var index = 0;
    var position = startingPoint;
    while (!position.endsWith('Z')) {
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
    moves.add(steps + index);
  }

  print(calculateLCM(moves));
}

num calculateLCM(List<num> numbers) {
  num lcm = 1;

  // Combine prime factors of all numbers
  Map<num, num> allFactors = {};
  for (num number in numbers) {
    Map<num, num> factors = primeFactors(number);
    factors.forEach((factor, power) {
      allFactors[factor] = allFactors.containsKey(factor)
          ? allFactors[factor] =
              allFactors[factor]! > power ? allFactors[factor]! : power
          : power;
    });
  }

  // Calculate LCM from combined prime factors
  allFactors.forEach((factor, power) {
    lcm *= pow(factor, power);
  });

  return lcm;
}

Map<num, num> primeFactors(num num) {
  Map<int, int> factors = {};
  var divisor = 2;

  while (num > 1) {
    if (num % divisor == 0) {
      factors[divisor] = (factors[divisor] ?? 0) + 1;
      num ~/= divisor;
    } else {
      divisor++;
    }
  }

  return factors;
}
