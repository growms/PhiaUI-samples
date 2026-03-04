# PhiaUI Samples

Three independent **Phoenix LiveView** demo apps in a single repo, each showcasing the [PhiaUI](https://hex.pm/packages/phia_ui) component library from a different angle.

---

## Overview

| | |
|---|---|
| **Repository** | [github.com/charlenopires/PhiaUI-samples](https://github.com/charlenopires/PhiaUI-samples) |
| **Framework** | Phoenix `~> 1.8.3` + LiveView `~> 1.1.0` |
| **UI Library** | [PhiaUI](https://hex.pm/packages/phia_ui) `~> 0.1.3` |
| **CSS** | Tailwind CSS v4 (`@theme` directive, OKLCH colors) |
| **Theme** | Violet — light + dark mode |
| **Language** | Elixir `~> 1.15` |
| **Data** | Hardcoded via `PhiaDemo.FakeData` + `PhiaDemo.ChatStore` (no Ecto) |

---

## Getting Started

```bash
git clone https://github.com/charlenopires/PhiaUI-samples.git
cd PhiaUI-samples
mix setup
mix phx.server
```

Open **http://localhost:4000** — redirects automatically to the Dashboard.

---

## Demo Projects

### Dashboard `/dashboard`

Analytics dashboard with real-time KPIs, charts, user management and order tracking.

| Route | Description |
|-------|-------------|
| `/dashboard` | Overview — KPIs, revenue area chart, recent orders, activity feed |
| `/dashboard/analytics` | Traffic metrics, area + donut charts, period filter |
| `/dashboard/users` | User table, role filter, drawer detail, confirm-delete dialog |
| `/dashboard/orders` | Order table, collapsible filters, tooltip statuses, drawer detail |
| `/dashboard/settings` | Accordion-based settings form with async save, dark mode toggle |

**Components used:**
`MetricGrid`, `StatCard`, `ChartShell`, `Card`, `Table`, `Avatar`, `Badge`,
`Combobox`, `Dialog`, `AlertDialog`, `DropdownMenu`, `Drawer`, `Collapsible`,
`Tooltip`, `Alert`, `Accordion`, `Breadcrumb`, `Skeleton`, `ButtonGroup`,
`Pagination`, `Toast`, `DarkModeToggle`

---

### Showcase `/showcase`

Full component library reference — every PhiaUI component with a live demo.

| Route | Components |
|-------|------------|
| `/showcase` | Landing — category cards overview |
| `/showcase/inputs` | Input, Textarea, Combobox, DateRangePicker, Select, TagsInput (demo), Checkbox, RadioGroup |
| `/showcase/display` | Badge, Avatar, Card, Skeleton, Accordion, Table, Pagination, EmptyState |
| `/showcase/feedback` | Alert (4 variants), Toast, Dialog, AlertDialog, Tooltip, Popover, DropdownMenu, Drawer, Progress |
| `/showcase/charts` | StatCard + MetricGrid, Area chart, Bar chart, Donut chart, ChartShell |

---

### Chat `/chat`

Real-time chat with polls, emoji reactions and typing indicators — all server-side via PubSub.

| Feature | Implementation |
|---------|----------------|
| Real-time messages | `Phoenix.PubSub` + LiveView streams |
| Emoji reactions | Toggle per user; counts updated live |
| Polls | Dialog form → inline poll message → live vote bars |
| Typing indicators | Keyup event → PubSub broadcast → "X is typing…" |
| Room switching | Navigate `/chat/:room_id`, re-subscribe to PubSub topic |
| Persistent state | `PhiaDemo.ChatStore` (Agent, seeded on startup) |

Routes: `/chat`, `/chat/:room_id` (general, random, announcements, design, engineering)

---

## Theme

Custom violet theme defined in `assets/css/app.css` using Tailwind v4 `@theme` and OKLCH color tokens. Dark mode is toggled via the `.dark` class on `<html>` — no page reload required.

| Token | Light | Dark |
|-------|-------|------|
| `--color-primary` | `oklch(0.555 0.235 268)` | `oklch(0.73 0.195 268)` |
| `--color-background` | `oklch(1 0 0)` | `oklch(0.13 0.03 265)` |
| `--color-sidebar-background` | `oklch(0.975 0.018 268)` | `oklch(0.155 0.032 265)` |
| `--color-foreground` | `oklch(0.145 0.03 265)` | `oklch(0.97 0.012 268)` |

---

## JS Hooks

PhiaUI interactive components require lightweight vanilla-JS hooks registered in `assets/js/phia_hooks/index.js`. Copy from `deps/phia_ui/priv/templates/js/hooks/`.

| Hook | Component |
|------|-----------|
| `PhiaDialog` | Dialog, AlertDialog |
| `PhiaDropdownMenu` | DropdownMenu |
| `PhiaTooltip` | Tooltip |
| `PhiaDarkMode` | DarkModeToggle |
| `PhiaToast` | Toast |
| `PhiaCarousel` | Carousel |
| `PhiaDrawer` | Drawer |
| `PhiaPopover` | Popover |
| `PhiaContextMenu` | ContextMenu |

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
│   ├── application.ex              # Supervision tree (includes ChatStore)
│   ├── chat_store.ex               # Agent — messages, reactions, typing, polls
│   └── fake_data.ex                # All demo data (dashboard + chat)
└── phia_demo_web/
    ├── phia_demo_web.ex            # Global PhiaUI imports
    ├── router.ex                   # All routes for 3 demo projects
    └── live/
        ├── dashboard/
        │   ├── layout.ex           # Sidebar shell for Dashboard
        │   ├── overview.ex
        │   ├── analytics.ex
        │   ├── users.ex
        │   ├── orders.ex
        │   └── settings.ex
        ├── showcase/
        │   ├── layout.ex           # Sidebar shell for Showcase
        │   ├── index_live.ex
        │   ├── inputs_live.ex
        │   ├── display_live.ex
        │   ├── feedback_live.ex
        │   └── charts_live.ex
        └── chat/
            ├── layout.ex           # Channels + members sidebar
            └── room_live.ex        # Full-featured chat room

priv/static/icons/
└── lucide-sprite.svg               # 69 Lucide icons (SVG sprite, no npm)

assets/
├── css/app.css                     # Violet OKLCH theme
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

- **No Ecto, no Mailer** — all data in `PhiaDemo.FakeData`; chat state in `PhiaDemo.ChatStore`
- **3 independent layouts** — each demo has its own `Layout` module under `live/{project}/layout.ex`
- **Global component imports** — all PhiaUI components imported once in `phia_demo_web.ex`; `Icon` overrides `CoreComponents.icon` (Lucide sprites instead of Heroicons)
- **Lucide icons** — SVG sprite at `priv/static/icons/lucide-sprite.svg`, no npm required; add new icons by downloading the SVG from `lucide-icons/lucide` and appending a `<symbol>` entry
- **SVG charts** — inline SVG computed server-side with `Enum.with_index`; no JS chart library
- **Toast** — `push_event(socket, "phia-toast", %{title: ..., variant: ..., duration_ms: ...})`
- **Combobox** — requires 3 event handlers: `on_toggle`, `on_search`, `on_change`; state on server
- **Drawer** — `<.drawer_content>` at page root; any element with `data-drawer-trigger={id}` opens it
- **TagsInput** — requires `Phoenix.HTML.FormField`; must be used inside a `<.form>` component
- **DateRangePicker** — requires `view_month` (Date), `on_change`, and `on_month_change` attrs

---

## License

MIT
