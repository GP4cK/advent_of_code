import 'dart:io';

void main() async {
  final file = File('./inputs/14.txt');
  var lines = await file.readAsLines();
  for (var i = 0; i < 100; i++) {
    for (var j = 0; j < 4; j++) {
      slideRocks(lines);
      lines = rotate(lines);
    }
  }
  final results = <int>[];
  const iteration = (1000000000 - 100) % 38;
  for (var i = 0; i < iteration; i++) {
    for (var j = 0; j < 4; j++) {
      slideRocks(lines);
      lines = rotate(lines);
    }
    results.add(computeLoad(lines));
    lookForCycle(results);
  }
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

List<String> rotate(List<String> lines) {
  final result = <String>[];
  for (var i = 0; i < lines.first.length; i++) {
    var newLine = '';
    for (var j = lines.length - 1; j >= 0; j--) {
      newLine += lines[j][i];
    }
    result.add(newLine);
  }
  return result;
}

void lookForCycle(List<int> results) {
  if (results.length < 5) return;
  final firstIndex = results.indexOf(results.last);
  if (results.length - firstIndex < 3) return;
  final secondIndex = (results.length - firstIndex) ~/ 2 + firstIndex;
  if (results[secondIndex] != results[firstIndex]) return;
  var cycle = true;
  final length = secondIndex - firstIndex;
  for (var i = 1; i < length; i++) {
    if (results[firstIndex + i] != results[secondIndex + i]) {
      cycle = false;
      break;
    }
  }
  if (cycle) {
    print('Cycle detected at $firstIndex of length $length');
  } else {
    print('No cycle detected');
  }
}
