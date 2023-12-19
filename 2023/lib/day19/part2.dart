import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:petitparser/petitparser.dart';

void main() async {
  final file = File('./inputs/19.txt');
  final lines = await file.readAsLines();
  final workflows = <String, String>{};
  for (final line in lines) {
    if (line.isEmpty) break;
    parseWorkflow(workflows, line);
  }

  final ranges = getRanges(workflows);
  final result = ranges.fold<int>(0, (sum, range) => sum + range.possibilities);
  print(result);
}

abstract class Ranges extends Equatable {
  final (int, int) x;
  final (int, int) m;
  final (int, int) a;
  final (int, int) s;

  const Ranges({
    required this.x,
    required this.m,
    required this.a,
    required this.s,
  });

  int get possibilities =>
      (x.$2 - x.$1 + 1) *
      (m.$2 - m.$1 + 1) *
      (a.$2 - a.$1 + 1) *
      (s.$2 - s.$1 + 1);

  bool includes(Ranges range) {
    return (x.$1 <= range.x.$1 && x.$2 >= range.x.$2) &&
        (m.$1 <= range.m.$1 && m.$2 >= range.m.$2) &&
        (a.$1 <= range.a.$1 && a.$2 >= range.a.$2) &&
        (s.$1 <= range.s.$1 && s.$2 >= range.s.$2);
  }

  (int, int) operator [](rating) {
    switch (rating) {
      case 'x':
        return x;
      case 'm':
        return m;
      case 'a':
        return a;
      case 's':
        return s;
    }
    throw Exception('Invalid rating $rating');
  }
}

class AcceptedRange extends Ranges {
  const AcceptedRange({
    required (int, int) x,
    required (int, int) m,
    required (int, int) a,
    required (int, int) s,
  }) : super(x: x, m: m, a: a, s: s);

  @override
  List<Object?> get props => [x, m, a, s];
}

class IntermediateRange extends Ranges {
  final String workflowName;
  const IntermediateRange({
    required this.workflowName,
    required (int, int) x,
    required (int, int) m,
    required (int, int) a,
    required (int, int) s,
  }) : super(x: x, m: m, a: a, s: s);

  AcceptedRange toAcceptedRange() => AcceptedRange(x: x, m: m, a: a, s: s);

  IntermediateRange copyWith(String rating, (int, int) slice) {
    switch (rating) {
      case 'x':
        return IntermediateRange(
            workflowName: workflowName, x: slice, m: m, a: a, s: s);
      case 'm':
        return IntermediateRange(
            workflowName: workflowName, x: x, m: slice, a: a, s: s);
      case 'a':
        return IntermediateRange(
            workflowName: workflowName, x: x, m: m, a: slice, s: s);
      case 's':
        return IntermediateRange(
            workflowName: workflowName, x: x, m: m, a: a, s: slice);
    }
    throw Exception('Invalid rating $rating');
  }

  IntermediateRange goToWorkflow(String workflowName) {
    return IntermediateRange(
        workflowName: workflowName, x: x, m: m, a: a, s: s);
  }

  @override
  bool includes(Ranges range) {
    if (range is! IntermediateRange) return false;
    if (workflowName != range.workflowName) return false;
    return super.includes(range);
  }

  @override
  List<Object?> get props => [workflowName, x, m, a, s];
}

void parseWorkflow(Map<String, String> workflows, String line) {
  final [name, rest] = line.split('{');
  workflows[name] = rest.substring(0, rest.length - 1);
}

Set<Ranges> getRanges(Map<String, String> workflows) {
  final intermediateRanges = {
    IntermediateRange(
      workflowName: 'in',
      x: (1, 4000),
      m: (1, 4000),
      a: (1, 4000),
      s: (1, 4000),
    )
  };
  final acceptedRanges = <AcceptedRange>{};
  while (intermediateRanges.isNotEmpty) {
    final range = intermediateRanges.first;
    intermediateRanges.remove(range);
    var workflow = workflows[range.workflowName]!;
    final definition = ExpressionDefinition(range);
    final parser = definition.build();
    final parsed = parser.parse(workflow);
    if (parsed is Failure) throw parsed;
    final ranges = (parsed as Success).value;
    for (final range in ranges as Set) {
      if (range is AcceptedRange) {
        addToRanges(acceptedRanges, range);
      } else {
        intermediateRanges.add(range as IntermediateRange);
      }
    }
  }
  return acceptedRanges;
}

void addToRanges(Set<Ranges> ranges, Ranges range) {
  for (final existing in ranges) {
    if (existing.runtimeType != range.runtimeType) continue;
    if (existing.includes(range)) return;
    if (range.includes(existing)) {
      ranges.remove(existing);
      ranges.add(range);
      return;
    }
  }
  ranges.add(range);
}

class ExpressionDefinition extends GrammarDefinition {
  final IntermediateRange startRange;

  ExpressionDefinition(this.startRange);

  @override
  Parser start() => ref0(term).end();

  Parser term() => exp().plusSeparated(char(',')).map((value) {
        var currentRange = startRange;
        final ranges = <Ranges>{};

        for (final item in value.elements) {
          if (item == false) break;
          if (item == true) {
            addToRanges(ranges, currentRange.toAcceptedRange());
          } else if (item is String) {
            addToRanges(ranges, currentRange.goToWorkflow(item));
          } else {
            if (item is! Condition) throw Exception('Invalid item $item');
            if (item.result != false) {
              var slice = currentRange[item.rating];
              switch (item.gt) {
                case true:
                  slice = gt(slice, item.number);
                case false:
                  slice = lt(slice, item.number);
              }
              final passingRange = currentRange.copyWith(item.rating, slice);
              if (item.result == true) {
                addToRanges(ranges, passingRange.toAcceptedRange());
              } else {
                ranges.add(passingRange.goToWorkflow(item.result as String));
              }
            }
            var slice = currentRange[item.rating];
            switch (item.gt) {
              case true:
                slice = lt(slice, item.number + 1);
              case false:
                slice = gt(slice, item.number - 1);
            }
            currentRange = currentRange.copyWith(item.rating, slice);
          }
        }
        return ranges;
      });
  Parser exp() => condition() | result();

  Parser accepted() => char('A').map((_) => true);
  Parser rejected() => char('R').map((_) => false);
  Parser workflowName() => letter().plus().flatten();
  Parser result() => accepted() | rejected() | workflowName();

  Parser<Condition> condition() =>
      (attr() & char('>').or(char('<')) & number() & char(':') & result())
          .map((values) => Condition(
                rating: values.first,
                gt: values[1] == '>',
                number: values[2],
                result: values.last,
              ));

  Parser attr() => x() | m() | a() | s();
  Parser x() => char('x');
  Parser m() => char('m');
  Parser a() => char('a');
  Parser s() => char('s');

  Parser number() => digit().plus().flatten().map(int.parse);
}

typedef RestrictRange = IntermediateRange Function(IntermediateRange);

class Condition {
  final String rating;
  final bool gt;
  final int number;

  /// String or bool
  final dynamic result;

  const Condition({
    required this.rating,
    required this.gt,
    required this.number,
    required this.result,
  });
}

(int, int) gt((int, int) slice, int value) => (value + 1, slice.$2);
(int, int) lt((int, int) slice, int value) => (slice.$1, value - 1);
