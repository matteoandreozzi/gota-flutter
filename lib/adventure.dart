import 'package:gota/loader.dart';

import 'item.dart';
import 'room.dart';

class Adventure {
  List<Room> _map = [];
  List<Item> _inventory = [];
  Loader _loader;
  Room _currentRoom;

  Adventure(String resource) {
    _loader = AssetLoader(resource);

    var loaded = _loader.load();

    loaded.then((onValue) {
      Map<String, dynamic> decoded = _loader.getDecoded();

      decoded.forEach((k, v) {
        if (v is Map) {
          _map.add(Room.fromJson(v));
        }
      });

      for (var room in _map) room.toConsole();
      // TODO set initial room
      _currentRoom = _map[0];
    });
  }

  String getTitle() =>
      _currentRoom != null ? _currentRoom.getTitle() : 'Loading';
  String getStory() =>
      _currentRoom != null ? _currentRoom.getDescription() : 'Loading';

  bool directionVisible(Direction dir) {
    if (_currentRoom != null) {
      return (_currentRoom.getDoor(dir) != null);
    }
    return false;
  }

  void navigate(Direction dir) {
    _currentRoom = _map[_currentRoom.getDoor(dir)];
  }
}
