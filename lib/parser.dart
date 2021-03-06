import 'package:enum_to_string/enum_to_string.dart';
import 'package:gota/syntax.dart';
import 'package:petitparser/petitparser.dart';

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
    final commandArg =
        item.plusLazy(endOfInput() | preposition).flatten().trim();

    // add object name, optional 'with' , requires optional target
    _commandLine.set(commands.trim() &
        commandArg &
        (endOfInput() | (preposition.trim() & item.plus().flatten())));
  }

  Result<dynamic> parse(String toParse) => _commandLine.parse(toParse);
}
