import 'package:petitparser/petitparser.dart';

enum Command { USE }

class CommandParser {
  final id = letter() & (letter() | digit()).star();
  //final command;
}
