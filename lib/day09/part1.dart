import 'dart:io';

void main() async {
  final file = File('./inputs/09.txt');
  final lines = await file.readAsLines();
  final values = <int>[];
  for (final line in lines) {
    final subLines = [
      line.split(' ').map((value) => int.parse(value)).toList()
    ];
    var allZero = false;
    while (!allZero) {
      final newLine = <int>[];
      final lastLine = subLines.last;
      for (var i = 0; i < lastLine.length - 1; i++) {
        newLine.add(lastLine[i + 1] - lastLine[i]);
      }
      subLines.add(newLine);
      allZero = newLine.every((value) => value == 0);
    }
    var value = 0;
    for (var i = subLines.length - 1; i >= 0; i--) {
      value += subLines[i].last;
    }
    values.add(value);
  }
  print(values.fold<int>(0, (acc, value) => acc + value));
}
