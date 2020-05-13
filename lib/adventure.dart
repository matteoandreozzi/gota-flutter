import 'package:gota/loader.dart';
import 'package:gota/parser.dart';

import 'item.dart';
import 'room.dart';

class Adventure {
  List<Room> _map = [];
  Map<String, Item> _inventory = Map();
  Loader _loader;
  Room _currentRoom;
  String _currentStory = '';

  Adventure();

  Future<void> load(String resource) async {
    _loader = AssetLoader(resource);

    await _loader.load().then((onValue) {
      if (onValue) {
        Map<String, dynamic> decoded = _loader.getDecoded();

        decoded.forEach((k, v) {
          if (v is Map) {
            _map.add(Room.fromJson(v));
          } else if (v is List) {
            _inventory.addEntries(
                v.map((e) => MapEntry(e['name'], Item.fromJson(e))));
            //_inventory.add(Item.fromJson(v));
          }
        });

        _currentRoom = _map[0];

        print('Adventure loaded');
        for (var room in _map) room.toConsole();
        print('Inventory');
        _inventory.forEach((key, value) {
          value.toConsole();
        });
      } else {
        print('Adventure failed to load');
      }
    });
  }

  String getTitle() => _currentRoom?.getTitle() ?? 'Loading';

  String getStory() => _currentStory;

  List<String> getInventoryNames() => _inventory.keys;

  bool directionVisible(Direction dir) {
    return (_currentRoom?.getDoor(dir) != null);
  }

  void navigate(Direction dir) {
    _currentRoom = _map[_currentRoom.getDoor(dir)];
    _currentStory = _currentRoom.getDescription();
  }

  void command(List<dynamic> tokens) {
    // fetch target item from current room
    // TODO support empty commands to default to current room

    print('received tokens: $tokens');
    var target = _inventory[tokens[1]] ?? _currentRoom.getItem(tokens[1]);
    if (target != null) {
      switch (tokens[0]) {
        case Command.USE:
          target.switchOn();
          break;
        case Command.OPEN:
          if (target.open()) {
            _currentStory = "${target.name()} has been opened";
          }
          break;
        case Command.EXAMINE:
          _currentStory = target.examine();
          break;
      }
    } else {
      _currentStory =
          ('room ${_currentRoom.getTitle()} does not have ${tokens[1]}');
    }
  }
}
