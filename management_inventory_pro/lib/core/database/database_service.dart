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
	${DatabaseConstants.idColumn}	INTEGER NOT NULL,
	${DatabaseConstants.nameColumn}	TEXT NOT NULL,
	${DatabaseConstants.createdAtColumn}	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(${DatabaseConstants.idColumn} AUTOINCREMENT)
);
   """);

    await db.execute("""
 CREATE TABLE IF NOT EXISTS "${DatabaseConstants.unitTable}" (
	${DatabaseConstants.idColumn}	INTEGER NOT NULL,
	${DatabaseConstants.nameColumn}	TEXT NOT NULL,
	${DatabaseConstants.symbolColumn}	TEXT NOT NULL,
	PRIMARY KEY(${DatabaseConstants.idColumn} AUTOINCREMENT)
);

   """);
    await db.execute("""
 CREATE TABLE IF NOT EXISTS "${DatabaseConstants.productTable}" (
	${DatabaseConstants.idColumn}	TEXT NOT NULL,
	${DatabaseConstants.nameColumn}	TEXT NOT NULL,
	${DatabaseConstants.skuColumn}	TEXT UNIQUE,
	${DatabaseConstants.barcodeColumn}	TEXT UNIQUE,
	${DatabaseConstants.categoryIdColumn}	INTEGER NOT NULL,
	${DatabaseConstants.unitIdColumn}	INTEGER NOT NULL,
	${DatabaseConstants.costPriceColumn}	REAL NOT NULL CHECK(${DatabaseConstants.costPriceColumn} >= 0),
	${DatabaseConstants.sellingPriceColumn}	REAL NOT NULL CHECK(${DatabaseConstants.sellingPriceColumn} >= 0),
	${DatabaseConstants.minimumStockColumn}	REAL DEFAULT 0,
	${DatabaseConstants.imageUrlColumn}	TEXT,
	${DatabaseConstants.noteColumn}	TEXT,
	${DatabaseConstants.createdAtColumn}	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	${DatabaseConstants.updatedAtColumn}	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	${DatabaseConstants.currentStockColumn}	REAL NOT NULL DEFAULT 0 CHECK(${DatabaseConstants.currentStockColumn} >= 0),
	PRIMARY KEY(${DatabaseConstants.idColumn}),
	FOREIGN KEY(${DatabaseConstants.categoryIdColumn}) REFERENCES "${DatabaseConstants.categoryTable}" ("${DatabaseConstants.idColumn}") ON DELETE RESTRICT,
	FOREIGN KEY("${DatabaseConstants.unitIdColumn}") REFERENCES "${DatabaseConstants.unitTable}"("${DatabaseConstants.idColumn}") ON DELETE RESTRICT
);
   """);
    await db.execute("""
 CREATE TABLE IF NOT EXISTS "${DatabaseConstants.supplierTable}" (
		${DatabaseConstants.idColumn}	TEXT NOT NULL,
	${DatabaseConstants.companyNameColumn}	TEXT NOT NULL,
	${DatabaseConstants.phoneColumn}	TEXT UNIQUE,
	${DatabaseConstants.emailColumn}	TEXT UNIQUE,
	${DatabaseConstants.addressColumn}	TEXT,
	${DatabaseConstants.noteColumn}	TEXT,
	${DatabaseConstants.createdAtColumn}	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	${DatabaseConstants.updatedAtColumn}	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("${DatabaseConstants.idColumn}")
);
   """);

    await db.execute("""
