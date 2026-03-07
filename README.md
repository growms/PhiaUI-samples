# PhiaUI Samples

**16 complete Phoenix LiveView demo apps** in a single repo, each built with the [PhiaUI](https://hex.pm/packages/phia_ui) component library — featuring CSS-first theming, 534 components, and full dark mode support.

---

## Overview

| | |
|---|---|
| **Repository** | [github.com/charlenopires/PhiaUI-samples](https://github.com/charlenopires/PhiaUI-samples) |
| **Framework** | Phoenix `~> 1.8.3` + LiveView `~> 1.1.0` |
| **UI Library** | [PhiaUI](https://hex.pm/packages/phia_ui) `v0.1.11` |
| **CSS** | Tailwind CSS v4 (CSS-first `@theme`, OKLCH colors) |
| **Themes** | Violet, Blue, Green, Rose, Orange, Slate, Zinc, Neutral — light + dark mode |
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

Open **http://localhost:4000** — home page with live theme picker and links to all 16 demos.

---

## Home Page `/`

- **Aurora hero** — animated gradient background with component count stats (`NumberTicker`)
- **Live theme picker** — switch between 8 color palettes instantly via `PhiaTheme` JS hook; persists via `localStorage`
- **Multi-theme preview** — all 8 themes rendered simultaneously via CSS-first `theme_provider` scoping
- **16 project cards** — grouped by category with icons and descriptions

---

## Demo Apps

### Core Demos

| App | Route | Description |
|-----|-------|-------------|
| **Dashboard** | `/dashboard` | Admin panel — KPIs, SVG charts, user/order management, settings |
| **Showcase** | `/showcase` | Interactive gallery of 534 PhiaUI components across 11 pages |
| **Chat** | `/chat` | Real-time chat rooms with PubSub, polls, reactions, typing indicators |

### Productivity

| App | Route | Description |
|-----|-------|-------------|
| **Kanban** | `/kanban` | Drag-and-drop board — 4 columns, card add/move/delete, priority indicators |
| **Notes** | `/notes` | Google Keep-style masonry grid — 8 note colors, search, pin, tags |
| **Todo** | `/todo` | Personal task manager — 4 lists, circular checkboxes, per-list progress |
| **Tasks** | `/tasks` | Issue tracker — table with filters, status/priority badges, bulk actions |

### Communication

| App | Route | Description |
|-----|-------|-------------|
| **Mail** | `/mail` | Email client — inbox/sent/drafts, thread view, compose dialog |
| **Social** | `/social` | Community feed — posts, reactions, follow, trending topics |

### Business

| App | Route | Description |
|-----|-------|-------------|
| **File Manager** | `/files` | File browser — grid/list views, folder tree, upload drop zone |
| **API Keys** | `/api-keys` | Key management — masked display, copy, reveal, revoke, scopes |
| **Point of Sale** | `/pos` | POS terminal — product grid, cart, tax calculation, checkout dialog |
| **Courses** | `/courses` | Learning platform — catalog, enrollment, module accordion, progress |

### AI Tools

| App | Route | Description |
|-----|-------|-------------|
| **AI Chat** | `/ai-chat` | Conversational UI — typing indicator, suggestions, mock responses |
| **AI Chat v2** | `/ai-chat-v2` | Advanced chat — model selection, temperature slider, conversation history |
| **Image Generator** | `/image-generator` | AI image studio — prompt editor, style selection, mock gallery |

---

## Showcase Pages

| Route | Components |
|-------|------------|
| `/showcase` | Category overview — 534 components across 11 sections |
| `/showcase/inputs` | Input, Textarea, Select, Combobox, DateRangePicker, TagsInput, Checkbox, RadioGroup |
| `/showcase/display` | Badge, Avatar, Card, Skeleton, Accordion, Table, Pagination, EmptyState |
| `/showcase/feedback` | Alert, Toast, Dialog, AlertDialog, Tooltip, Popover, DropdownMenu, Drawer, Progress |
| `/showcase/charts` | StatCard, MetricGrid, Area, Bar, Donut charts via inline SVG |
| `/showcase/calendar` | Monthly, weekly, range calendars; DateStrip; event markers |
| `/showcase/cards` | ArticleCard, PricingCard, ProductCard, ProfileCard, FeatureCard, TestimonialCard |
| `/showcase/navigation` | MegaMenu, Dock, CommandPalette, ChipNav, Stepper, Breadcrumb, Toolbar |
| `/showcase/tables` | DataTable, FilterBar, BulkActionBar, ComparisonTable, ExpandableTable |
| `/showcase/upload` | FileUpload, ImageUpload, DropZone, UploadProgress, UploadQueue |
| `/showcase/media` | AudioPlayer, Carousel, ImageComparison, QrCode, Watermark |

---

## Theming (v0.1.11)

PhiaUI v0.1.11 introduces **CSS-first theming** with 8 built-in presets:

```bash
mix phia.theme install   # generates assets/css/phia-themes.css
```

Themes are applied via `data-phia-theme` on `<html>`:

```js
// PhiaTheme hook (assets/js/phia_hooks/theme.js)
document.documentElement.setAttribute('data-phia-theme', 'violet')
localStorage.setItem('phia-color-theme', 'violet')
```

Scoped multi-theme preview on the same page:

```heex
<.theme_provider theme={:blue}>
  <.button>Primary</.button>
</.theme_provider>
```

---

## JS Hooks

All PhiaUI interactive components use lightweight vanilla-JS hooks registered in `assets/js/phia_hooks/index.js`.

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
| `PhiaBackTop` | BackTop |
| `PhiaHoverCard` | HoverCard |
| `PhiaTheme` | Theme palette switcher |
| `PhiaNumberTicker` | Animated number count-up |

---

## Project Structure

```
lib/
├── phia_demo/
│   ├── application.ex
│   ├── chat_store.ex               # Agent — messages, reactions, typing, polls
│   └── fake_data.ex                # All demo data (no Ecto)
└── phia_demo_web/
    ├── phia_demo_web.ex            # Global PhiaUI component imports
    ├── router.ex                   # ~30 routes across 16 demo apps
    ├── components/
    │   └── project_nav.ex          # Shared top nav (logo, project switcher, dark mode)
    └── live/
        ├── home_live.ex            # Landing — aurora hero, theme picker, 16 project cards
        ├── dashboard/              # Overview, Analytics, Users, Orders, Settings
        ├── showcase/               # 11 showcase pages
        ├── chat/                   # RoomLive with PubSub
        ├── kanban/                 # Kanban board
        ├── notes/                  # Google Keep-style notes
        ├── mail/                   # Email client
        ├── todo/                   # Personal todo lists
        ├── tasks/                  # Issue tracker table
        ├── social/                 # Community feed
        ├── files/                  # File manager
        ├── api_keys/               # API key management
        ├── pos/                    # Point of sale
        ├── courses/                # Learning platform
        ├── ai_chat/                # AI chat UI
        ├── ai_chat_v2/             # Advanced AI chat
        └── image_gen/              # Image generator UI

priv/static/icons/
└── lucide-sprite.svg               # Lucide icon sprite (no npm)

assets/
├── css/
│   ├── app.css                     # Tailwind v4 @theme tokens
│   └── phia-themes.css             # 8 color theme presets (via mix phia.theme install)
└── js/phia_hooks/
    ├── index.js
    ├── theme.js
    ├── number_ticker.js
    └── ...                         # One file per hook
```

---

## Architecture Notes

- **No Ecto, no Mailer** — all data in `PhiaDemo.FakeData`; chat state in `PhiaDemo.ChatStore` (Agent)
- **16 independent layouts** — each app has its own `Layout` module under `live/{app}/layout.ex`
- **Shared top nav** — `PhiaDemoWeb.ProjectNav` renders the cross-project navigation bar
- **Global component imports** — all PhiaUI components imported once in `phia_demo_web.ex`
- **Lucide icons** — SVG sprite at `priv/static/icons/lucide-sprite.svg`, no npm; add icons by appending a `<symbol>` entry
- **SVG charts** — inline SVG computed server-side with `Enum.with_index`; no JS chart library
- **CSS-first theming** — `data-phia-theme` attribute on `<html>`; theme persists via `localStorage['phia-color-theme']`

---

## License

MIT
