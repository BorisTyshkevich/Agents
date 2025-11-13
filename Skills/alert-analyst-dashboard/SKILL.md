---
name: alert-analyst-dashboard
description: Creates interactive HTML dashboards following Altinity corporate design standards. Can be used for embedding data into dashboard or coding dynamic data loader.
---

If user requested: 
- data loading -> read instructions in DATA_LOAD.md. DO NOT embed any sample data.
- data embedding -> read instructions in DATA_EMBED.md

## Structure

- **Header section:** Gradient background, centered white text, title + subtitle
- **Key Insights:** 5 most important insights from analysis. 1 sentence per insight. Only for data embedding.
- **Stats grid:** 4-column responsive grid with colored KPI-tiles (`grid-template-columns: repeat(auto-fit, minmax(200px, 1fr))`)
- **Primary full-width chart** - Main Chart.js visualization showing all data points
- **(optional) Two additional charts in grid** - Top 10 breakdowns side-by-side 
- **Controls section:** 
  - Filters using `grid-template-columns: repeat(auto-fit, minmax(250px, 1fr))`
  - Show/Hide (raw data table) button
  - Export CSV button with icon
- **Data table:** Full-width table with 
  - gradient header
  - hover effects on rows
  - sort on header click
  - collapsible (collapsed by default)
- **Data loader** 

## Implementation Requirements.  Strong. Always do all of them!

- provide meaningful explanation of the dashboard in subtitle - what data presented here?
- **ALWAYS embed static data as CSV** (unless data loader is requested)
- Use PapaParse for CSV parsing: `Papa.parse(csv, {header: true, dynamicTyping: true})`
- **Add edit mode with chart selection, Hiding, and drag-and-drop rearrangement** - See EDIT_MODE.md for complete implementation
- See LIBRARIES.md for complete JS function usage recommendations
- Never hardcode data in Stats grid. Calculate by JS code from data if needed. 
- Keep custom code minimal (~100 lines)
- **Always use optional chaining (`?.`) and nullish coalescing (`??`)** when accessing nested properties or performing operations on potentially undefined data
- **Validate CSV data immediately after parsing** - filter out incomplete rows or normalize missing fields
- **Never assume required fields exist** - the CSV may have empty cells, missing columns, or malformed data
- **Badge/class generation from data fields** - always provide fallback values for string operations (e.g., `toLowerCase()`, template literals)

## Chart Selection

Provide chart type selector for each chart - a dropdown at right upper corner.

- prefer to use Horizontal bar
- If the key string is short, use Bar Chart.
- For two keys sets - Radial gauges
- for 3+ metrics on the same space - Stacked bar
- use line overlay for dual metrics (totals vs moving average).

Suggest 6 different variants in selector. Make selector small and aligned right.

Here are some other variants (non strict):

- Bar Chart Border Radius (default for main chart)
- Horizontal bar leaderboard with color-coded severity (default for additional charts).
- Radial gauges using type: 'doughnut' plus center labels for KPI targets.
- Small multiples grid (e.g., four mini sparkline line charts) using shared config.
- Range/interval visuals: type: 'bar' with custom segment styles to show min/max.
- Real-time trend line with rolling window updates.

## Interactive Features

- Filter dropdowns populated from data
- Filter Persistence - Preserve filter selections after Apply
- Apply/Reset buttons control filtering
- CSV export functionality
- Real-time stats updates based on filtered data
- Chart updates dynamically with filters

## Edit Mode

**IMPORTANT:** Every dashboard MUST implement full edit mode functionality. See EDIT_MODE.md for complete implementation guide.

Key requirements:
- Activated via URL parameter `?edit=1`
- Drag-and-drop chart rearrangement using SortableJS
- Hide/restore chart functionality with trash zone
- Layout persistence in localStorage with page-specific keys
- Primary slot enforces single-chart capacity
- Charts resize after any layout change
- All edit controls hidden in read-only mode (default)


## Core Styling
```javascript
{
    data: {
        datasets: [{
            borderRadius: 8,        // Rounded bars/segments
            borderWidth: 0          // No borders
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        animation: { duration: 750 },
        scales: {
            grid: { color: '#f0f0f0' },
            ticks: { font: { size: 11 } }
        }
    }
}
```

### Color Palette
```javascript
const colors = ['#e74c3c', '#f39c12', '#9b59b6', '#3498db', '#1abc9c', 
                '#e67e22', '#2ecc71', '#34495e', '#16a085', '#c0392b'];
```

### Guidelines
- Use `borderRadius: 8` for all bar/doughnut charts
- Hide legend for single-dataset charts: `legend: { display: false }`
- Horizontal bars: add `indexAxis: 'y'`
- Line charts: use `tension: 0.4` for smooth curves
- Chart height: 400px (full-width) or 300px (grid items)

## Component-Specific Styling

**Layout:**
- White container with `border-radius: 16px` and `box-shadow: 0 20px 60px rgba(0,0,0,0.3)`
- Body background: purple gradient
- Padding: 40px for major sections, 20px for nested elements

### Component Patterns

**Stat Cards:**
```css
.stat-card {
    background: white;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    transition: transform 0.3s ease;
}
.stat-card:hover { transform: translateY(-5px); }

/* Value colors - apply INLINE via style attribute based on metric type */
.stat-value { font-size: 2.2em; font-weight: 700; }
```

**Color Assignment Guide:**
- Red `#e74c3c`: Errors, P1, critical issues
- Orange `#f39c12`: Warnings, P2, high priority  
- Purple `#9b59b6`: Totals, counts, aggregates
- Green `#27ae60`: Success, resolved, healthy
- Blue `#3498db`: Info, rates, percentages

*Use inline styles: `<div class="stat-value" style="color: #e74c3c;">123</div>`*

**Buttons:**
```css
.btn {
    padding: 12px 24px;
    border-radius: 8px;
    font-weight: 600;
}
.btn-primary { background: linear-gradient(135deg, #3498db 0%, #2980b9 100%); color: white; }
.btn-secondary { background: #ecf0f1; color: #2c3e50; }
```

**Tables:**
```css
thead { 
    background: linear-gradient(135deg, #34495e 0%, #2c3e50 100%); 
    color: white; 
}
tbody tr { padding: 14px 16px; }
tbody tr:hover { background: #f8f9fa; }
td, th { border: 1px solid #ecf0f1; }
```

**Badges:**
```css
.badge {
    padding: 4px 12px;
    border-radius: 12px;
    font-size: 0.85em;
    font-weight: 600;
}
.badge-p1 { background: #fee; color: #e74c3c; }
.badge-p2 { background: #fef5e7; color: #f39c12; }
.badge-success { background: #eafaf1; color: #27ae60; }
```
