# CSV Data Embedding

Embed data as CSV in `<script type="text/csv">` tags. Use PapaParse to parse.

## Pattern (ALWAYS use this exact code)
```javascript
function loadCSV(scriptId) {
    const csv = document.getElementById(scriptId).textContent;
    const parsed = Papa.parse(csv, {
        header: true,
        dynamicTyping: true,
        skipEmptyLines: true
    });
    // CRITICAL: Normalize numeric fields immediately
    return parsed.data
        .filter(row => Object.values(row).some(v => v != null && v !== ''))
        .map(row => {
            Object.keys(row).forEach(key => {
                if (typeof row[key] === 'string' && !isNaN(row[key])) {
                    row[key] = Number(row[key]) || 0;
                }
            });
            return row;
        });
}

const data = loadCSV('myData');
```

## CSV Format
```html
<script type="text/csv" id="myData">
column1,column2,count
value1,value2,123
</script>
```

Rules:
- Header row required
- Use quotes for values with commas: `"value, with comma"`
- Empty cells become `null` (handle with `?? 0`)

## Why This Pattern

- `dynamicTyping: true` → numbers as numbers, but can produce `undefined`
- Immediate normalization → prevents `toFixed()` crashes
- Filter empty rows → PapaParse may return trailing nulls

## Key Insights
Provide the 5 most important insights from the analysis. 1 sentence per insight.
example:
```html
        <div class="insight-box">
            <h3>🔍 Key Insights</h3>
            <ul>
                <li>...</li>
...
            </ul>
        </div>
```
css:
```aiexclude
.insight-box {
            background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
            border-left: 4px solid #667eea;
            padding: 20px;
            margin: 30px 40px;
            border-radius: 8px;
        }

        .insight-box h3 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 1.2em;
        }

        .insight-box ul {
            list-style: none;
            padding-left: 0;
        }

        .insight-box li {
            padding: 8px 0;
            padding-left: 25px;
            position: relative;
        }

        .insight-box li:before {
            content: "▸";
            position: absolute;
            left: 0;
            color: #667eea;
            font-weight: bold;
        }
```