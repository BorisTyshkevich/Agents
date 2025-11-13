# Repository Guidelines

## Project Structure & Module Organization
- Root Markdown files capture the entire skill: `SKILL.md` (capabilities), `LIBRARIES.md` (CDN usage), `DATA_EMBED.md` (embedded data), `DATA_LOADING.md` (live data), and `README.md` (quick start). Extend these rather than creating parallel docs.
- Place any new HTML or CSV samples beside the docs they illustrate, and cross-link them so agents can find updates quickly.

## Build, Test, and Development Commands
- No build pipeline is required; dashboards run as static HTML. Open examples directly in the browser while iterating.
- `python3 -m http.server 8000` from a scratch directory to preview bundled HTML/CSS/JS in a local tab.
- `npx prettier@latest --check "**/*.md" "**/*.html"` before pushing to keep Markdown and snippets aligned with our formatting.

## Coding Style & Naming Conventions
- Mirror the existing heading hierarchy (`#` title, `##` primary sections, optional `###` for focused callouts) and keep sections short.
- JavaScript examples should rely on `const`/`let`, arrow helpers, and `camelCase` identifiers (e.g., `fetchData`, `rawData`, `loadingIndicator`).
- CSV payloads must use lowercase snake_case column headers (`alert_type`, `node_count`), and HTML/JS indentation stays at four spaces inside code fences.

## Testing Guidelines
- Validate new dashboard fragments in Chrome to confirm Chart.js renders, native filtering/aggregation works, and `localStorage` persistence (`Altinity-Alert-Analyst`) survives reloads.
- For data loader updates, hit `https://mcp.tenant-a.staging.altinity.cloud/{JWE_TOKEN}/openapi/execute_query?query=SELECT 1` with a disposable token and confirm error messaging covers empty/401 cases. Never commit credentials.
- When adjusting CSV helpers, run `Papa.parse` in the browser console against your embedded scripts to verify type coercion and row counts.

## Commit & Pull Request Guidelines
- Write imperative commit subjects and prefer Conventional Commit prefixes (`docs:`, `feat:`, `fix:`) to highlight intent.
- Pull requests must outline which docs changed, attach screenshots or GIFs for visual tweaks, and link related issues or task IDs.
- List manual validation steps (browser preview, API smoke test) in the PR description and flag follow-up work if coverage is partial.

## Security & Configuration Tips
- Strip real customer data and production endpoints from examples; substitute placeholders like `YOUR_JWE_TOKEN` or sample CSV rows.
- Remind readers to use `forgetApiKey()` in demos and document where secrets persist so they can be cleared before sharing artifacts.
