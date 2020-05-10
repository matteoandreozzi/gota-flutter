import 'package:gota/loader.dart';

import 'item.dart';
import 'room.dart';

class Adventure {
  List<Room> _map = [];
  List<Item> _inventory = [];
  Loader _loader;
  Room _currentRoom;

  Adventure();

  Future<void> load(String resource) async {
    _loader = AssetLoader(resource);

    var loaded = _loader.load();

    loaded.then((onValue) {
      if (onValue) {
        Map<String, dynamic> decoded = _loader.getDecoded();

        decoded.forEach((k, v) {
          if (v is Map) {
            _map.add(Room.fromJson(v));
          }
        });

        for (var room in _map) room.toConsole();
        _currentRoom = _map[0];
      } else {
        print('Adventure failed to load');
      }
    });
  }

  String getTitle() => _currentRoom?.getTitle() ?? 'Loading';
  String getStory() => _currentRoom?.getDescription() ?? 'Loading';

  bool directionVisible(Direction dir) {
    return (_currentRoom?.getDoor(dir) != null);
  }

  void navigate(Direction dir) {
    _currentRoom = _map[_currentRoom.getDoor(dir)];
  }
}
