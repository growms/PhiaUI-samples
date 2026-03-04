# PhiaUI Samples — Dashboard Demo

A modern, feature-rich **Phoenix LiveView** dashboard built to showcase the [PhiaUI](https://hex.pm/packages/phia_ui) component library. This project serves as a living reference for developers integrating PhiaUI into their own Phoenix applications.

---

## Overview

| | |
|---|---|
| **Repository** | [github.com/charlenopires/PhiaUI-samples](https://github.com/charlenopires/PhiaUI-samples) |
| **Framework** | Phoenix `~> 1.8.3` + LiveView `~> 1.1.0` |
| **UI Library** | [PhiaUI](https://hex.pm/packages/phia_ui) `~> 0.1.3` |
| **CSS** | Tailwind CSS v4 (via `@theme` directive, OKLCH colors) |
| **Theme** | Violet — light + dark mode |
| **Language** | Elixir `~> 1.15` |
| **Data** | Hardcoded via `PhiaDemo.FakeData` (no Ecto, no Mailer) |

---

## Getting Started

```bash
# Clone the repo
git clone https://github.com/charlenopires/PhiaUI-samples.git
cd PhiaUI-samples

# Install deps and build assets
mix setup

# Start the dev server
mix phx.server
```

Open **http://localhost:4000**

---

## Pages

### `/` — Visão Geral (Overview)

General KPIs, highlight carousel, charts, recent orders and activity feed.

| Component | Usage |
|-----------|-------|
| `Carousel` | Rotating highlight cards |
| `MetricGrid` + `StatCard` | 4 KPIs with trend indicators |
| `ChartShell` + inline SVG | Monthly revenue bar chart |
| `Table` | Recent orders snapshot |
| `Card` + progress bars | Top products ranking |
| `Skeleton` | Loading state demo |
| `Accordion` | Expandable activity log |
| `Breadcrumb` | Navigation context |

---

### `/analytics` — Analytics

Traffic and engagement metrics with period filtering.

| Component | Usage |
|-----------|-------|
| `Combobox` | Period selector with live search |
| `Alert` | Data freshness notification |
| `MetricGrid` + `StatCard` | 3 analytics KPIs |
| `ChartShell` + area SVG | Monthly visits area chart |
| `ChartShell` + donut SVG | Traffic source breakdown |
| `EmptyState` | Zero-data pattern |

---

### `/users` — Usuários

User management with filtering, detail panel and confirmation dialogs.

| Component | Usage |
|-----------|-------|
| `Dialog` | New user modal |
| `Combobox` | Role filter with server search |
| `MetricGrid` + `StatCard` | Status counters |
| `Alert` | Pending users warning |
| `Table` + `Avatar` + `Badge` | Users list |
| `DropdownMenu` | Row actions menu |
| `Drawer` | User detail side panel |
| `Pagination` | Page navigation |
| `AlertDialog` | Confirm delete |
| `Toast` | Action feedback |

---

### `/orders` — Pedidos

Order table with status filters, export buttons and detail drawer.

| Component | Usage |
|-----------|-------|
| `ButtonGroup` | CSV / PDF export actions |
| `MetricGrid` + `StatCard` | Order counters + revenue |
| `Collapsible` + `Badge` | Expandable status filters |
| `Table` + `Tooltip` | Orders list with status tooltips |
| `Drawer` | Order detail side panel |
| `Pagination` | Page navigation |

---

### `/components` — Showcase

Interactive gallery demonstrating every component added in v0.1.3.

| Component | Usage |
|-----------|-------|
| `Carousel` | 4-slide feature tour |
| `Combobox` | Full server-state demo (toggle / search / select) |
| `Popover` | 3 variants: info, profile, quick settings |
| `ContextMenu` | Right-click menu with checkbox state |
| `Drawer` | 3 directions: right, left, bottom |
| `Avatar` + `AvatarGroup` | All sizes and stacked overlap |
| `Badge` | All 6 variants |
| `Alert` | All 4 variants |
| `Collapsible` | Expandable section |

---

### `/settings` — Configurações

Settings page demonstrating form patterns, async save feedback and theme control.

| Component | Usage |
|-----------|-------|
| `Accordion` | 4 collapsible sections (profile, notifications, appearance, security) |
| `Alert` | Success banner + security warning |
| `DarkModeToggle` | Theme control inside appearance section |
| `ButtonGroup` | Save / Discard footer |
| `Skeleton` | Inline loading state during async save |
| `Toast` | Save confirmation + discard feedback |

---

## Theme

Custom violet theme in `assets/css/app.css` using Tailwind CSS v4 `@theme` and OKLCH color tokens. Dark mode is toggled via `data-theme="dark"` on `<html>` — no page reload required.

| Token | Light | Dark |
|-------|-------|------|
| `--color-primary` | `oklch(0.555 0.235 268)` | `oklch(0.73 0.195 268)` |
| `--color-background` | `oklch(1 0 0)` | `oklch(0.13 0.03 265)` |
| `--color-sidebar-background` | `oklch(0.975 0.018 268)` | `oklch(0.155 0.032 265)` |
| `--color-foreground` | `oklch(0.145 0.03 265)` | `oklch(0.97 0.012 268)` |
| `--color-muted-foreground` | `oklch(0.52 0.04 265)` | `oklch(0.60 0.04 268)` |

---

## JS Hooks

PhiaUI interactive components require lightweight vanilla-JS hooks registered in `assets/js/phia_hooks/index.js`. Copy the hooks from `deps/phia_ui/priv/templates/js/hooks/` into your project.

| File | Hook name | Component |
|------|-----------|-----------|
| `dialog.js` | `PhiaDialog` | Dialog, AlertDialog |
| `dropdown_menu.js` | `PhiaDropdownMenu` | DropdownMenu |
| `tooltip.js` | `PhiaTooltip` | Tooltip |
| `dark_mode.js` | `PhiaDarkMode` | DarkModeToggle |
| `toast.js` | `PhiaToast` | Toast |
| `carousel.js` | `PhiaCarousel` | Carousel |
| `drawer.js` | `PhiaDrawer` | Drawer |
| `popover.js` | `PhiaPopover` | Popover |
| `context_menu.js` | `PhiaContextMenu` | ContextMenu |

Register all hooks in `app.js`:

```js
import PhiaHooks from './phia_hooks'

let liveSocket = new LiveSocket('/live', Socket, {
  hooks: PhiaHooks,
  // ...
})
```

---

## Project Structure

```
lib/
├── phia_demo/
│   └── fake_data.ex                   # All hardcoded demo data
└── phia_demo_web/
    ├── phia_demo_web.ex                # Global PhiaUI imports
    ├── router.ex                       # 6 live routes
    ├── components/
    │   └── layouts.ex                  # Root layout + flash group
    └── live/
        ├── components/
        │   └── dashboard_layout.ex     # Shared sidebar shell
        └── dashboard_live/
            ├── overview.ex
            ├── analytics.ex
            ├── users.ex
            ├── orders.ex
            ├── components.ex           # Component showcase page
            └── settings.ex             # Settings page

assets/
├── css/app.css                         # Violet OKLCH theme
└── js/phia_hooks/
    ├── index.js
    ├── carousel.js
    ├── context_menu.js
    ├── dark_mode.js
    ├── dialog.js
    ├── drawer.js
    ├── dropdown_menu.js
    ├── popover.js
    ├── toast.js
    └── tooltip.js
```

---

## Architecture Notes

- **No Ecto, no Mailer** — all data is generated in `PhiaDemo.FakeData`
- **Global imports** — all PhiaUI components are imported once in `phia_demo_web.ex`; `PhiaUi.Components.Icon` overrides `CoreComponents.icon` (Lucide sprites instead of Heroicons)
- **Icon conflict** — `CoreComponents.icon` is excluded from the global import; `layouts.ex` uses `PhiaDemoWeb.CoreComponents.icon` directly for the `hero-arrow-path` spinner
- **Drawer pattern** — `DrawerContent` placed at page root; any element with `data-drawer-trigger={content_id}` opens it without server state
- **Combobox pattern** — requires 3 `handle_event` callbacks: `on_toggle`, `on_search`, `on_change`; state lives entirely on the server
- **SVG charts** — inline SVG inside `ChartShell`, computed with `Enum.with_index`; no JS chart library required
- **Toast** — triggered via `push_event(socket, "phia-toast", %{title: ..., variant: ..., duration_ms: ...})`

---

## License

MIT
