# OmniStock ERP Architecture & Technical Specification

## 1. System Architecture: Clean Architecture (Feature-First)
We will follow a modular, feature-first Clean Architecture to ensure scalability and testability.

### Folder Structure
```text
lib/
├── core/                        # Cross-cutting concerns
│   ├── components/              # Atomic UI components (Buttons, Inputs, Tables)
│   ├── design_system/           # Tokens, Themes (Precision Operational Interface)
│   ├── error/                   # Failure and Exception classes
│   ├── network/                 # Connectivity and Supabase clients
│   ├── storage/                 # Sqflite database and local preferences
│   ├── sync/                    # Global sync engine and queue management
│   └── utils/                   # Formatters, Validators, Extensions
├── features/                    # Domain-specific modules
│   ├── inventory/               # Core Stock Movement Engine
│   │   ├── data/                # Repositories, Data Sources (Local/Remote), Models
│   │   ├── domain/              # Entities, Use Cases, Repository Interfaces
│   │   └── presentation/        # Blocs, Screens, Widgets
│   ├── pos/                     # High-Speed Transaction Module
│   ├── procurement/             # Purchase Orders and Receiving
│   ├── logistics/               # Warehouse Management and Transfers
│   └── settings/                # Business and User Configuration
└── main.dart                    # App initialization and dependency injection
```

## 2. Inventory Domain Modeling: The Movement Engine
Quantity is a **derived value**, never a direct field in the database.

### Core Entity: `StockMovement`
```dart
class StockMovement {
  final String id;
  final String skuId;
  final String warehouseId;
  final double quantityChange; // Positive for Inbound, Negative for Outbound
  final MovementType type;     // SALE, PURCHASE, TRANSFER, ADJUSTMENT, RETURN
  final String userId;
  final DateTime timestamp;
  final String? referenceId;   // Link to Order ID, PO ID, or Transfer ID
  final Map<String, dynamic>? metadata; // Batch/Lot info, Reason codes
}
```

## 3. Database Schema (PostgreSQL & Supabase)
Optimized for multi-tenancy and auditability.

### Key Relationships
- **Businesses (Tenants):** Top-level container.
- **Warehouses:** Belongs to Business.
- **Products & Variants:** SKU-level tracking.
- **StockMovements:** The source of truth for all inventory levels.
- **SyncQueue:** Tracks local changes pending upload.

```sql
-- Inventory Calculation View
CREATE VIEW warehouse_stock AS
SELECT 
  sku_id, 
  warehouse_id, 
  SUM(quantity_change) as on_hand
FROM stock_movements
GROUP BY sku_id, warehouse_id;
```

## 4. Offline-First Sync Strategy
We use a **Local-First** approach: all writes hit `sqflite` first, then queue for Supabase.

### Sync Flow
1. **Action:** User creates a Stock Adjustment.
2. **Local Write:** Save to `sqflite.stock_movements` + `sqflite.sync_queue` (Operation: INSERT).
3. **Optimistic UI:** Update local state via Bloc immediately.
4. **Sync Engine:** Background process picks up `sync_queue` items.
5. **Remote Write:** Execute Supabase RPC.
6. **Confirmation:** On success, remove from `sync_queue` and update `last_synced_at`.

### Conflict Handling
- **Last Write Wins (Default):** For simple profile updates.
- **Append-Only (Inventory):** Since we use movements, conflicts are minimized (quantities are cumulative, not absolute overrides).

## 5. Reusable ERP Component Strategy
- **`ErpDataTable`:** Generic, paginated table with sticky headers, multi-select, and row-level actions.
- **`OperationalCommandPalette`:** Global overlay for fast search and navigation.
- **`SyncIndicator`:** Status bar widget showing real-time connectivity and queue depth.

## 6. State Management: Bloc/Cubit
- **Feature Blocs:** (e.g., `InventoryBloc`) handle complex domain logic.
- **Sync Cubit:** Monitors the global synchronization state.
- **Auth Bloc:** Manages session and multi-tenant context.
