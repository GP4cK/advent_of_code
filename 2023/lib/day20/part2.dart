import 'dart:io';

const broadcaster = 'broadcaster';
const dr = 'dr';
var presses = 0;

void main() async {
  final file = File('./inputs/20.txt');
  final lines = await file.readAsLines();
  final map = <String, Module>{};
  for (final line in lines) {
    final [name, modules] = line.split(' -> ');
    final outputs = modules.split(', ').toSet();
    final module = switch (name) {
      '&$dr' => Dr(outputs),
      final String flipflop when flipflop.startsWith('%') => FlipFlop(outputs),
      final String conj when conj.startsWith('&') => Conjunction(outputs),
      broadcaster => Broadcaster(outputs),
      _ => throw Exception('Unknown module: $name'),
    };
    map[name.replaceFirst(RegExp('%|&'), '')] = module;
  }

  setInputsOfConjunctions(map);

  final commands = <Command>[];
  while (presses < 10000) {
    if (presses % 1000 == 0) print(presses);
    commands.add(Command(Pulse.low, from: 'button', to: broadcaster));
    presses++;
    while (commands.isNotEmpty) {
      final command = commands.removeAt(0);
      final module = map[command.to];
      if (module == null) continue;
      commands.addAll(module.processCommand(command));
    }
  }
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
    if (command.pulse == Pulse.high) return const [];
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

class Dr extends Conjunction {
  Dr(super.outputs);

  @override
  Iterable<Command> processCommand(Command command) {
    if (command.pulse == Pulse.high) {
      print('$presses: got ${command.pulse} from ${command.from}');
    }
    return super.processCommand(command);
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
