import 'package:enum_to_string/enum_to_string.dart';
import 'package:petitparser/petitparser.dart';

enum Command { USE, OPEN, CLOSE, LOCK, UNLOCK, EXAMINE }

class CommandParser {
  final _commandLine = undefined();

  CommandParser() {
    List<Parser> commandsList = [];
    // add commands to commandParser
    for (var c in Command.values) {
      commandsList.add(stringIgnoreCase(EnumToString.parse(c)));
    }

    ChoiceParser commands = ChoiceParser(commandsList);
    final item = word().plus().trim().flatten();
    final preposition = stringIgnoreCase('with').map((value) {
      print('preposition found $value');
      return value;
    });
    final commandArg = undefined();

    commandArg.set(item.plusLazy(endOfInput() | preposition));

    // add object name, optional 'with', optional target
    _commandLine.set(commands &
        commandArg.flatten() &
        preposition.optional() &
        item.star().flatten());
  }

  Result<dynamic> parse(String toParse) => _commandLine.parse(toParse);
}
