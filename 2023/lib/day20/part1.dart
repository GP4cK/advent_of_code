import 'dart:io';

const broadcaster = 'broadcaster';

void main() async {
  final file = File('./inputs/20.txt');
  final lines = await file.readAsLines();
  final map = <String, Module>{};
  for (final line in lines) {
    final [name, modules] = line.split(' -> ');
    final outputs = modules.split(', ').toSet();
    final module = switch (name) {
      final String flipflop when flipflop.startsWith('%') => FlipFlop(outputs),
      final String conj when conj.startsWith('&') => Conjunction(outputs),
      broadcaster => Broadcaster(outputs),
      _ => throw Exception('Unknown module: $name'),
    };
    map[name.replaceFirst(RegExp('%|&'), '')] = module;
  }

  setInputsOfConjunctions(map);

  final commands = <Command>[];
  var totalLows = 0;
  var totalHighs = 0;
  for (var i = 0; i < 1000; i++) {
    commands.add(Command(Pulse.low, from: 'button', to: broadcaster));
    var lows = 0;
    var highs = 0;
    while (commands.isNotEmpty) {
      final command = commands.removeAt(0);
      if (command.pulse == Pulse.low) {
        lows++;
      } else {
        highs++;
      }

      final module = map[command.to];
      if (module == null) continue;
      commands.addAll(module.processCommand(command));
    }
    // print('Lows: $lows, Highs: $highs');
    totalLows += lows;
    totalHighs += highs;
  }
  print('Lows: $totalLows, Highs: $totalHighs');
  print(totalLows * totalHighs);
}

abstract class Module {
  final Set<String> outputs;

  const Module(this.outputs);

  Iterable<Command> processCommand(Command command);
}

class Broadcaster extends Module {
  const Broadcaster(super.outputs);

  @override
  Iterable<Command> processCommand(Command command) => outputs
      .map((output) => Command(command.pulse, from: command.to, to: output));
}

class FlipFlop extends Module {
  FlipFlop(super.outputs);

  bool isOn = false;

  @override
  Iterable<Command> processCommand(Command command) {
    if (command.pulse == Pulse.high) return [];
    isOn = !isOn;
    final pulseToSend = isOn ? Pulse.high : Pulse.low;
    return outputs
        .map((output) => Command(pulseToSend, from: command.to, to: output));
  }
}

class Conjunction extends Module {
  Conjunction(super.outputs);
  late final Map<String, Pulse> inputs;

  void setInputs(Set<String> inputs) {
    this.inputs = {};
    for (final input in inputs) {
      this.inputs[input] = Pulse.low;
    }
  }

  @override
  Iterable<Command> processCommand(Command command) {
    inputs[command.from] = command.pulse;
    final pulseToSend = inputs.values.every((pulse) => pulse == Pulse.high)
        ? Pulse.low
        : Pulse.high;
    return outputs
        .map((output) => Command(pulseToSend, from: command.to, to: output));
  }
}

enum Pulse {
  high,
  low,
}

class Command {
  final Pulse pulse;
  final String to;
  final String from;

  const Command(this.pulse, {required this.from, required this.to});
}

void setInputsOfConjunctions(Map<String, Module> map) {
  for (final entry in map.entries) {
    if (entry.value case final Conjunction conjunction) {
      final inputs = map.keys.where((key) {
        final module = map[key]!;
        return module.outputs.contains(entry.key);
      }).toSet();
      conjunction.setInputs(inputs);
    }
  }
}
