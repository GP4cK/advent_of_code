import 'dart:io';

import 'package:petitparser/petitparser.dart';

void main() async {
  final file = File('./inputs/19.txt');
  final lines = await file.readAsLines();
  final workflows = <String, String>{};
  final parts = <Part>[];
  var parsingWorkflow = true;
  for (final line in lines) {
    if (line.isEmpty) {
      parsingWorkflow = false;
    } else if (parsingWorkflow) {
      parseWorkflow(workflows, line);
    } else {
      parsePart(parts, line);
    }
  }
  var result = 0;
  for (final part in parts) {
    final accepted = isAccepted(workflows, part);
    if (accepted) {
      result += part.value;
    }
  }
  print(result);
}

class Result {
  final bool? done;
  final String? goTo;

  const Result({this.done, this.goTo});
}

class Part {
  final int x;
  final int m;
  final int a;
  final int s;

  const Part(this.x, this.m, this.a, this.s);
  int get value => x + m + a + s;
}

void parseWorkflow(Map<String, String> workflows, String line) {
  final [name, rest] = line.split('{');
  workflows[name] = rest.substring(0, rest.length - 1);
}

void parsePart(List<Part> parts, String line) {
  final list = line.substring(1, line.length - 1).split(',');
  var x = 0;
  var m = 0;
  var a = 0;
  var s = 0;
  for (final item in list) {
    final [key, value] = item.split('=');
    switch (key) {
      case 'x':
        x = int.parse(value);
      case 'm':
        m = int.parse(value);
      case 'a':
        a = int.parse(value);
      case 's':
        s = int.parse(value);
    }
  }

  parts.add(Part(x, m, a, s));
}

bool isAccepted(Map<String, String> workflows, Part part) {
  var workflow = workflows['in']!;
  final definition = ExpressionDefinition(part);
  final parser = definition.build();
  while (true) {
    final parsed = parser.parse(workflow);
    if (parsed is Failure) throw parsed;
    final result = (parsed as Success).value as Result;
    if (result.done != null) return result.done!;
    workflow = workflows[result.goTo!]!;
  }
}

class ExpressionDefinition extends GrammarDefinition {
  final Part part;

  ExpressionDefinition(this.part);

  @override
  Parser start() => ref0(term).end();

  Parser term() => exp().plusSeparated(char(',')).map((value) {
        return value.foldLeft((left, separator, right) {
          if (left is Result) return left;
          return right;
        });
      });
  Parser exp() => condition() | result();

  Parser accepted() => char('A').map((_) => Result(done: true));
  Parser rejected() => char('R').map((_) => Result(done: false));
  Parser workflowName() =>
      letter().plus().flatten().map((name) => Result(goTo: name));
  Parser result() => accepted() | rejected() | workflowName();

  Parser condition() =>
      ((more() | less()) & char(':') & result()).map((values) {
        if (values.first == true) return values.last;
      });
  Parser more() =>
      (attr() & char('>') & number()).map((value) => value.first > value.last);
  Parser less() =>
      (attr() & char('<') & number()).map((value) => value.first < value.last);

  Parser attr() => x() | m() | a() | s();
  Parser x() => char('x').map((_) => part.x);
  Parser m() => char('m').map((_) => part.m);
  Parser a() => char('a').map((_) => part.a);
  Parser s() => char('s').map((_) => part.s);

  Parser number() => digit().plus().flatten().map(int.parse);
}
