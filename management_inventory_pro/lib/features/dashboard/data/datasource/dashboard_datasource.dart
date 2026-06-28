 import 'package:management_inventory_pro/core/database/database_constants.dart';
  import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/dashboard_model.dart';
import '../models/dashboard_summary.dart';
import '../models/low_stock_product.dart';
import '../models/recent_sale.dart';
import '../models/recent_stock_entry.dart';
import '../models/top_selling_product.dart';

  class DashboardDatasource {
    final Database _database;

    const DashboardDatasource(this._database);

    Future<double> _getPercentageRevenue()async{
    try{
      final double today =await _getRevenuesByDate(DateTime.now());
      final double yesterday =await _getRevenuesByDate(DateTime.now().subtract(const Duration(days: 1)));
      print('today $today');
      print('yesterday $yesterday');
      if(yesterday==0){return -1;}
      final double percentage =  ((today-yesterday)/yesterday)*100;
      return percentage;
    }catch(e){
      print(e.toString());
      return -1;
    }
    }
    Future<double> _getAvgOrderValue() async {
      final double todayRevenue = await _getRevenuesByDate(DateTime.now());
      final totalOrders = await _getTodayOrders();
      final avg = todayRevenue/totalOrders;
      print('avg: $avg');
      return avg;
    }
    Future<double> _getRevenuesByDate(DateTime date) async {
      try{
      final DateTime today = DateTime.now();

      final int days = today.difference(date).inDays;
      final query = '''
  SELECT
      COALESCE(
          SUM(
              ${DatabaseConstants.saleItemTable}.${DatabaseConstants.quantityColumn} *
              ${DatabaseConstants.saleItemTable}.${DatabaseConstants.sellingPriceColumn}
          ),
          0
      ) AS ${DatabaseConstants.totalRevenue}
  
  FROM ${DatabaseConstants.saleItemTable}
  
  INNER JOIN ${DatabaseConstants.saleTable}
  ON ${DatabaseConstants.saleTable}.${DatabaseConstants.idColumn} =
     ${DatabaseConstants.saleItemTable}.${DatabaseConstants.saleIdColumn}
  
  WHERE DATE(${DatabaseConstants.saleTable}.${DatabaseConstants.updatedAtColumn}) =
        DATE('now', '-$days day');
  ''';
        final response=  await _database.rawQuery(query);
        print('revenues: ${response.firstWhere((element) => element.containsKey(DatabaseConstants.totalRevenue),).toString()}');
        final revenue= response.firstWhere((element) => element.containsKey(DatabaseConstants.totalRevenue),);
        return double.tryParse(revenue[DatabaseConstants.totalRevenue].toString())??-1;
      }catch(e){
        print(e.toString());
        return -1;
      }
    }
    Future<List<double>>_getRevenuesBetweenTwoDates(DateTime fromDate,DateTime toDate) async {
      List<double> revenues=[];
       while(fromDate.isBefore(toDate)){
          final double revenue = await _getRevenuesByDate(fromDate);
          revenues.add(revenue);
          fromDate=fromDate.add(Duration(days: 1));
       }
       return revenues;
    }
    Future<int> _getTodayOrders() async {
      return await _getOrdersByDate(DateTime.now());
    }
    Future<List<int>>_getOrdersBetweenTwoDates(DateTime fromDate,DateTime toDate) async {
      List<int> orders=[];
      while(fromDate.isBefore(toDate)){
        final int order = await _getOrdersByDate(fromDate);
        orders.add(order);
        fromDate=fromDate.add(Duration(days: 1));
      }
      return orders;
    }
    Future<int> _getOrdersByDate(DateTime date) async {
      try{
        final DateTime today = DateTime.now();

        final int days = today.difference(date).inDays;
        final response=  await _database.rawQuery('''
      SELECT count(*) as ${DatabaseConstants.totalOrders} from ${DatabaseConstants.saleTable}
  where Date(${DatabaseConstants.saleTable}.${DatabaseConstants.updatedAtColumn})=Date('now','-$days day');
      ''');
        print('orders: ${response.firstWhere((element) => element.containsKey(DatabaseConstants.totalOrders),).toString()}');
        final orders= response.firstWhere((element) => element.containsKey(DatabaseConstants.totalOrders),);
        return int.tryParse(orders[DatabaseConstants.totalOrders].toString())??-1;
      }catch(e){
        print(e.toString());
        return -1;
      }
    }
    Future<int> _getTotalProducts() async {
      try{
      final response=  await _database.rawQuery('''
      SELECT count(*) as  ${DatabaseConstants.totalProducts}  from ${DatabaseConstants.productTable};
      ''');
      print('total Products: ${response.firstWhere((element) => element.containsKey(DatabaseConstants.totalProducts),).toString()}');
     final products = response.firstWhere((element) => element.containsKey(DatabaseConstants.totalProducts),);
     return int.tryParse(products[DatabaseConstants.totalProducts].toString())??-1;
      }catch(e){
        print(e.toString());
        return -1;
      }
    }
    Future<int> _getNumberOfCategories() async {
      String query='''
      SELECT COUNT(*) as ${DatabaseConstants.totalCategories}
  FROM ${DatabaseConstants.categoryTable};''';
      final response=  await _database.rawQuery(query);
      final categories = response.firstWhere((element) => element.containsKey(DatabaseConstants.totalCategories),);
      print(categories[DatabaseConstants.totalCategories]);
      return int.tryParse(categories[DatabaseConstants.totalCategories].toString())??-1;
    }
    Future<int> _getTotalLowStockProducts() async {
      try{
      final response=  await _database.rawQuery('''
      SELECT count(*) as ${DatabaseConstants.totalLowStockProducts} from ${DatabaseConstants.productTable}
  where ${DatabaseConstants.minimumStockColumn}>=${DatabaseConstants.currentStockColumn};
  
      ''');
      print('lowStock: ${response.firstWhere((element) => element.containsKey(DatabaseConstants.totalLowStockProducts),).toString()}');
      final totalLowStock=response.firstWhere((element) => element.containsKey(DatabaseConstants.totalLowStockProducts));
      return int.tryParse(totalLowStock[DatabaseConstants.totalLowStockProducts].toString())??-1;
      }catch(e){
        print(e.toString());
        return -1;
      }
    }
    Future<num> _getInventoryValue() async {
      try{
      final response=  await _database.rawQuery('''
      SELECT sum(${DatabaseConstants.costPriceColumn}*${DatabaseConstants.currentStockColumn}) as 
      ${DatabaseConstants.inventoryValue} from ${DatabaseConstants.productTable};
      ''');
      print('inventory Value: ${response.firstWhere((element) => element.containsKey(DatabaseConstants.inventoryValue),).toString()}');
        final inventoryValue=response.firstWhere((element) => element.containsKey(DatabaseConstants.inventoryValue));
        return num.tryParse(inventoryValue[DatabaseConstants.inventoryValue].toString())??-1;
      }catch(e){
        print(e.toString());
        return -1;
      }
    }
    Future<List<TopSellingProductRef>>_getTopSellingProducts() async {
      try{
      final response=  await _database.rawQuery('''
      SELECT
      p.${DatabaseConstants.idColumn},
      p.${DatabaseConstants.nameColumn},
      p.${DatabaseConstants.skuColumn},
      SUM(si.${DatabaseConstants.quantityColumn}) AS ${DatabaseConstants.unitSold},
      SUM(si.${DatabaseConstants.totalColumn}) AS ${DatabaseConstants.revenue},
      SUM(si.${DatabaseConstants.totalColumn}) - (p.${DatabaseConstants.costPriceColumn} *
       SUM(si.${DatabaseConstants.quantityColumn})) AS ${DatabaseConstants.profit}
  FROM ${DatabaseConstants.saleItemTable} si
  INNER JOIN ${DatabaseConstants.productTable} p
      ON p.${DatabaseConstants.idColumn} = si.${DatabaseConstants.productIdColumn}
  GROUP BY p.${DatabaseConstants.idColumn}, p.${DatabaseConstants.nameColumn}, p.${DatabaseConstants.skuColumn}
  ORDER BY ${DatabaseConstants.unitSold} DESC
  LIMIT 5;
      
      ''');
      print('selling products :');
      response.forEach((element) => print(element.toString()),);

      return response
          .map((e) => TopSellingProductRef.fromMap(e))
          .toList();
      }catch(e){
        print(e.toString());
        return [];
      }
    }
    Future<List<LowStockProductRef>> _getLowStockProducts() async {
      try{
        final response=  await _database.rawQuery('''
        SELECT * from ${DatabaseConstants.productTable}
  where ${DatabaseConstants.minimumStockColumn}>=${DatabaseConstants.currentStockColumn};
      ''');
        print('lowStock:');
        response.forEach((element) => print(element.toString()),);
        return response
            .map((e) => LowStockProductRef.fromMap(e))
            .toList();
      }catch(e){
        print(e.toString());
        return [];
      }
    }
    Future<List<RecentSaleRef>> _getRecentSales() async {
      try{
        final response=  await _database.rawQuery('''
        SELECT
      -- Sale
      s.${DatabaseConstants.idColumn} AS ${DatabaseConstants.saleIdColumn},
      s.${DatabaseConstants.totalItemColumn},
      s.${DatabaseConstants.totalQuantityColumn},
      s.${DatabaseConstants.totalAmountColumn},
      s.${DatabaseConstants.noteColumn},
      s.${DatabaseConstants.paymentMethodColumn},
      s.${DatabaseConstants.cashierNameColumn},
      s.${DatabaseConstants.statusColumn},
      s.${DatabaseConstants.createdAtColumn},
      s.${DatabaseConstants.updatedAtColumn},
  
      -- Sale Item
      si.${DatabaseConstants.idColumn} AS ${DatabaseConstants.saleItemId},
      si.${DatabaseConstants.productIdColumn},
      si.${DatabaseConstants.quantityColumn},
      si.${DatabaseConstants.sellingPriceColumn},
      si.${DatabaseConstants.totalColumn},
  
      -- Product
      p.${DatabaseConstants.nameColumn},
      p.${DatabaseConstants.skuColumn},
      p.${DatabaseConstants.barcodeColumn},
      p.${DatabaseConstants.imageUrlColumn},
      p.${DatabaseConstants.sellingPriceColumn} AS ${DatabaseConstants.productPrice}
  
  FROM ${DatabaseConstants.saleTable} s
  
  INNER JOIN ${DatabaseConstants.saleItemTable} si
      ON si.${DatabaseConstants.saleIdColumn} = s.${DatabaseConstants.idColumn}
  
  INNER JOIN ${DatabaseConstants.productTable} p
      ON p.${DatabaseConstants.idColumn} = si.${DatabaseConstants.productIdColumn}
  
  ORDER BY s.${DatabaseConstants.createdAtColumn} DESC;
     
      ''');
        print('Recent Sales:');
        response.forEach((element) => print(element.toString()),);

        final Map<String, RecentSaleRef> sales = {};

        for (final row in response) {
          final saleId = row[DatabaseConstants.saleIdColumn] as String;

          if (!sales.containsKey(saleId)) {
            sales[saleId] = RecentSaleRef.fromMap(row);
          }

          sales[saleId]!.items.add(
            RecentSaleItemRef.fromMap(row),
          );
        }

        return sales.values.toList();
      }catch(e){
        print(e.toString());
        return [];
      }
    }
    Future<List<RecentStockEntryRef>>  _getRecentStockEntry() async {
      try{
        final response=  await _database.rawQuery('''
        SELECT
      -- Stock Entry
      se.${DatabaseConstants.idColumn} AS ${DatabaseConstants.stockEntryIdColumn},
      se.${DatabaseConstants.supplierIdColumn},
      se.${DatabaseConstants.receiptDateColumn},
      se.${DatabaseConstants.noteColumn},
      se.${DatabaseConstants.totalItemColumn},
      se.${DatabaseConstants.totalQuantityColumn},
      se.${DatabaseConstants.totalCostColumn},
      se.${DatabaseConstants.createdAtColumn},
      se.${DatabaseConstants.updatedAtColumn},
  
      -- Supplier
      sup.${DatabaseConstants.companyNameColumn},
  
      -- Stock Entry Item
      sei.${DatabaseConstants.idColumn} AS ${DatabaseConstants.lineIdAlias},
      sei.${DatabaseConstants.productIdColumn},
      sei.${DatabaseConstants.quantityColumn},
      sei.${DatabaseConstants.costPriceColumn},
      sei.${DatabaseConstants.totalColumn},
  
      -- Product
      p.${DatabaseConstants.nameColumn} AS ${DatabaseConstants.productNameAlias},
      p.${DatabaseConstants.skuColumn},
      p.${DatabaseConstants.barcodeColumn},
      p.${DatabaseConstants.imageUrlColumn},
      p.${DatabaseConstants.unitIdColumn},
  
      -- Unit
      u.${DatabaseConstants.nameColumn} AS ${DatabaseConstants.unitNameAlias}
  
  FROM ${DatabaseConstants.stockEntryTable} se
  
  INNER JOIN ${DatabaseConstants.supplierTable} sup
      ON sup.${DatabaseConstants.idColumn} = se.${DatabaseConstants.supplierIdColumn}
  
  INNER JOIN ${DatabaseConstants.stockEntryItemTable} sei
      ON sei.${DatabaseConstants.stockEntryIdColumn} = se.${DatabaseConstants.idColumn}
  
  INNER JOIN ${DatabaseConstants.productTable} p
      ON p.${DatabaseConstants.idColumn} = sei.${DatabaseConstants.productIdColumn}
  
  INNER JOIN ${DatabaseConstants.unitTable} u
      ON u.${DatabaseConstants.idColumn} = p.${DatabaseConstants.unitIdColumn}
  
  ORDER BY se.${DatabaseConstants.receiptDateColumn} DESC
  
  LIMIT 10;
        
      ''');
        print('Recent Stock Entry:');
        response.forEach((element) => print(element.toString()),);
        final Map<String, RecentStockEntryRef> entries = {};

        for (final row in response) {
          final id = row[DatabaseConstants.stockEntryIdColumn] as String;

          entries.putIfAbsent(
            id,
                () => RecentStockEntryRef.fromMap(row),
          );

          entries[id]!.items.add(
            RecentStockEntryLineRef.fromMap(row),
          );
        }

        return entries.values.toList();
      }catch(e){
        print(e.toString());
        return [];
      }
    }
    Future<List<double>> _getWeeklyRevenue() {
      final now = DateTime.now();

      return _getRevenuesBetweenTwoDates(
        DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6)),
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
      );
    }

    Future<List<double>> _getWeeklyOrders() async {
      final now = DateTime.now();

      final orders = await _getOrdersBetweenTwoDates(
        DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6)),
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
      );

      return orders.map((e) => e.toDouble()).toList();
    }
    Future<DashboardSummary> _getSummary() async {
      final results = await Future.wait([
        _getRevenuesByDate(DateTime.now()),
        _getRevenuesByDate(DateTime.now().subtract(const Duration(days: 1))),
        _getTodayOrders(),
        _getAvgOrderValue(),
        _getTotalProducts(),
        _getNumberOfCategories(),
        _getTotalLowStockProducts(),
        _getInventoryValue(),
        _getPercentageRevenue(),
      ]);

      return DashboardSummary(
        todayRevenue: results[0] as double,
        yesterdayRevenue: results[1] as double,
        todayOrders: results[2] as int,
        avgOrderValue: results[3] as double,
        totalProducts: results[4] as int,
        activeCategories: results[5] as int,
        lowStockCount: results[6] as int,
        inventoryValue: (results[7]).toDouble(),
        inventoryTurnoverChange: results[8] as double,
      );
    }
    Future<DashboardModel> getDashboard() async {
      final results = await Future.wait([
        _getSummary(),
        _getTopSellingProducts(),
        _getLowStockProducts(),
        _getRecentSales(),
        _getRecentStockEntry(),
        _getWeeklyRevenue(),
        _getWeeklyOrders(),
      ]);

      return DashboardModel(
        summary: results[0] as DashboardSummary,
        topSellingProducts: results[1] as List<TopSellingProductRef>,
        lowStockProducts: results[2] as List<LowStockProductRef>,
        recentSales: results[3] as List<RecentSaleRef>,
        recentStockEntries: results[4] as List<RecentStockEntryRef>,
        weeklyRevenue: results[5] as List<double>,
        weeklyOrders: results[6] as List<double>, businessInsights: [],
      );
    }

  }