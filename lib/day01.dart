import 'dart:io';

const digits = {
  'one': 1,
  'two': 2,
  'three': 3,
  'four': 4,
  'five': 5,
  'six': 6,
  'seven': 7,
  'eight': 8,
  'nine': 9,
};

int? startWithDigit(String str) {
  for (final key in digits.keys) {
    if (str.startsWith(key)) {
      return digits[key];
    }
  }
  return null;
}

void main() async {
  final file = File('./inputs/01.txt');
  final lines = await file.readAsLines();
  final result = lines.fold(0, (previousValue, line) {
    late int firstDigit;
    for (var i = 0; i < line.length; i++) {
      final char = line[i];
      var digit = int.tryParse(char);
      if (digit != null) {
        firstDigit = digit;
        break;
      }
      digit = startWithDigit(line.substring(i));
      if (digit != null) {
        firstDigit = digit;
        break;
      }
    }
    late int lastDigit;
    for (var i = line.length - 1; i >= 0; i--) {
      final char = line[i];
      var digit = int.tryParse(char);
      if (digit != null) {
        lastDigit = digit;
        break;
      }
      digit = startWithDigit(line.substring(i));
      if (digit != null) {
        lastDigit = digit;
        break;
      }
    }
    final number = int.parse('$firstDigit$lastDigit');
    return previousValue + number;
  });
  print(result);
}
