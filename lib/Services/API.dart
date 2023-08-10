import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myorder/Services/Models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

class API {
  static final API _instance = API.internal();
  factory API() => _instance;

  late Database _database;
  API.internal() {
    // Initialization code
    _initializeDatabase();
  }

  Future<Database> _initializeDatabase() async {
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'recipe.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (db) {
        // Increase the cursor window size (example: 10MB)
        db.execute('PRAGMA cache_size=-10000000;');
      },
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE items (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            buying_price REAL NOT NULL,
            selling_price REAL NOT NULL,
            inserted_on TEXT NOT NULL,
            barcode TEXT ,
            image BLOB
          )
        ''');

    await db.execute('''
          CREATE TABLE clients (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            item TEXT NOT NULL,
            buying_price REAL NOT NULL,
            selling_price REAL NOT NULL,
            inserted_on TEXT NOT NULL,
            note TEXT
          )
        ''');

    await db.execute('''
          CREATE TABLE profit (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            profit REAL NOT NULL,
            quantity INTEGER NOT NULL,
            date TEXT NOT NULL
          )
        ''');
  }

  static Future<List<Item>> getItems(
      Function(List<Item>) updateItemsState) async {
    final db = await API().initDatabase();
    final List<Map<String, dynamic>> maps =
        await db.query('items', columns: ['id', 'name', 'quantity', 'image']);
    List<Item> items = List.generate(maps.length, (index) {
      return Item(
        id: maps[index]['id'],
        name: maps[index]['name'],
        quantity: maps[index]['quantity'],
        buyingPrice: 0,
        sellingPrice: 0,
        insertedOn: '',
        barcode: '',
        image: maps[index]['image'] != null
            ? Uint8List.fromList(maps[index]['image'])
            : null,
      );
    });
    updateItemsState(items);
    return items;
  }

  static Future<List<Client>> getClients(
      Function(List<Client>) updateClientsState) async {
    final db = await API().initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('clients');
    List<Client> list = List.generate(maps.length, (index) {
      return Client(
        id: maps[index]['id'],
        name: maps[index]['name'],
        item: maps[index]['item'],
        buyingPrice: maps[index]['buying_price'],
        sellingPrice: maps[index]['selling_price'],
        insertedOn: maps[index]['inserted_on'],
        note: maps[index]['note'],
      );
    });
    updateClientsState(list);
    return list;
  }

  static Future<void> deleteClient(String id) async {
    final db = await API().initDatabase();
    await db.delete('clients', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteItem(String id) async {
    final db = await API().initDatabase();
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Profit>> getProfits(
      Function(List<Profit>) updateProfitsState, String month) async {
    final db = await API().initDatabase();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT * FROM profit
    WHERE date = '$month';
    ''');

    List<Profit> list = List.generate(maps.length, (index) {
      return Profit(
        id: maps[index]['id'],
        name: maps[index]['name'],
        profit: maps[index]['profit'],
        quantity: maps[index]['quantity'],
        date: maps[index]['date'],
      );
    });

    updateProfitsState(list);
    return list;
  }

  static Future<void> clearDatabase(String month) async {
    final db = await API().initDatabase();
    await db.delete('profit',
        where: "date = ?",
        whereArgs: [month]); // Replace 'profit' with your table name
  }

  static Future<Item> getItem(String id) async {
    final db = await API().initDatabase();
    final List<Map<String, dynamic>> map = await db.query(
      'items',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    Item item = Item(
        id: id,
        name: map[0]['name'],
        quantity: map[0]['quantity'],
        buyingPrice: map[0]['buying_price'],
        sellingPrice: map[0]['selling_price'],
        insertedOn: map[0]['inserted_on'],
        barcode: map[0]['barcode'],
        image: map[0]['image']);
    return item;
  }

  static Future<void> removeProfit(String id) async {
    final db = await API().initDatabase();
    List<Map<String, dynamic>> map =
        await db.query('profit', where: 'id = ?', whereArgs: [id]);

    if (map[0]['quantity'] > 1) {
      await db.update("profit", {'quantity': map[0]['quantity'] - 1},
          where: 'id = ?', whereArgs: [id]);
    } else {
      await db.delete('profit', where: 'id = ?', whereArgs: [id]);
    }
  }

  static Future<void> addItem(Item item, XFile? imageFile) async {
    final db = await API().initDatabase();
    Map<String, dynamic> itemData = item.toMap();

    Uint8List? imageBytes;
    if (imageFile != null && item.image == null) {
      // Read the image file bytes
      imageBytes = File(imageFile.path).readAsBytesSync();

      // Resize the image to a specific width and height
      img.Image image = img.decodeImage(imageBytes)!;
      img.Image resizedImage = img.copyResize(image,
          width: 200, height: 200); // Adjust width and height as needed

      // Encode the resized image as bytes
      imageBytes = Uint8List.fromList(
          img.encodeJpg(resizedImage)); // You can use encodePng for PNG format

      itemData['image'] = imageBytes;
    } else {
      itemData['image'] = item.image;
    }

    await db.insert(
      'items',
      itemData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> addClient(Client client) async {
    final db = await API().initDatabase();
    await db.insert(
      'clients',
      client.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> addProfit(Profit profit) async {
    final db = await API().initDatabase();
    await db.insert(
      'profit',
      profit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> addProfits(List<Profit> profits) async {
    final db = await API().initDatabase();
    DateTime now = DateTime.now();
    String date = DateFormat('dd-MM-yyyy').format(now);
    int day = int.parse(date.split('-')[0]);
    String month = '';
    if (day <= 20) {
      month = date.split('-')[1];
    } else {
      int numb = int.parse(date.split('-')[1]) + 1;
      month = numb.toString();
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
SELECT * FROM profit
WHERE date = '$month';
''');

// Create a map to keep track of existing profits by name
    Map<String, Profit> existingProfits = {};

    for (var map in maps) {
      Profit profit = Profit(
        id: map['id'],
        name: map['name'],
        profit: map['profit'],
        quantity: map['quantity'],
        date: map['date'],
      );

      existingProfits[profit.name] = profit;
    }

    final batch = db.batch();

    for (var item in profits) {
      String itemName = item.name;

      if (existingProfits.containsKey(itemName) &&
          existingProfits[itemName]!.profit == item.profit) {
        // Update the existing profit's quantity
        Profit existingProfit = existingProfits[itemName]!;
        int newQuantity = existingProfit.quantity + item.quantity;
        batch.update(
          'profit',
          {'quantity': newQuantity},
          where: 'id = ?',
          whereArgs: [existingProfit.id],
        );
      } else {
        item.id = Uuid().v4();
        batch.insert(
          'profit',
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    await batch.commit();
  }

  static Future<void> reduceQuantity(List<String> ids) async {
    final db = await API().initDatabase();
    for (var id in ids) {
      List<Map<String, dynamic>> item = await db.query('items',
          where: 'id = ?', whereArgs: [id], columns: ['quantity']);
      await db.update('items', {'quantity': item[0]['quantity'] - 1},
          where: 'id = ?', whereArgs: [id]);
    }
  }

  static Future<CartItem?> getItemByBarcode(String barcode) async {
    final db = await API().initDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'barcode = ?',
      columns: ['id', 'name', 'selling_price', 'buying_price'],
      whereArgs: [barcode],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null; // Return null if no matching row is found    }
    }

    return CartItem(
        itemId: maps[0]['id'],
        name: maps[0]['name'],
        sellingPrice: maps[0]['selling_price'],
        buyingPrice: maps[0]['buying_price'],
        profit: maps[0]['selling_price'] - maps[0]['buying_price']);
  }
}
