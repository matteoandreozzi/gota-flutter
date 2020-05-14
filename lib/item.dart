import 'package:bit_array/bit_array.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:gota/syntax.dart';

class Item {
  String _name, _description;
  int _id;
  List _contained = [];
  int _health = -1;

  // properties of the object (e.g. LOCKED, CONTAINER, etc.)
  final _properties = BitArray(ItemProperty.NUM_PROPERTIES.index);

  // object status
  final _status = BitArray(ItemStatus.NUM_STATUSES.index);

  Item(this._id, this._name, this._description, List<dynamic> properties,
      List<dynamic> status, List<dynamic> contained) {
    for (var p in properties ?? []) {
      _properties.setBit(EnumToString.fromString(ItemProperty.values, p).index);
    }
    for (var s in status ?? []) {
      _status.setBit(EnumToString.fromString(ItemStatus.values, s).index);
    }

    for (var c in contained ?? []) {
      _contained.add(Item.fromJson(c));
    }
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['id'], json['name'], json['description'],
        json['properties'], json['status'], json['contained']);
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

  bool hasStatus(ItemStatus p) => _status[p.index];

  bool lock(int key) {
    if (_properties[ItemProperty.LOCKABLE.index]) {
      if (key == _id) {
        _status.setBit(ItemStatus.LOCKED.index);
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
        _status.clearBit(ItemStatus.LOCKED.index);
        return true;
      }
    }
    return false;
  }

  bool switchOn() {
    if (_properties[ItemProperty.SWITCHABLE.index] && age()) {
      _status.setBit(ItemStatus.SWITCHED.index);
      return true;
    }
    return false;
  }

  bool switchOff() {
    if (_properties[ItemProperty.SWITCHABLE.index]) {
      _status.clearBit(ItemStatus.SWITCHED.index);
      return true;
    }
    return false;
  }

  bool open() {
    if (_properties[ItemProperty.OPENABLE.index] &&
        !_status[ItemStatus.LOCKED.index]) {
      _status.setBit(ItemStatus.OPENED.index);
      print('$_name has been opened');
      return true;
    }
    return false;
  }

  bool close() {
    if (_properties[ItemProperty.OPENABLE.index] &&
        !_status[ItemStatus.LOCKED.index]) {
      _status.clearBit(ItemStatus.OPENED.index);
      return true;
    }
    return false;
  }

  String get name => _name;
  String get description => _description;

  void makeVisible() {
    _status.setBit(ItemStatus.VISIBLE.index);
  }

  void makeInvisible() {
    _status.clearBit(ItemStatus.VISIBLE.index);
  }
}
