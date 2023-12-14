import 'dart:io';

void main() async {
  final file = File('./inputs/14.txt');
  final lines = await file.readAsLines();
  slideRocks(lines);
  final result = computeLoad(lines);
  print(result);
}

const roundRock = 'O';

void slideRocks(List<String> lines) {
  for (var colIndex = 0; colIndex < lines.first.length; colIndex++) {
    var stack = 0;
    var stackStart = 0;
    for (var rowIndex = 0; rowIndex < lines.length; rowIndex++) {
      final char = lines[rowIndex][colIndex];
      if (char == roundRock) {
        if (stackStart == rowIndex) {
          stackStart = rowIndex + 1;
        } else {
          stack++;
        }
      } else if (char == '#') {
        slideStack(lines, stack, stackStart, rowIndex, colIndex);
        stack = 0;
        stackStart = rowIndex + 1;
      }
    }
    slideStack(lines, stack, stackStart, lines.length, colIndex);
  }
}

void slideStack(
    List<String> lines, int stack, int stackStart, int stackEnd, int colIndex) {
  if (stack == 0) return;
  for (var i = stackStart; i < stackStart + stack; i++) {
    final line = lines[i].split('');
    line[colIndex] = roundRock;
    lines[i] = line.join('');
  }
  for (var i = stackStart + stack; i < stackEnd; i++) {
    final line = lines[i].split('');
    line[colIndex] = '.';
    lines[i] = line.join('');
  }
}

int computeLoad(List<String> lines) {
  var result = 0;
  for (var i = 0; i < lines.length; i++) {
    final lineScore = lines.length - i;
    final rocks = lines[i] //
        .split('')
        .fold(0, (acc, char) => char == roundRock ? acc + 1 : acc);
    result += rocks * lineScore;
  }
  return result;
}
