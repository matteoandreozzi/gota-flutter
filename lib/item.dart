import 'package:bit_array/bit_array.dart';
import 'package:enum_to_string/enum_to_string.dart';

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

class Item {
  String _name, _description;
  int _id;
  List _contained = [];
  int _health = -1;

  // properties of the object (e.g. LOCKED, CONTAINER, etc.)
  final _properties = BitArray(ItemProperty.NUM_PROPERTIES.index);

  // object status
  final _statuses = BitArray(ItemStatus.NUM_STATUSES.index);

  Item.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _description = json['description'];
    _health = json['health'];
    if (json['contained'] != null) {
      for (var c in json['contained']) {
        _contained.add(Item.fromJson(c));
      }
    }
    if (json['properties'] != null) {
      for (var p in json['properties']) {
        var property = EnumToString.fromString(ItemProperty.values, p);
        _properties.setBit(property.index);
      }
    }
  }

  void toConsole() {
    print('Item $_name, $_description');
    for (var p in _properties.asIntIterable()) {
      print('Property ${ItemProperty.values[p]}');
    }

    for (var c in _contained) {
      c.toConsole();
    }
  }

  bool hasProperty(ItemProperty p) => _properties[p.index];

  bool hasStatus(ItemStatus p) => _statuses[p.index];

  bool lock(int key) {
    if (_properties[ItemProperty.LOCKABLE.index]) {
      if (key == _id) {
        _statuses.setBit(ItemStatus.LOCKED.index);
        return true;
      }
    }
    return false;
  }

  bool age() {
    if (_properties[ItemProperty.CONSUMABLE.index]) {
      return (_health-- > 0);
    }
    return true;
  }

  bool unlock(int key) {
    if (_properties[ItemProperty.LOCKABLE.index]) {
      if (key == _id) {
        _statuses.clearBit(ItemStatus.LOCKED.index);
        return true;
      }
    }
    return false;
  }

  bool switchOn() {
    if (_properties[ItemProperty.SWITCHABLE.index] && age()) {
      _statuses.setBit(ItemStatus.SWITCHED.index);
      return true;
    }
    return false;
  }

  bool switchOff() {
    if (_properties[ItemProperty.SWITCHABLE.index]) {
      _statuses.clearBit(ItemStatus.SWITCHED.index);
      return true;
    }
    return false;
  }

  bool open() {
    if (_properties[ItemProperty.OPENABLE.index] &&
        !_statuses[ItemStatus.LOCKED.index]) {
      _statuses.setBit(ItemStatus.OPENED.index);
      return true;
    }
    return false;
  }

  bool close() {
    if (_properties[ItemProperty.OPENABLE.index] &&
        !_statuses[ItemStatus.LOCKED.index]) {
      _statuses.clearBit(ItemStatus.OPENED.index);
      return true;
    }
    return false;
  }

  String examine() => _description;

  void makeVisible() {
    _statuses.setBit(ItemStatus.VISIBLE.index);
  }

  void makeInvisible() {
    _statuses.clearBit(ItemStatus.VISIBLE.index);
  }

  Item(this._id, this._name, this._description, List<ItemProperty> properties,
      List<ItemStatus> status) {
    for (var p in properties) {
      _properties.setBit(p.index);
    }
    for (var s in status) {
      _statuses.setBit(s.index);
    }
  }
}