CREATE TABLE IF NOT EXISTS ${DatabaseConstants.stockEntryTable} (
    ${DatabaseConstants.idColumn} TEXT NOT NULL PRIMARY KEY,
    ${DatabaseConstants.supplierIdColumn} TEXT NOT NULL,
    ${DatabaseConstants.noteColumn} TEXT,
    ${DatabaseConstants.totalItemColumn} INTEGER NOT NULL DEFAULT 0,
    ${DatabaseConstants.totalQuantityColumn} REAL NOT NULL DEFAULT 0,
    ${DatabaseConstants.totalCostColumn} REAL NOT NULL DEFAULT 0,
    ${DatabaseConstants.createdAtColumn} TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ${DatabaseConstants.receiptDateColumn}	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ${DatabaseConstants.updatedAtColumn}	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (${DatabaseConstants.supplierIdColumn})
        REFERENCES ${DatabaseConstants.supplierTable}(${DatabaseConstants.idColumn})
        ON DELETE RESTRICT
);
   """);
    await db.execute("""
CREATE TABLE IF NOT EXISTS ${DatabaseConstants.stockEntryItemTable} (
    ${DatabaseConstants.idColumn} TEXT NOT NULL PRIMARY KEY,
    ${DatabaseConstants.stockEntryIdColumn} TEXT NOT NULL,
    ${DatabaseConstants.productIdColumn} TEXT NOT NULL,
    ${DatabaseConstants.quantityColumn} REAL NOT NULL CHECK(quantity > 0),
    ${DatabaseConstants.costPriceColumn} REAL NOT NULL CHECK(cost_price >= 0),
    ${DatabaseConstants.totalColumn} REAL NOT NULL CHECK(total >= 0),

    FOREIGN KEY (${DatabaseConstants.stockEntryIdColumn})
        REFERENCES ${DatabaseConstants.stockEntryTable}(${DatabaseConstants.idColumn})
        ON DELETE CASCADE,

    FOREIGN KEY (${DatabaseConstants.productIdColumn})
        REFERENCES ${DatabaseConstants.productTable}(${DatabaseConstants.idColumn})
        ON DELETE RESTRICT
);
   """);

    await db.execute("""
CREATE TABLE IF NOT EXISTS ${DatabaseConstants.saleTable} (
    ${DatabaseConstants.idColumn} TEXT NOT NULL PRIMARY KEY,

    ${DatabaseConstants.totalItemColumn} INTEGER NOT NULL DEFAULT 0,
    ${DatabaseConstants.totalQuantityColumn} REAL NOT NULL DEFAULT 0,
    ${DatabaseConstants.totalAmountColumn} REAL NOT NULL DEFAULT 0,

    ${DatabaseConstants.noteColumn} TEXT,

    ${DatabaseConstants.createdAtColumn} TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ${DatabaseConstants.updatedAtColumn} TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    ${DatabaseConstants.paymentMethodColumn} TEXT DEFAULT 'Cash',
    ${DatabaseConstants.cashierNameColumn} TEXT DEFAULT 'Admin',
    ${DatabaseConstants.statusColumn} TEXT DEFAULT 'completed'
);
""");
    await db.execute("""
CREATE TABLE  IF NOT EXISTS ${DatabaseConstants.saleItemTable} (
    ${DatabaseConstants.idColumn} TEXT NOT NULL PRIMARY KEY,
    ${DatabaseConstants.saleIdColumn}  TEXT NOT NULL,
    ${DatabaseConstants.productIdColumn} TEXT NOT NULL,
    ${DatabaseConstants.quantityColumn} REAL NOT NULL CHECK(${DatabaseConstants.quantityColumn} > 0),
    ${DatabaseConstants.sellingPriceColumn} REAL NOT NULL CHECK(${DatabaseConstants.sellingPriceColumn} >= 0),
    ${DatabaseConstants.totalColumn} REAL NOT NULL CHECK(${DatabaseConstants.totalColumn} >= 0),

    FOREIGN KEY (${DatabaseConstants.saleIdColumn})
        REFERENCES ${DatabaseConstants.saleTable}(${DatabaseConstants.idColumn})
        ON DELETE CASCADE,

    FOREIGN KEY (${DatabaseConstants.productIdColumn})
        REFERENCES ${DatabaseConstants.productTable}(${DatabaseConstants.idColumn})
        ON DELETE RESTRICT
);
   """);

  }

}