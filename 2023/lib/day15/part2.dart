import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('./inputs/15.txt');
  final lines = await file.readAsLines();
  final instructions = lines.first.split(',');

  final boxes = <int, List<Lens>>{};
  for (var i = 0; i < 256; i++) {
    boxes[i] = [];
  }

  for (final instruction in instructions) {
    if (instruction.endsWith('-')) {
      final label = instruction.substring(0, instruction.length - 1);
      final box = boxes[hash(label)]!;
      box.removeWhere((lens) => lens.label == label);
    } else {
      final [label, focal] = instruction.split('=');
      final box = boxes[hash(label)]!;
      final index = box.indexWhere((lens) => lens.label == label);
      final newLens = Lens(label, int.parse(focal));
      if (index > -1) {
        box.replaceRange(index, index + 1, [newLens]);
      } else {
        box.add(newLens);
      }
    }
  }
  final result = computeFocusingPower(boxes);
  print(result);
}

int hash(String str) {
  var hash = 0;
  for (var i = 0; i < str.length; i++) {
    hash += ascii.encode(str[i]).first;
    hash *= 17;
    hash = hash % 256;
  }
  return hash;
}

class Lens {
  final String label;
  final int focal;

  const Lens(this.label, this.focal);
}

int computeFocusingPower(Map<int, List<Lens>> boxes) {
  var power = 0;
  for (final entry in boxes.entries) {
    for (var i = 0; i < entry.value.length; i++) {
      final lens = entry.value[i];
      final lensPower = (1 + entry.key) * (i + 1) * lens.focal;
      power += lensPower;
    }
  }
  return power;
}
