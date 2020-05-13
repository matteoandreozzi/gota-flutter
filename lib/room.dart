import 'package:enum_to_string/enum_to_string.dart';

import 'item.dart';

enum Direction { NORTH, EAST, SOUTH, WEST, UP, DOWN }

class Room {
  int _id;
  String _title, _description;
  Map<Direction, int> _doors = Map();
  Map<String, Item> _items = Map();

  String getTitle() => _title;
  String getDescription() => _description;
  int getDoor(Direction dir) => _doors[dir];

  Room(this._id, this._title, this._description);
  //void setDirection(Direction d, Room door) => _directions[d] = door;

  Room.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'];
    for (var dir in Direction.values) {
      _doors[dir] = json[EnumToString.parse(dir)];
    }

    for (var i in json['items'] ?? []) {
      _items[i['name']] = Item.fromJson(i);
    }
  }

  void toConsole() {
    print('Room $_id, $_title, $_description');
    _doors.forEach((key, value) => print('$key: $value'));
    _items.forEach((key, value) {
      value.toConsole();
    });
  }

  Item getItem(String name) => _items[name];
  List<String> getItemNames() => _items.keys;
}
