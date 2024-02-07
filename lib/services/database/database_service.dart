import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  late final Box _common;
  late final Box<String> _watchlist;
  Future<DatabaseService> init() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDirectory.path);
    _common = await Hive.openBox('common');
    _watchlist = await Hive.openBox('watchlist');

    return this;
  }

  Iterable<String> get watchlistIds => _watchlist.values;

  void put(String key, dynamic value) => _common.put(key, value);

  dynamic get(String key) => _common.get(key);

  void addCoin(String uuid) => _watchlist.add(uuid);

  void removeCoin(int index) => _watchlist.deleteAt(index);
}
