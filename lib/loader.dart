import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

abstract class Loader {
  String _resource;
  var _decoded;

  Loader(this._resource);

  Future<bool> load();

  void _decode(String data) {
    _decoded = jsonDecode(data);
  }

  dynamic getDecoded() => _decoded;
}

class DocumentLoader extends Loader {
  DocumentLoader(String resource) : super(resource);

  @override
  Future<bool> load() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$_resource');
      _decode(await file.readAsString());
      return true;
    } catch (e) {
      print("Couldn't read document file $_resource");
    }
    return false;
  }
}

class AssetLoader extends Loader {
  AssetLoader(String resource) : super(resource);
  @override
  Future<bool> load() async {
    try {
      _decode(await rootBundle.loadString(_resource));
      return true;
    } catch (e) {
      print("Couldn't read asset file $_resource");
    }
    return false;
  }
}
