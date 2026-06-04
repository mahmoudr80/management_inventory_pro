---
name: Precision Operational Interface
colors:
  surface: '#faf8ff'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#434656'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#737688'
  outline-variant: '#c3c5d9'
  surface-tint: '#004dea'
  primary: '#0041c8'
  on-primary: '#ffffff'
  primary-container: '#0055ff'
  on-primary-container: '#e3e6ff'
  inverse-primary: '#b6c4ff'
  secondary: '#505f76'
  on-secondary: '#ffffff'
  secondary-container: '#d0e1fb'
  on-secondary-container: '#54647a'
  tertiary: '#4b5053'
  on-tertiary: '#ffffff'
  tertiary-container: '#63686c'
  on-tertiary-container: '#e3e7eb'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dce1ff'
  primary-fixed-dim: '#b6c4ff'
  on-primary-fixed: '#001551'
  on-primary-fixed-variant: '#0039b3'
  secondary-fixed: '#d3e4fe'
  secondary-fixed-dim: '#b7c8e1'
  on-secondary-fixed: '#0b1c30'
  on-secondary-fixed-variant: '#38485d'
  tertiary-fixed: '#dfe3e7'
  tertiary-fixed-dim: '#c3c7cb'
  on-tertiary-fixed: '#171c1f'
  on-tertiary-fixed-variant: '#43474b'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
typography:
  display:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-caps:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  data-mono:
    fontFamily: JetBrains Mono
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 20px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 4px
  container-max: 1440px
  sidebar-width: 240px
  gutter: 16px
  margin-mobile: 16px
  margin-desktop: 32px
  table-row-height: 40px
---

## Brand & Style

This design system is engineered for operational excellence, targeting logistics managers and operations leads who require high-speed data processing and inventory accuracy. The personality is disciplined, systematic, and utilitarian, aiming to evoke a sense of "quiet efficiency."

The aesthetic draws from **Minimalism** and **Modern Corporate** styles, specifically emulating the focused density of developer tools. It prioritizes information over decoration, using ample whitespace not for luxury, but for visual separation of dense data sets. The emotional response should be one of total control and clarity, reducing cognitive load during high-stakes management tasks.

## Colors

The palette is anchored in "Operational Blue" to signify action and reliability. The system defaults to a crisp light mode for high-glare warehouse or office environments, with a high-contrast dark mode variant for extended desktop use.

- **Primary:** Used for main actions, active states, and focus indicators.
- **Secondary/Slate:** Used for secondary text, icons, and non-interactive structural elements.
- **Neutral/Surface:** A range of grays from deep charcoal (text) to ultra-light slate (backgrounds).
- **Functional Accents:** Highly saturated reds, ambers, and greens are reserved strictly for stock status indicators (Low Stock, Out of Stock, In Transit) to ensure they pop against the neutral base.

## Typography

The typography system utilizes **Inter** for its exceptional legibility in UI environments and neutral character. **JetBrains Mono** is introduced specifically for SKU numbers, quantities, and technical data to prevent character confusion (e.g., 0 vs O) during rapid scanning.

Scale is kept tight to maintain density. Hierarchy is established through font weight (SemiBold for headers) rather than drastic size increases. All numerical data in tables should use tabular figures to ensure columns align vertically for easier comparison.

## Layout & Spacing

This design system employs a **Fixed-Fluid hybrid grid**. The sidebar remains fixed at 240px, while the main content area utilizes a 12-column fluid grid for data dashboards.

- **Density:** A 4px baseline grid governs all spacing. Vertical rhythm is tight to allow more rows of inventory to be visible above the fold.
- **Breakpoints:** 
  - Mobile (<768px): Sidebar collapses into a hamburger menu; tables transition to card-list views.
  - Desktop (>1024px): Full sidebar and multi-column data views are enabled.
- **Alignment:** All data points are left-aligned, except for numerical currency or quantity values, which are right-aligned to the column header for mathematical clarity.

## Elevation & Depth

To maintain a "flat" professional look, depth is communicated through **Tonal Layers** rather than heavy shadows.

- **Level 0 (Background):** The base canvas uses a subtle off-white or light slate.
- **Level 1 (Cards/Sidebar):** Pure white surfaces with a 1px soft border (`#E2E8F0`). No shadows are used on static containers.
- **Level 2 (Dropdowns/Modals):** These floating elements use a very tight, sharp shadow (4px blur, 10% opacity) to distinguish them from the base grid without appearing "heavy."
- **Level 3 (Active State):** High-contrast primary color borders are used to indicate the currently selected input or row.

## Shapes

The shape language is "Soft" (4px - 6px), providing a modern feel while maintaining the structural integrity of a professional tool. 

- **Standard Elements:** Buttons, input fields, and checkboxes use a 4px (0.25rem) radius.
- **Large Elements:** Cards and modals use a 8px (0.5rem) radius.
- **Indicators:** Status "dots" and tag backgrounds are circular (full pill) to contrast against the predominantly rectangular grid.

## Components

### Tables (Core Component)
The central element of the system. Rows are 40px high with 1px bottom borders. Hover states use a subtle gray background (`#F8FAFC`). Columns must support "Pinning" for SKU and Name.

### Metric Cards
Used for high-level inventory KPIs (e.g., Total Value, Low Stock Count). They feature a large "Display" size number, a "Label-Caps" title, and a small trend indicator (sparkline or percentage).

### Buttons
- **Primary:** Solid "Operational Blue" with white text.
- **Secondary:** White background with a slate border.
- **Ghost:** No background/border, used for table row actions (e.g., "Edit", "View Details").

### Input Fields
Strictly rectangular with 4px radius. Inactive state: 1px border `#CBD5E1`. Focus state: 1px border `#0055FF` with a subtle 2px blue glow.

### Status Indicators
Small, high-saturation "pills."
- *Out of Stock:* Red background, white text.
- *Low Stock:* Amber background, dark amber text.
- *Healthy:* Subtle green tint with a dark green dot.

### Persistent Sidebar
A dark-themed or high-contrast slate bar on the left. Icons are 20px, stroke-based, and accompanied by 13px weight labels.