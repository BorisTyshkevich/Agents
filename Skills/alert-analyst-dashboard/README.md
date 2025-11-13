# Alert Analyst Dashboard Skill

Creates interactive HTML dashboards following Altinity corporate design standards with CDN libraries (zero token cost).

## Files Structure

- **SKILL.md** - Main skill prompt with structure, requirements, and styling guidelines
- **EDIT_MODE.md** - Complete implementation guide for drag-and-drop chart rearrangement (REQUIRED)
- **DATA_LOAD.md** - Instructions for implementing live data fetching from ClickHouse
- **DATA_EMBED.md** - Instructions for embedding static CSV data in dashboards
- **LIBRARIES.md** - Required libraries (Chart.js, PapaParse, SortableJS) and usage examples

## Usage

When user requests a dashboard:
1. Determine if they want **data loading** (fetch from API) or **data embedding** (static CSV)
2. Follow **SKILL.md** for dashboard structure and styling
3. Implement **EDIT_MODE.md** for drag-and-drop functionality (**REQUIRED**)
4. Use **LIBRARIES.md** for correct library usage patterns

## Key Requirements

- ✅ Edit mode MUST be implemented in every dashboard
- ✅ Data loader dashboards: follow DATA_LOAD.md, do NOT embed sample data
- ✅ Data embed dashboards: follow DATA_EMBED.md, embed full CSV data
- ✅ Always use optional chaining (`?.`) and nullish coalescing (`??`)
- ✅ Validate all data before use
- ✅ Use page-specific localStorage keys for layout persistence
