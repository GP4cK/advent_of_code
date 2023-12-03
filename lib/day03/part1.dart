import 'dart:io';

void main() async {
  final file = File('./inputs/03.txt');
  final lines = await file.readAsLines();
  final List<List<int>> symbolIndices = [];
  final List<List<(int, int)>> nbIndices = [];
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final List<int> lineSymbolIndices = [];
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
        if (char != '.') {
          lineSymbolIndices.add(j);
        }
      }
    }
    if (nbStart != -1) {
      lineNbIndices.add((nbStart, line.length - 1));
    }
    symbolIndices.add(lineSymbolIndices);
    nbIndices.add(lineNbIndices);
  }

  var result = 0;
  for (var i = 0; i < nbIndices.length; i++) {
    final lineNbIndices = nbIndices[i];
    for (var j = 0; j < lineNbIndices.length; j++) {
      final (start, end) = lineNbIndices[j];
      final symbolIndicesSameLine = symbolIndices[i];
      if (symbolIndicesSameLine.contains(start - 1) ||
          symbolIndicesSameLine.contains(end + 1)) {
        result += int.parse(lines[i].substring(start, end + 1));
      }
      if (i > 0) {
        final symbolIndicesPrevLine = symbolIndices[i - 1];
        if (hasConnectedSymbol(symbolIndicesPrevLine, start, end)) {
          result += int.parse(lines[i].substring(start, end + 1));
        }
      }
      if (i < nbIndices.length - 1) {
        final symbolIndicesNextLine = symbolIndices[i + 1];
        if (hasConnectedSymbol(symbolIndicesNextLine, start, end)) {
          result += int.parse(lines[i].substring(start, end + 1));
        }
      }
    }
  }

  print(result);
}

bool hasConnectedSymbol(List<int> symbolIndices, int start, int end) {
  for (var i = 0; i < symbolIndices.length; i++) {
    final symbolIndex = symbolIndices[i];
    if (symbolIndex < start - 1) continue;
    if (symbolIndex > end + 1) return false;
    return true;
  }
  return false;
}
