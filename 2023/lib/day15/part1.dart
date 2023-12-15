import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('./inputs/15.txt');
  final lines = await file.readAsLines();
  final instructions = lines.first.split(',');
  var value = 0;
  for (final instruction in instructions) {
    value += hash(instruction);
  }
  print(value);
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
