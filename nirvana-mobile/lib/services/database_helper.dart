import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../config/app_constants.dart';

/// Local database helper for offline storage
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'nirvana_inspections.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // LVMDP Inspections Table
    await db.execute('''
      CREATE TABLE lvmdp_inspections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        time_slot TEXT NOT NULL,
        ampere_r REAL,
        ampere_s REAL,
        ampere_t REAL,
        volt_rs REAL,
        volt_st REAL,
        volt_tr REAL,
        cos_phi REAL,
        kw REAL,
        kwh REAL,
        hz REAL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        is_synced INTEGER DEFAULT 0,
        user_id INTEGER
      )
    ''');

    // STP Inspections Table
    await db.execute('''
      CREATE TABLE stp_inspections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        time_slot TEXT NOT NULL,
        grit_chamber_status TEXT,
        equalizing_tank_status TEXT,
        aeration_status TEXT,
        sedimentasi_tank_status TEXT,
        effluent_tank_status TEXT,
        pump_blower_status TEXT,
        notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        is_synced INTEGER DEFAULT 0,
        user_id INTEGER
      )
    ''');

    // Electrical Log Sheet Table
    await db.execute('''
      CREATE TABLE electrical_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        shift INTEGER NOT NULL,
        current_power REAL,
        kwh_wbp REAL,
        kwh_lwbp REAL,
        kwh_kvarh REAL,
        voltage_r REAL,
        voltage_s REAL,
        voltage_t REAL,
        current_r REAL,
        current_s REAL,
        current_t REAL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        is_synced INTEGER DEFAULT 0,
        user_id INTEGER
      )
    ''');

    // Water Log Sheet Table
    await db.execute('''
      CREATE TABLE water_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        shift INTEGER NOT NULL,
        pam_meter REAL,
        deepwell_meter REAL,
        ground_tank_level REAL,
        roof_tank_level REAL,
        booster_pressure REAL,
        flow_meter_reading REAL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        is_synced INTEGER DEFAULT 0,
        user_id INTEGER
      )
    ''');

    // Checklist Tables for each shift
    await db.execute('''
      CREATE TABLE checklists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        shift INTEGER NOT NULL,
        genset_condition TEXT,
        genset_operational TEXT,
        lift_condition TEXT,
        lift_operational TEXT,
        hydrant_condition TEXT,
        hydrant_operational TEXT,
        drainage_condition TEXT,
        drainage_operational TEXT,
        water_system_condition TEXT,
        water_system_operational TEXT,
        fire_alarm_condition TEXT,
        fire_alarm_operational TEXT,
        other_notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        is_synced INTEGER DEFAULT 0,
        user_id INTEGER
      )
    ''');

    // Offline Queue Table for sync
    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_name TEXT NOT NULL,
        record_id INTEGER NOT NULL,
        action TEXT NOT NULL,
        payload TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        retry_count INTEGER DEFAULT 0
      )
    ''');

    // QR Code Locations Table
    await db.execute('''
      CREATE TABLE qr_locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        qr_code TEXT UNIQUE NOT NULL,
        location_name TEXT NOT NULL,
        equipment_type TEXT,
        description TEXT,
        latitude REAL,
        longitude REAL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_lvmdp_date ON lvmdp_inspections(date)');
    await db.execute('CREATE INDEX idx_stp_date ON stp_inspections(date)');
    await db.execute('CREATE INDEX idx_electrical_date ON electrical_logs(date)');
    await db.execute('CREATE INDEX idx_water_date ON water_logs(date)');
    await db.execute('CREATE INDEX idx_checklist_date ON checklists(date)');
    await db.execute('CREATE INDEX idx_sync_queue_action ON sync_queue(action)');
  }

  /// Upgrade database
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here
    if (oldVersion < 2) {
      // Add new columns or tables as needed
    }
  }

  // Generic CRUD operations
  
  /// Insert record
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  /// Get record by ID
  Future<Map<String, dynamic>?> getById(String table, int id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get all records from table
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  /// Update record
  Future<int> update(String table, int id, Map<String, dynamic> data) async {
    final db = await database;
    data['updated_at'] = DateTime.now().toIso8601String();
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete record
  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get unsynced records
  Future<List<Map<String, dynamic>>> getUnsyncedRecords(String table) async {
    final db = await database;
    return await db.query(
      table,
      where: 'is_synced = ?',
      whereArgs: [0],
    );
  }

  /// Mark record as synced
  Future<void> markAsSynced(String table, int id) async {
    final db = await database;
    await db.update(
      table,
      {'is_synced': 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Add to sync queue
  Future<int> addToSyncQueue({
    required String tableName,
    required int recordId,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    final db = await database;
    return await db.insert('sync_queue', {
      'table_name': tableName,
      'record_id': recordId,
      'action': action,
      'payload': jsonEncode(payload),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get pending sync items
  Future<List<Map<String, dynamic>>> getPendingSyncItems() async {
    final db = await database;
    return await db.query('sync_queue', orderBy: 'created_at ASC');
  }

  /// Remove from sync queue
  Future<void> removeFromSyncQueue(int id) async {
    final db = await database;
    await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }

  /// Clear all data (for logout)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('lvmdp_inspections');
    await db.delete('stp_inspections');
    await db.delete('electrical_logs');
    await db.delete('water_logs');
    await db.delete('checklists');
    await db.delete('sync_queue');
  }
}
