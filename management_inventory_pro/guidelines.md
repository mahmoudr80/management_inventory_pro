> [!IMPORTANT]
> ALWAYS review these rules before performing any task. Do not skip this step.

# FLUTTER RULES

## 1. PACKAGES
- Use only if Flutter lacks a built-in solution or it significantly boosts performance, maintainability, or scalability.
- Use latest stable, actively maintained packages. Avoid deprecated/abandoned ones.

## 2. RESPONSIVE (Scale) & ADAPTIVE (Layout)
- **Responsive**: Use `flutter_screenutil` (`.w`, `.h`, `.r`, `.sp`). No raw pixels.
- **Adaptive**: Use `MediaQuery`/`LayoutBuilder` for tablet/desktop (e.g., `isTablet ? Row : Column`).
- **Flexible UI**: Prefer `Expanded`, `Flexible`, `Spacer`. Avoid fixed widths/heights.
- **Overflow Safety**: `Text` MUST have `maxLines` + `TextOverflow.ellipsis`. Use `ListView`/`SingleChildScrollView` for scrollable content.
- **Tablet/Desktop**: Increase spacing, use multi-column layouts, avoid stretched mobile UI.

## 3. CORE LAYER
- **Purpose**: App-wide, reusable, feature-independent infrastructure ONLY.
- `network/`: ApiHelper, DioFactory, ApiResult, interceptors.
- `theme/`: AppColor, AppTextStyle, ThemeData.
- `widgets/`: Shared UI (buttons, loaders, dialogs).
- `utils/`: Helpers, validators, formatters.
- `storage/`: Local/secure storage.
- `routes/`: Routing constants.
- `dependency_injection/`: `get_it` registrations.
- **Strict Rule**: NEVER place feature-specific logic (e.g., Auth models, Cart logic) in `core/`.

## 4. SCREEN & WIDGET DECOMPOSITION
- **Screens**: Lightweight layout containers, Bloc connectors, and navigation handlers ONLY.
- **Widget Extraction**: Move UI blocks to separate files if >15-20 lines, reusable, or having a distinct responsibility.
- **Clean Structure**: Avoid monolithic screens (>500 lines) and deeply nested trees. Prefer a composable structure: Screen -> Section Widget -> Item Widget.
