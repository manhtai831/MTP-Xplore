import 'dart:async';

class PathManager {
  PathManager._();

  static final PathManager _singleton = PathManager._();

  factory PathManager() => _singleton;

  List<String> paths = [];
  StreamController<String> _controller = StreamController.broadcast();
  Stream<String> get stream => _controller.stream;

  void add(String p) {
    paths.add(p);
    _controller.add('event');
  }

  void addMany(String p) {
    final splits = p.split('/');
    paths.addAll(splits);
    _controller.add('event');
  }

  void remove() {
    paths.removeLast();
    _controller.add('event');
  }

  void removeAll() {
    paths.clear();
    _controller.add('event');
  }

  @override
  String toString() {
    final result = paths.join('/');
    if (result.startsWith('//')) {
      return result.substring(1);
    }
    return result;
  }
}
