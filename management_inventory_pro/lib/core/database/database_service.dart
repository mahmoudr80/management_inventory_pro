import 'dart:async';
import 'dart:io';
import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Phase 3 change: added `_createIndexes()`, called at the end of
/// `_onCreate`. Every index below backs a column that at least one
/// Reports datasource filters, joins, or sorts on — see the comment on
/// each index for which report(s) it serves. No table/column was
/// changed; this is purely additive (CREATE INDEX IF NOT EXISTS), so it
/// requires no migration bump for a fresh database. If any existing
/// installs already exist with this schema at version 1, bump
/// `version` here and add an `onUpgrade` that calls `_createIndexes(db)`
/// — indexes are safe to create on an existing table without touching
/// its data.
class DatabaseService {
  late final Database db;

  Future<void> init() async {
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

    db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
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
	${DatabaseConstants.minimumStockColumn}	REAL DEFAULT 0 CHECK(${DatabaseConstants.minimumStockColumn} >= 0),
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
    ${DatabaseConstants.receivedByColumn} TEXT NOT NULL DEFAULT 'Admin',
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

    ${DatabaseConstants.subtotalColumn} REAL NOT NULL DEFAULT 0
        CHECK(${DatabaseConstants.subtotalColumn} >= 0),

    ${DatabaseConstants.discountAmountColumn} REAL NOT NULL DEFAULT 0
        CHECK(${DatabaseConstants.discountAmountColumn} >= 0
              AND ${DatabaseConstants.discountAmountColumn} <= ${DatabaseConstants.subtotalColumn}),

    ${DatabaseConstants.taxEnabledColumn} INTEGER NOT NULL DEFAULT 0
        CHECK(${DatabaseConstants.taxEnabledColumn} IN (0,1)),

    ${DatabaseConstants.taxPercentageColumn} REAL NOT NULL DEFAULT 0
        CHECK(${DatabaseConstants.taxPercentageColumn} >= 0),

    ${DatabaseConstants.taxAmountColumn} REAL NOT NULL DEFAULT 0
        CHECK(${DatabaseConstants.taxAmountColumn} >= 0),

    ${DatabaseConstants.totalAmountColumn} REAL NOT NULL DEFAULT 0
        CHECK(${DatabaseConstants.totalAmountColumn} >= 0),

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
    ${DatabaseConstants.costPriceAtSaleColumn} REAL,

    FOREIGN KEY (${DatabaseConstants.saleIdColumn})
        REFERENCES ${DatabaseConstants.saleTable}(${DatabaseConstants.idColumn})
        ON DELETE CASCADE,

    FOREIGN KEY (${DatabaseConstants.productIdColumn})
        REFERENCES ${DatabaseConstants.productTable}(${DatabaseConstants.idColumn})
        ON DELETE RESTRICT
);
   """);

    await db.execute("""
CREATE TABLE IF NOT EXISTS ${DatabaseConstants.stockAdjustmentsTable} (

    ${DatabaseConstants.idColumn} TEXT NOT NULL PRIMARY KEY,

    ${DatabaseConstants.reasonColumn} TEXT NOT NULL,

    ${DatabaseConstants.noteColumn} TEXT,

    ${DatabaseConstants.totalItemColumn} INTEGER NOT NULL DEFAULT 0,

    ${DatabaseConstants.totalQuantityColumn} REAL NOT NULL DEFAULT 0,

    ${DatabaseConstants.totalInventoryValueChangeColumn} REAL NOT NULL DEFAULT 0,

    ${DatabaseConstants.createdByColumn} TEXT NOT NULL DEFAULT 'Admin',

    ${DatabaseConstants.statusColumn} TEXT NOT NULL DEFAULT 'draft',

    ${DatabaseConstants.createdAtColumn} TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    ${DatabaseConstants.updatedAtColumn} TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
""");
    await db.execute("""
CREATE TABLE IF NOT EXISTS ${DatabaseConstants.stockAdjustmentItemsTable} (

    ${DatabaseConstants.idColumn} TEXT NOT NULL PRIMARY KEY,

    ${DatabaseConstants.stockAdjustmentIdColumn} TEXT NOT NULL,

    ${DatabaseConstants.productIdColumn} TEXT NOT NULL,

    ${DatabaseConstants.currentStockColumn} REAL NOT NULL
        CHECK(${DatabaseConstants.currentStockColumn} >= 0),

    ${DatabaseConstants.adjustmentQuantityColumn} REAL NOT NULL,

    ${DatabaseConstants.newStockColumn} REAL NOT NULL
        CHECK(${DatabaseConstants.newStockColumn} >= 0),

    ${DatabaseConstants.costPriceColumn} REAL NOT NULL CHECK(${DatabaseConstants.costPriceColumn} >= 0),

    ${DatabaseConstants.inventoryValueChangeColumn} REAL NOT NULL,

    ${DatabaseConstants.noteColumn} TEXT,

    FOREIGN KEY (${DatabaseConstants.stockAdjustmentIdColumn})
        REFERENCES ${DatabaseConstants.stockAdjustmentsTable}(${DatabaseConstants.idColumn})
        ON DELETE CASCADE,

    FOREIGN KEY (${DatabaseConstants.productIdColumn})
        REFERENCES ${DatabaseConstants.productTable}(${DatabaseConstants.idColumn})
        ON DELETE RESTRICT
);
""");

    await db.execute("""
CREATE TABLE IF NOT EXISTS ${DatabaseConstants.settingsTable} (

    ${DatabaseConstants.idColumn} INTEGER PRIMARY KEY
        CHECK(${DatabaseConstants.idColumn} = 1),

    ${DatabaseConstants.storeNameColumn} TEXT NOT NULL,

    ${DatabaseConstants.currencyColumn} TEXT NOT NULL DEFAULT 'EGP',

    ${DatabaseConstants.currencySymbolColumn} TEXT NOT NULL DEFAULT 'E£',

    ${DatabaseConstants.taxEnabledColumn} INTEGER NOT NULL DEFAULT 0
        CHECK(${DatabaseConstants.taxEnabledColumn} IN (0,1)),

    ${DatabaseConstants.taxPercentageColumn} REAL NOT NULL DEFAULT 14
        CHECK(${DatabaseConstants.taxPercentageColumn} >= 0),

    ${DatabaseConstants.pricesIncludeTaxColumn} INTEGER NOT NULL DEFAULT 0
        CHECK(${DatabaseConstants.pricesIncludeTaxColumn} IN (0,1)),

    ${DatabaseConstants.updatedAtColumn} TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
""");

    await _createIndexes(db);
  }

  /// Phase 3 addition. Every index is named `idx_<table>_<column(s)>` and
  /// documented with which report(s) rely on it, so a future cleanup pass
  /// can tell what's safe to drop if a report changes.
  Future<void> _createIndexes(Database db) async {
    // --- Sales / Profit reports (date-range + search + sort) ---
    // Sales/Profit WHERE clauses filter on sales.created_at; both also
    // sort on it by default.
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sales_created_at '
      'ON ${DatabaseConstants.saleTable}(${DatabaseConstants.createdAtColumn})',
    );
    // Sales screen sorts by grand_total; Profit's cost-agg subquery and
    // Stock Movement's sale-side UNION both join sale_items -> sale_id.
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sales_total_amount '
      'ON ${DatabaseConstants.saleTable}(${DatabaseConstants.totalAmountColumn})',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sale_items_sale_id '
      'ON ${DatabaseConstants.saleItemTable}(${DatabaseConstants.saleIdColumn})',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sale_items_product_id '
      'ON ${DatabaseConstants.saleItemTable}(${DatabaseConstants.productIdColumn})',
    );

    // --- Inventory Valuation / Low Stock / Out of Stock ---
    // All three filter or join on products.category_id, and Low
    // Stock/Out of Stock's threshold check reads current_stock on every
    // row scanned.
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_products_category_id '
      'ON ${DatabaseConstants.productTable}(${DatabaseConstants.categoryIdColumn})',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_products_current_stock '
      'ON ${DatabaseConstants.productTable}(${DatabaseConstants.currentStockColumn})',
    );

    // --- Low Stock / Out of Stock's correlated "last stock entry" /
    // "last sale" subqueries ---
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_stock_entry_items_product_id '
      'ON ${DatabaseConstants.stockEntryItemTable}(${DatabaseConstants.productIdColumn})',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_stock_entry_items_stock_entry_id '
      'ON ${DatabaseConstants.stockEntryItemTable}(${DatabaseConstants.stockEntryIdColumn})',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_stock_entries_receipt_date '
      'ON ${DatabaseConstants.stockEntryTable}(${DatabaseConstants.receiptDateColumn})',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_stock_entries_supplier_id '
      'ON ${DatabaseConstants.stockEntryTable}(${DatabaseConstants.supplierIdColumn})',
    );

    // --- Stock Movement's 3-way UNION + Stock Adjustment History ---
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_stock_adjustment_items_adjustment_id '
      'ON ${DatabaseConstants.stockAdjustmentItemsTable}(${DatabaseConstants.stockAdjustmentIdColumn})',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_stock_adjustment_items_product_id '
      'ON ${DatabaseConstants.stockAdjustmentItemsTable}(${DatabaseConstants.productIdColumn})',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_stock_adjustments_created_at '
      'ON ${DatabaseConstants.stockAdjustmentsTable}(${DatabaseConstants.createdAtColumn})',
    );

  }
}
