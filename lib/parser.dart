import 'package:enum_to_string/enum_to_string.dart';
import 'package:petitparser/petitparser.dart';

enum Command { USE, OPEN, CLOSE, LOCK, UNLOCK, EXAMINE }
enum Preposition { WITH, ON }

class CommandParser {
  final _commandLine = undefined();

  static ChoiceParser buildEnumChoiceParser(var values) {
    List<Parser> parsers = [];
    for (var e in values) {
      parsers.add(stringIgnoreCase(EnumToString.parse(e)).map((value) => e));
    }
    return ChoiceParser(parsers);
  }

  CommandParser() {
    // add commands to commandParser
    ChoiceParser commands = buildEnumChoiceParser(Command.values);
    ChoiceParser preposition = buildEnumChoiceParser(Preposition.values);
    // define the syntax for an item word
    final item = word().plus().trim().flatten();
    // define syntax for prepositions

    // Greedy first part of the command line
    final commandArg = item.plusLazy(endOfInput() | preposition).flatten();

    // add object name, optional 'with' , requires optional target
    _commandLine.set(commands &
        commandArg &
        (endOfInput() | (preposition & item.plus().flatten())));
  }

  Result<dynamic> parse(String toParse) => _commandLine.parse(toParse);
}
