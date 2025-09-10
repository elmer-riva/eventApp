import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/database/database_helper.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/data/models/event_model.dart';

abstract class EventLocalDataSource {
  Future<List<EventModel>> getFavorites();
  Future<void> saveFavorite(EventModel event);
  Future<void> deleteFavorite(int eventId);
  Future<bool> isFavorite(int eventId);
}

class EventLocalDataSourceImpl implements EventLocalDataSource {
  final DatabaseHelper dbHelper;
  EventLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<void> deleteFavorite(int eventId) async {
    final db = await dbHelper.database;
    await db.delete(DatabaseHelper.table, where: '${DatabaseHelper.columnId} = ?', whereArgs: [eventId]);
  }

  @override
  Future<List<EventModel>> getFavorites() async {
    final db = await dbHelper.database;
    final maps = await db.query(DatabaseHelper.table);
    return maps.map((map) => EventModel.fromDb(map)).toList();
  }

  @override
  Future<bool> isFavorite(int eventId) async {
    final db = await dbHelper.database;
    final maps = await db.query(DatabaseHelper.table, where: '${DatabaseHelper.columnId} = ?', whereArgs: [eventId]);
    return maps.isNotEmpty;
  }

  @override
  Future<void> saveFavorite(EventModel event) async {
    final db = await dbHelper.database;
    await db.insert(DatabaseHelper.table, event.toDbMap());
  }
}