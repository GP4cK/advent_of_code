import 'dart:io';

void main() async {
  final file = File('./inputs/sample03.txt');
  final lines = await file.readAsLines();
  final List<List<int>> gearIndices = [];
  final List<List<(int, int)>> nbIndices = [];
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final List<int> lineGearIndices = [];
    final List<(int, int)> lineNbIndices = [];
    var nbStart = -1;
    for (var j = 0; j < line.length; j++) {
      final char = line[j];
      final nb = int.tryParse(char);
      if (nb != null) {
        if (nbStart == -1) {
          nbStart = j;
        } else {
          continue;
        }
      } else {
        if (nbStart != -1) {
          lineNbIndices.add((nbStart, j - 1));
          nbStart = -1;
        }
        if (char == '*') {
          lineGearIndices.add(j);
        }
      }
    }
    if (nbStart != -1) {
      lineNbIndices.add((nbStart, line.length - 1));
    }
    gearIndices.add(lineGearIndices);
    nbIndices.add(lineNbIndices);
  }

  var result = 0;
  for (var i = 0; i < gearIndices.length; i++) {
    final lineGearIndices = gearIndices[i];
    for (var j = 0; j < lineGearIndices.length; j++) {
      final gearIndex = lineGearIndices[j];
      final connectedNumbers = <int>[];
      final nbIndicesSameLine = nbIndices[i];
      for (final (start, end) in nbIndicesSameLine) {
        if (end == gearIndex - 1) {
          connectedNumbers.add(int.parse(lines[i].substring(start, end + 1)));
        } else if (start == gearIndex + 1) {
          connectedNumbers.add(int.parse(lines[i].substring(start, end + 1)));
        }
      }

      if (i > 0) {
        final nbIndicesPrevLine = nbIndices[i - 1];
        addConnectedNumbers(
            connectedNumbers, nbIndicesPrevLine, gearIndex, lines[i - 1]);
      }
      if (i < nbIndices.length - 1) {
        final nbIndicesNextLine = nbIndices[i + 1];
        addConnectedNumbers(
            connectedNumbers, nbIndicesNextLine, gearIndex, lines[i + 1]);
      }

      if (connectedNumbers.length == 2) {
        result += connectedNumbers[0] * connectedNumbers[1];
      }
    }
  }

  print(result);
}

void addConnectedNumbers(List<int> connectedNumbers,
    List<(int, int)> nbIndicesPrevLine, int gearIndex, String line) {
  for (final (start, end) in nbIndicesPrevLine) {
    if (gearIndex - 1 <= end && end <= gearIndex + 1) {
      connectedNumbers.add(int.parse(line.substring(start, end + 1)));
    } else if (gearIndex - 1 <= start && start <= gearIndex + 1) {
      connectedNumbers.add(int.parse(line.substring(start, end + 1)));
    }
  }
}
