import 'package:enum_to_string/enum_to_string.dart';

enum Command { USE, OPEN, CLOSE, LOCK, UNLOCK, EXAMINE }
enum Preposition { WITH, ON }

enum Direction { NORTH, EAST, SOUTH, WEST, UP, DOWN }

enum ItemProperty {
  NONE,
  LOCKABLE,
  TRANSPORTABLE,
  CONTAINER,
  OPENABLE,
  SWITCHABLE,
  PASSAGE,
  CONSUMABLE,
  USABLE,
  HIDEOUT,
  MOVABLE,
  NUM_PROPERTIES
}

enum ItemStatus {
  LOCKED,
  OPENED,
  SWITCHED,
  CONSUMED,
  USED,
  VISIBLE,
  NUM_STATUSES
}

List<String> enumToStringList(List<dynamic> values) {
  return values.map((e) => EnumToString.parse(e)).toList();
}

List<String> getSyntaxSuggestions() {
  return enumToStringList(Command.values) +
      enumToStringList(Preposition.values) +
      enumToStringList(Direction.values);
}
