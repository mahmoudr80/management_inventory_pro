# Flutter Desktop Responsive UI & Design Guidelines

This document lists the rules and guidelines to follow when refactoring any feature for responsiveness, layout flexibility, and design system integration on Flutter Desktop.

---

## 🛠 Responsibilities for Every Refactored Feature

1. **Analyze the Widget Tree**: Detect potential layout bottlenecks, rigid components, or fixed sizes.
2. **Eliminate Overflow Risks**: Verify that views behave cleanly on heights down to **600px** and widths down to **900px**.
3. **Thematic Consistency**: Ensure colors, typography, spacing, and dimensions use definitions from the `core/theme` folder instead of hardcoded values.
4. **Preserve Functionality**: Never modify business logic, Cubits, BLoCs, repositories, API calls, or routing mechanisms.

---

## 📐 Responsive Principles

### Preferred Widgets
* **LayoutBuilder**: Detect available parent constraints (maxWidth / maxHeight) and swap widgets dynamically.
* **Wrap**: Use instead of rigid `Row`/`Column` for wrapping dynamic actions, filters, or chips.
* **Flexible / Expanded**: Ensure cells, text columns, or panels fill available space proportionally.
* **ConstrainedBox / FractionallySizedBox**: Cap maximum width/height so elements don't stretch excessively on ultrawide monitors (up to 2560×1440).
* **SingleChildScrollView + Scrollbar**: Always wrap list/table columns in horizontal or vertical scroll areas if they could potentially exceed small window bounds.
* **Tooltip**: Wrap text variables, longer text blocks, or potentially overflowing text (with `TextOverflow.ellipsis`) in a `Tooltip` so users can hover to read the full value if it gets truncated on smaller screen widths.

### Avoid
* Fixed heights/widths on containers unless necessary for standard size icons.
* Hardcoded magic numbers for spacing.
* Non-scrollable forms or vertical scroll containers nested without `shrinkWrap: true` or `NeverScrollableScrollPhysics` in scrollable pages.

---

## 🎨 Design System & Theme Integration (`core/theme/`)

Always use the variables defined in `core/theme/` for all dimensions, colors, typography, and spaces:

### 1. Spacing & Paddings (`AppSpacing`)
* Use `AppSpacing.md` (12), `AppSpacing.lg` (16), `AppSpacing.xl` (24), etc. instead of hardcoded sizes.
* Maintain proportion: do not use random numbers like `17`, `21`, etc.

### 2. Colors (`AppColors`)
* **Primary Branding**: `AppColors.primary`, `AppColors.onPrimary`
* **Secondary Slate**: `AppColors.secondary`, `AppColors.onSecondary`
* **Surfaces**: `AppColors.surface`, `AppColors.surfaceContainerLow`, `AppColors.surfaceContainerLowest`
* **Accents**:
  * **Success**: `AppColors.success`, `AppColors.successContainer`, `AppColors.statusHealthyDot`
  * **Warning**: `AppColors.warning`, `AppColors.warningContainer`, `AppColors.onWarningContainer`
  * **Error**: `AppColors.error`, `AppColors.errorContainer`

### 3. Typography & Fonts (`AppTextStyles`)
* **Display/Large Titles**: `AppTextStyles.display`
* **Headlines**: `AppTextStyles.headlineMd`, `AppTextStyles.headlineSm`
* **Body Texts**: `AppTextStyles.bodyLg`, `AppTextStyles.bodyMd`, `AppTextStyles.bodySm`
* **Labels / Small Caps**: `AppTextStyles.labelCaps`
* **Data / Code / Monospace**: `AppTextStyles.dataMono`
* Use `.copyWith(fontSize: ...)` clamped with `fontSize.clamp(min, max)` if fonts need dynamic scaling.

### 4. Borders & Radius (`AppRadius`, `AppBorder`)
* **Radius**: `AppRadius.sm` (4), `AppRadius.standard` (6), `AppRadius.md` (8), `AppRadius.lg` (12)
* **Borders**: Use `AppDecorations.card()` or `AppDecorations.inputField()` for standard decorators.

---

## 📊 Desktop Sizes to Support

* **900×600** (Minimum Supported)
* **1024×768**
* **1280×720**
* **1366×768**
* **1600×900**
* **1920×1080**
* **2560×1440**
