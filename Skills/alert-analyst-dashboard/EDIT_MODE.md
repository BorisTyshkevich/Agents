# Edit Mode

Activate with `?edit=1`. Primary slot allows only 1 chart, enforced by swapping displaced chart to origin.

## Key Implementation Points

**DOM IDs needed:**
- `primarySlot`, `secondaryGrid`, `chartTrash`, `hiddenCharts`, `restoreHiddenBtn`

**Chart cards need:**
- `data-chart-id="uniqueId"`
- `.chart-card`, `.chart-header` (drag handle)
- Hide button: `<button data-chart-action="hide" data-chart-target="chartId">✕</button>`

**CSS for body.edit-mode:**
```css
body.edit-mode .btn-hide { display: inline-block; }
body.edit-mode .chart-header { cursor: grab; }
.chart-card--ghost { opacity: 0.3; }
.chart-card--dragging { transform: rotate(3deg); box-shadow: 0 8px 20px rgba(0,0,0,0.3); }
.chart-card--hidden { display: none !important; }
.chart-trash { position: fixed; bottom: 30px; right: 30px; display: none; }
.chart-trash.active { display: flex; }
```

**Core logic:**
```javascript
const isEditMode = new URLSearchParams(location.search).get('edit') === '1';
const layoutStorageKey = 'uniqueDashboardId::layout';
const defaultLayout = { primary: ['chart1'], secondary: ['chart2', 'chart3'], hidden: [] };

// On load: body.classList.toggle('edit-mode', isEditMode); loadLayout(); initDragAndDrop();

function enforcePrimaryCapacity(evt) {
    if (evt?.to !== primarySlot || primarySlot.children.length <= 1) return;
    const displaced = [...primarySlot.children].find(c => c !== evt.item);
    (evt.from !== trashZone ? evt.from : secondaryGrid)?.appendChild(displaced);
}

Sortable.create(primarySlot, {
    group: 'charts', handle: '.chart-header', onAdd: enforcePrimaryCapacity, onEnd: refreshLayout
});
```

**Trash drop:** Confirm before `hideChart()`, else `revertCardToOrigin()`
**Layout persistence:** `localStorage.setItem(layoutStorageKey, JSON.stringify(layout))`
**Resize charts:** Call `chartInstance.resize()` in `requestAnimationFrame` after layout changes