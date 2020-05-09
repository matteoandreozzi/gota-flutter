import 'item.dart';

enum Direction { NORTH, EAST, SOUTH, WEST, UP, DOWN }

extension ParseToString on Direction {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class Room {
  int _id;
  String _title, _description;
  Map<Direction, int> _doors = Map();
  List<Item> _items = [];

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
      _doors[dir] = json[dir.toShortString()];
    }
    if (json['items'] != null) {
      for (var i in json['items']) {
        _items.add(Item.fromJson(i));
      }
    }
  }

  void toConsole() {
    print('Room $_id, $_title, $_description');
    _doors.forEach((k, v) => print('$k: $v'));
    for (var i in _items) i.toConsole();
  }
}
