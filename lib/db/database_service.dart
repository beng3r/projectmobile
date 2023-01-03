import 'package:path/path.dart';
import 'package:projectmobile/models/busticket.dart';
import 'package:projectmobile/models/user.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;

  final String tableUser = "User";
  final String columnName = "name";
  final String columnUserName = "username";
  final String columnPassword = "password";

  DatabaseService._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'projectAssignment.db');
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store brands
  // and a table to store shoes.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {user} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE user(user_id INTEGER PRIMARY KEY, f_name TEXT NOT NULL, l_name TEXT NOT NULL, username TEXT NOT NULL, password TEXT NOT NULL, mobilehp TEXT NOT NULL)',
    );
    // Run the CREATE {busticket} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE busticket(book_id INTEGER PRIMARY KEY, depart_date DATETIME NOT NULL, time TEXT NOT NULL, depart_station TEXT NOT NULL, dest_station TEXT NOT NULL, user_id INTEGER NOT NULL, FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL)',
    );
  }

  // Define a function that inserts brands into the database
  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    // Insert the Brand into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same breed is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertBusticket(BusTicket busticket) async {
    final db = await _databaseService.database;
    await db.insert(
      'shoes',
      busticket.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the brands from the brands table.
  Future<List<User>> users() async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    // Query the table for all the Brands.
    final List<Map<String, dynamic>> maps = await db.query('User');
    // Convert the List<Map<String, dynamic> into a List<Brand>.
    return List.generate(maps.length, (index) => User.fromMap(maps[index]));
  }

  Future<User> user(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('User', where: 'id = ?', whereArgs: [id]);
    return User.fromMap(maps[0]);
  }

  Future<List<BusTicket>> busticket() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('busticket');
    return List.generate(
        maps.length, (index) => BusTicket.fromMap(maps[index]));
  }

  Future<User?> getLogin(String user, String password) async {
    var dbClient = await _databaseService.database;
    var res = await dbClient.rawQuery(
        "SELECT * FROM user WHERE username = '$user' and password = '$password'");

    if (res.length > 0) {
      return new User.fromMap(res.first);
    }
    return null;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    final db = await _databaseService.database;
    final results = await db.rawQuery('SELECT COUNT(*) FROM $user');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // A method that updates a brand data from the brands table.
  Future<void> updateUser(User user) async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    // Update the given brand
    await db.update(
      'brands',
      user.toMap(),
      // Ensure that the Brand has a matching id.
      where: 'id = ?',
      // Pass the Brand's id as a whereArg to prevent SQL injection.
      whereArgs: [user.user_id],
    );
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await _databaseService.database;
    return await db.query(tableUser);
  }

  Future<void> updateBusTicker(BusTicket busTicket) async {
    final db = await _databaseService.database;
    await db.update('shoes', busTicket.toMap(),
        where: 'id = ?', whereArgs: [busTicket.book_id]);
  }

  // A method that deletes a brand data from the breeds table.
  Future<void> deleteBrand(int id) async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    // Remove the Brand from the database.
    await db.delete(
      'brands',
      // Use a `where` clause to delete a specific brand.
      where: 'id = ?',
      // Pass the Brand's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteShoe(int id) async {
    final db = await _databaseService.database;
    await db.delete('shoes', where: 'id = ?', whereArgs: [id]);
  }
}
