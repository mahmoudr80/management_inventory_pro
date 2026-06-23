class DatabaseConstants {

  //tables
  static const String productTable = "products";
  static const String categoryTable = "categories";
  static const String unitTable = "units";
  static const String supplierTable = "suppliers";
  static const String stockEntryTable = "stock_entries";
  static const String stockEntryItemTable= "stock_entry_items";
  static const String saleTable= "sales";
  static const String saleItemTable= "sale_items";

  //columns
  static const String idColumn = "id";
  static const String nameColumn = "name";
  static const String barcodeColumn = "barcode";
  static const String skuColumn = "sku";
  static const String categoryIdColumn = "category_id";
  static const String unitIdColumn = "unit_id";
  static const String costPriceColumn = "cost_price";
  static const String sellingPriceColumn = "selling_price";
  static const String minimumStockColumn = "min_stock";
  static const String imageUrlColumn = "image_url";
  static const String noteColumn = "note";
  static const String createdAtColumn = "created_at";
  static const String updatedAtColumn = "updated_at";
  static const String receiptDateColumn = "receipt_date";
  static const String currentStockColumn = "current_stock";
  static const String symbolColumn = "symbol";//units table
  static const String quantityColumn = "quantity";//stock entry table
  static const String supplierIdColumn = "supplier_id";//stock entry table
  static const String productIdColumn = "product_id";//stock entry items table
  static const String stockEntryIdColumn = "stock_entry_id";
  static const String totalItemColumn = "total_items";
  static const String totalQuantityColumn = "total_quantity";
  static const String totalCostColumn = "total_cost";
  static const String totalColumn = "total";
  static const String totalAmountColumn = "total_amount"; //sale table
  static const String saleIdColumn = "sale_id"; //sale table


  //supplier table
  static const String companyNameColumn = "company_name";
  static const String phoneColumn = "phone";
  static const String emailColumn = "email";
  static const String addressColumn = "address";


  //Alias
  static const String productNameAlias = "product_name";
  static const String categoryNameAlias = "category_name";
  static const String unitNameAlias = "unit_name";
  static const String supplierNameAlias = "supplier_name";
  static const String lineIdAlias = "line_id";


}
