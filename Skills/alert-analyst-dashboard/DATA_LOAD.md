# Data Loader

Add live data loading functionality to dashboards. 

## Content Placement and Visibility States

**Data loader should be placed at the BOTTOM of the page**, after all visualizations.

On start hide all visualizations except Data loader and Header section by applying CSS class `.content-hidden`
After load success, show them by applying `.content-visible`

## Authentication

- **Method:** JWE token in URL path (no Bearer Auth!)
- **Storage Key:** `'Altinity-Alert-Analyst'`
- **Base URL:** `https://mcp.demo.altinity.cloud`
- **Endpoint:** `/{JWE_TOKEN}/openapi/execute_query`
- **Full URL:** `https://mcp.demo.altinity.cloud/{JWE_TOKEN}/openapi/execute_query?query=...`

## HTML code

```html
<div style="background: #ecf0f1; padding: 25px; border-radius: 12px;">
    <h4>🔌 Fetch Live Data</h4>

    <!-- API Key Input -->
    <div>
        <label>API Key (JWE Token):</label>
        <div style="display: flex; gap: 10px;">
            <input type="password" id="apiKey" placeholder="Enter your JWE token" style="flex: 1;" />
            <button class="btn btn-secondary" onclick="forgetApiKey()">🗑️ Forget</button>
        </div>
        <small>Stored in localStorage (key: 'Altinity-Alert-Analyst')</small>
    </div>

    <!-- SQL Query -->
    <div>
        <label>SQL Query:</label>
        <textarea id="sqlQuery" rows="7">SELECT * FROM table WHERE ...</textarea>
    </div>

    <!-- Fetch Button -->
    <div style="display: flex; gap: 10px;">
        <button class="btn btn-primary" onclick="fetchData()" id="fetchBtn">🔄 Fetch</button>
        <span id="loadingIndicator" class="hidden">⏳ Loading...</span>
        <span id="statusMessage"></span>
    </div>

    <div id="emptyHint" class="placeholder">
        No data loaded yet. Enter API key and SQL, then press Fetch.
    </div>
</div>
```

## Required CSS

```css
#apiKey { font-family: 'Courier New', monospace; }
button:disabled { opacity: 0.5; cursor: not-allowed; }
.placeholder { color: #2c3e50; background: #fff9e6; padding: 16px; border-radius: 8px; }
#loadingIndicator { animation: pulse 1.5s ease-in-out infinite; }
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }

/* Before data is loaded - HIDE content */
.content-hidden { display: none; }

/* After data is loaded - SHOW content */
.content-visible { display: block; animation: fadeIn 0.5s ease-in; }

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}
```

### Storage Helpers

```html
<script>
const storageKey = 'Altinity-Alert-Analyst';

const rememberApiKey = value => localStorage.setItem(storageKey, value);
const loadApiKey = () => localStorage.getItem(storageKey) ?? '';
const forgetApiKey = () => {
    localStorage.removeItem(storageKey);
    document.getElementById('apiKey').value = '';
    alert('API key removed');
};
</script>
```

### Initialize

```javascript
window.addEventListener('DOMContentLoaded', () => {
    const savedKey = loadApiKey();
    if (savedKey) document.getElementById('apiKey').value = savedKey;
});
```

### Fetch Data

```javascript
async function fetchData() {
    const apiKey = document.getElementById('apiKey').value.trim();
    const sqlQuery = document.getElementById('sqlQuery').value.trim();

    if (!apiKey || !sqlQuery) {
        alert('Please enter API key and SQL query');
        return;
    }

    const fetchBtn = document.getElementById('fetchBtn');
    const loadingIndicator = document.getElementById('loadingIndicator');
    const statusMessage = document.getElementById('statusMessage');
    const emptyHint = document.getElementById('emptyHint');

    try {
        // Disable button and show loading
        fetchBtn.disabled = true;
        loadingIndicator.classList.remove('hidden');
        statusMessage.textContent = '';

        // Save API key
        rememberApiKey(apiKey);

        const baseUrl = 'https://mcp.demo.altinity.cloud';
        const url = `${baseUrl}/${encodeURIComponent(apiKey)}/openapi/execute_query?query=${encodeURIComponent(sqlQuery)}`;
        
        const response = await fetch(url);
        const payload = await response.json().catch(() => ({}));

        if (!response.ok) {
            throw new Error(payload.error || `Request failed: ${response.status}`);
        }

        const {columns, rows} = payload;

        if (!rows || rows.length === 0) {
            throw new Error('No data returned from query');
        }

        // Transform rows to objects
        const data = rows.map(row => {
            const obj = {};
            columns.forEach((col, i) => {
                obj[col] = row[i];
            });
            return obj;
        });

        rawData = data;
        filteredData = [...data];
        
        // IMPORTANT: Hide empty hint and show content
        emptyHint.classList.add('hidden');
        document.getElementById('mainContent').classList.remove('content-hidden');
        document.getElementById('mainContent').classList.add('content-visible');
        
        updateDashboard();
        
        statusMessage.textContent = `✓ Loaded ${data.length} records`;
        statusMessage.style.color = '#27ae60';

    } catch (error) {
        console.error('Fetch error:', error);
        statusMessage.textContent = `✗ ${error.message || 'Unexpected error'}`;
        statusMessage.style.color = '#e74c3c';
    } finally {
        fetchBtn.disabled = false;
        loadingIndicator.classList.add('hidden');
    }
}
```

```

## API Response Format

```json
{
    "columns": ["field1", "field2", "field3"],
    "rows": [
        ["value1", "100", "1.5"],
        ["value2", "200", "2.5"]
    ]
}
```

## Error Handling

```json
{
    "error": "Query error: Syntax error at line 1"
}
```
