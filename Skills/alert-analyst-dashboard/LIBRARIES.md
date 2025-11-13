## Core Libraries

### Chart.js 
```html
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
```
**Purpose:** Charts and visualizations
**Docs:** https://www.chartjs.org/

### PapaParse (CSV Parsing)
```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/PapaParse/5.4.1/papaparse.min.js" integrity="sha384-D/t0ZMqQW31H3az8ktEiNb39wyKnS82iFY52QPACM+IjKW3jDUhyIgh2PApRqJZs" crossorigin="anonymous"></script>
```
**Purpose:** Parse CSV data
**Docs:** https://www.papaparse.com/

**Usage:**
```javascript
const csv = document.getElementById('data').textContent;
const parsed = Papa.parse(csv, {
    header: true,
    dynamicTyping: true,  // Auto-convert numbers
    skipEmptyLines: true
});
const data = parsed.data;
```

### SortableJS (Drag & Drop)
```html
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
```
**Purpose:** Drag-and-drop layout editing, trash-zone hide gestures  
**Docs:** https://sortablejs.github.io/Sortable/

**Usage (only when `?edit=1`):**
```javascript
const isEditMode = new URLSearchParams(location.search).get('edit') === '1';

if (isEditMode && window.Sortable) {
    const baseOptions = {
        group: 'charts',
        animation: 200,
        handle: '.chart-header',
        draggable: '.chart-card',
        ghostClass: 'chart-card--ghost',
        dragClass: 'chart-card--dragging',
        fallbackOnBody: true,
        swapThreshold: 0.6,
        onStart(evt) {
            showTrash();
            evt.item.dataset.originContainerId = evt.from?.id || '';
            evt.item.dataset.originIndex = evt.oldIndex ?? '';
        },
        onEnd(evt) {
            hideTrash();
            delete evt.item.dataset.originContainerId;
            delete evt.item.dataset.originIndex;
        },
        onAdd() { refreshLayout(); },
        onUpdate() { refreshLayout(); }
    };

    Sortable.create(document.getElementById('primarySlot'), baseOptions);
    Sortable.create(document.getElementById('secondaryGrid'), baseOptions);

    Sortable.create(document.getElementById('chartTrash'), {
        group: { name: 'charts', pull: false, put: true },
        animation: 150,
        sort: false,
        onAdd(evt) {
            hideChart(evt.item, { skipConfirm: false });
        }
    });
}
```

### Utility Snippets (Native JS)
Use built-in array helpers directly, or drop in this lightweight helper object when dashboards need grouping or aggregation without extra dependencies.

```javascript
const utils = {
    groupBy(list, key) {
        return list.reduce((acc, item) => {
            (acc[item[key]] ||= []).push(item);
            return acc;
        }, {});
    },
    sumBy(list, key) {
        return list.reduce((sum, item) => sum + Number(item[key] ?? 0), 0);
    },
    uniq(list) {
        return [...new Set(list)];
    },
    orderBy(list, key, direction = 'desc') {
        const sorted = [...list].sort((a, b) => {
            const left = a[key] ?? 0;
            const right = b[key] ?? 0;
            return direction === 'asc' ? left - right : right - left;
        });
        return sorted;
    }
};
```

## Quick Reference

### CSV Parsing
```javascript
// From script tag
const csv = document.getElementById('data').textContent;
const data = Papa.parse(csv, {header: true, dynamicTyping: true}).data;
```

### Filtering
```javascript
// Single condition
const p1Alerts = data.filter(row => row.priority === 'P1');

// Multiple conditions
const filtered = data.filter(row =>
    row.priority === 'P1' && row.cluster.includes('prod')
);
```

### Sorting
```javascript
// Ascending
const sorted = [...data].sort((a, b) => (a.count ?? 0) - (b.count ?? 0));

// Descending
const sortedDesc = [...data].sort((a, b) => (b.count ?? 0) - (a.count ?? 0));

// Multiple fields
const sortedMulti = [...data].sort((a, b) => {
    if (a.priority === b.priority) {
        return (b.count ?? 0) - (a.count ?? 0);
    }
    return a.priority.localeCompare(b.priority);
});
```

### Grouping
```javascript
// Group by field
const byCluster = utils.groupBy(data, 'cluster');
// Result: {cluster1: [...], cluster2: [...]}

// Count by field
const counts = Object.fromEntries(
    data.reduce((map, row) => {
        map.set(row.priority, (map.get(row.priority) ?? 0) + 1);
        return map;
    }, new Map())
);
```

### Aggregation
```javascript
const sum = utils.sumBy(data, 'count');                    // Sum
const average = sum / (data.length || 1);                  // Average
const max = data.reduce((top, row) =>
    (row.count ?? -Infinity) > (top?.count ?? -Infinity) ? row : top
, null);                                                   // Max object
const min = data.reduce((bottom, row) =>
    (row.count ?? Infinity) < (bottom?.count ?? Infinity) ? row : bottom
, null);                                                   // Min object
```

### Unique Values
```javascript
// For dropdowns
const clusters = [...new Set(data.map(d => d.cluster))].sort();
const priorities = [...new Set(data.map(d => d.priority))];
```
