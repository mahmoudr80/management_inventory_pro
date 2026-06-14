import 'dart:async';
import 'dart:io';
import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  late final Database db;

  Future<void>init() async {
    final exeDir = File(Platform.resolvedExecutable).parent.path;

    final dataDir = Directory(
      p.join(exeDir, 'data'),
    );

    if (!await dataDir.exists()) {
      await dataDir.create(recursive: true);
    }

    final dbPath = p.join(
      dataDir.path,
      'inventory.db',
    );

    db =await openDatabase(dbPath
      ,  version: 1,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
   CREATE TABLE IF NOT EXISTS "${DatabaseConstants.categoryTable}" (
	"id"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	"created_at"	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id" AUTOINCREMENT)
);
   """);

    await db.execute("""
 CREATE TABLE IF NOT EXISTS "${DatabaseConstants.unitTable}" (
	"id"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	"symbol"	TEXT NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);

   """);
    await db.execute("""
 CREATE TABLE IF NOT EXISTS "${DatabaseConstants.productTable}" (
	"id"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"sku"	TEXT UNIQUE,
	"barcode"	TEXT UNIQUE,
	"category_id"	INTEGER NOT NULL,
	"unit_id"	INTEGER NOT NULL,
	"cost_price"	REAL NOT NULL CHECK("cost_price" >= 0),
	"selling_price"	REAL NOT NULL CHECK("selling_price" >= 0),
	"min_stock"	REAL DEFAULT 0,
	"image_url"	TEXT,
	"note"	TEXT,
	"created_at"	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"current_stock"	REAL NOT NULL DEFAULT 0 CHECK("current_stock" >= 0),
	PRIMARY KEY("id"),
	FOREIGN KEY("category_id") REFERENCES "categories"("id") ON DELETE RESTRICT,
	FOREIGN KEY("unit_id") REFERENCES "units"("id") ON DELETE RESTRICT
);
   """);
    await db.execute("""
 CREATE TABLE IF NOT EXISTS "${DatabaseConstants.supplierTable}" (
		"id"	TEXT NOT NULL,
	"company_name"	TEXT NOT NULL,
	"phone"	TEXT UNIQUE,
	"email"	TEXT UNIQUE,
	"address"	TEXT,
	"notes"	TEXT,
	"created_at"	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id")
);
   """);
  }

}