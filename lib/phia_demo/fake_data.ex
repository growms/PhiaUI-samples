defmodule PhiaDemo.FakeData do
  @moduledoc "Hardcoded demo data for the PhiaUI dashboard."

  # ── Overview KPIs ─────────────────────────────────────────────────────────

  def stats do
    [
      %{title: "Total Revenue", value: "$284,590", trend: :up, trend_value: "+12.5%", description: "vs. last month", icon: "circle-dollar-sign"},
      %{title: "Active Users", value: "12,847", trend: :up, trend_value: "+8.2%", description: "vs. last month", icon: "users"},
      %{title: "Orders", value: "3,924", trend: :neutral, trend_value: "→ 0.1%", description: "vs. last month", icon: "shopping-cart"},
      %{title: "Conversion", value: "4.7%", trend: :down, trend_value: "-0.3%", description: "vs. last month", icon: "percent"}
    ]
  end

  # ── Highlights carousel ───────────────────────────────────────────────────

  def highlights do
    [
      %{title: "Revenue Goal Reached", subtitle: "February 2026", stat: "$33,100", detail: "+12.5% above the monthly target", icon: "trending-up", badge: "Record"},
      %{title: "Largest User Base", subtitle: "Since launch", stat: "12,847", detail: "Active users — 8.2% monthly growth", icon: "users", badge: "New High"},
      %{title: "Historic NPS", subtitle: "Q1 2026 Survey", stat: "72", detail: "Top 10% of the industry — highly satisfied customers", icon: "star", badge: "Highlight"},
      %{title: "Enterprise Plus Launched", subtitle: "New plan available", stat: "$1,999/mo", detail: "3 contracts signed in the first week", icon: "zap", badge: "New"}
    ]
  end

  # ── Orders ────────────────────────────────────────────────────────────────

  def recent_orders do
    [
      %{id: "#4521", customer: "Ana Costa", product: "Pro Plan", amount: "$299.00", status: :paid, date: "Mar 1, 2026"},
      %{id: "#4520", customer: "Bruno Lima", product: "Starter Plan", amount: "$99.00", status: :pending, date: "Mar 1, 2026"},
      %{id: "#4519", customer: "Carla Souza", product: "Enterprise Plan", amount: "$999.00", status: :paid, date: "Feb 28, 2026"},
      %{id: "#4518", customer: "Diego Melo", product: "Pro Plan", amount: "$299.00", status: :cancelled, date: "Feb 28, 2026"},
      %{id: "#4517", customer: "Elena Rocha", product: "Starter Plan", amount: "$99.00", status: :paid, date: "Feb 27, 2026"},
      %{id: "#4516", customer: "Fábio Nunes", product: "Pro Plan", amount: "$299.00", status: :paid, date: "Feb 27, 2026"},
      %{id: "#4515", customer: "Gabi Torres", product: "Enterprise Plan", amount: "$999.00", status: :pending, date: "Feb 26, 2026"},
      %{id: "#4514", customer: "Hugo Alves", product: "Starter Plan", amount: "$99.00", status: :paid, date: "Feb 26, 2026"},
      %{id: "#4513", customer: "Ísis Ferreira", product: "Pro Plan", amount: "$299.00", status: :paid, date: "Feb 25, 2026"},
      %{id: "#4512", customer: "João Ribeiro", product: "Enterprise Plan", amount: "$999.00", status: :cancelled, date: "Feb 25, 2026"}
    ]
  end

  # ── Users ─────────────────────────────────────────────────────────────────

  def users do
    [
      %{id: 1, name: "Ana Costa", email: "ana@acme.com", role: "Admin", status: :active, joined: "Jan 2024"},
      %{id: 2, name: "Bruno Lima", email: "bruno@acme.com", role: "Editor", status: :active, joined: "Mar 2024"},
      %{id: 3, name: "Carla Souza", email: "carla@acme.com", role: "Viewer", status: :inactive, joined: "Jun 2024"},
      %{id: 4, name: "Diego Melo", email: "diego@acme.com", role: "Editor", status: :active, joined: "Aug 2024"},
      %{id: 5, name: "Elena Rocha", email: "elena@acme.com", role: "Admin", status: :active, joined: "Sep 2024"},
      %{id: 6, name: "Fábio Nunes", email: "fabio@acme.com", role: "Viewer", status: :pending, joined: "Nov 2024"},
      %{id: 7, name: "Gabi Torres", email: "gabi@acme.com", role: "Editor", status: :active, joined: "Dec 2024"},
      %{id: 8, name: "Hugo Alves", email: "hugo@acme.com", role: "Viewer", status: :inactive, joined: "Feb 2025"}
    ]
  end

  def role_options do
    [
      %{value: "all", label: "All roles"},
      %{value: "Admin", label: "Admin"},
      %{value: "Editor", label: "Editor"},
      %{value: "Viewer", label: "Viewer"}
    ]
  end

  # ── Charts ────────────────────────────────────────────────────────────────

  def revenue_by_month do
    [
      %{month: "Mar", value: 18_500},
      %{month: "Apr", value: 21_300},
      %{month: "May", value: 19_800},
      %{month: "Jun", value: 24_100},
      %{month: "Jul", value: 22_700},
      %{month: "Aug", value: 26_400},
      %{month: "Sep", value: 23_900},
      %{month: "Oct", value: 28_600},
      %{month: "Nov", value: 31_200},
      %{month: "Dec", value: 35_800},
      %{month: "Jan", value: 29_400},
      %{month: "Feb", value: 33_100}
    ]
  end

  def visits_by_month do
    [
      %{month: "Mar", value: 4_200},
      %{month: "Apr", value: 5_800},
      %{month: "May", value: 5_100},
      %{month: "Jun", value: 6_900},
      %{month: "Jul", value: 7_400},
      %{month: "Aug", value: 8_100},
      %{month: "Sep", value: 7_600},
      %{month: "Oct", value: 9_200},
      %{month: "Nov", value: 10_500},
      %{month: "Dec", value: 12_300},
      %{month: "Jan", value: 9_800},
      %{month: "Feb", value: 11_200}
    ]
  end

  def traffic_by_source do
    [
      %{source: "Organic Search", value: 42, color: "fill-primary"},
      %{source: "Direct", value: 25, color: "fill-secondary-foreground"},
      %{source: "Social Media", value: 18, color: "fill-success"},
      %{source: "Email", value: 10, color: "fill-warning"},
      %{source: "Other", value: 5, color: "fill-muted-foreground"}
    ]
  end

  # ── Analytics ─────────────────────────────────────────────────────────────

  def top_products do
    [
      %{name: "Enterprise Plan", revenue: "$11,988", orders: 12, pct: 100},
      %{name: "Pro Plan", revenue: "$8,970", orders: 30, pct: 75},
      %{name: "Starter Plan", revenue: "$2,970", orders: 30, pct: 25},
      %{name: "Analytics Add-on", revenue: "$1,490", orders: 15, pct: 12},
      %{name: "Premium Support", revenue: "$990", orders: 9, pct: 8}
    ]
  end

  def order_summary do
    %{
      total_revenue: "$26,418",
      avg_ticket: "$359.00",
      paid_amount: "$22,278"
    }
  end

  def analytics_stats do
    [
      %{title: "Unique Visitors", value: "98,421", trend: :up, trend_value: "+14.3%", description: "vs. last month"},
      %{title: "Pages per Session", value: "3.8", trend: :up, trend_value: "+0.4", description: "vs. last month"},
      %{title: "Bounce Rate", value: "32.1%", trend: :down, trend_value: "-2.1%", description: "vs. last month"}
    ]
  end

  def period_options do
    [
      %{value: "last_7", label: "Last 7 days"},
      %{value: "last_30", label: "Last 30 days"},
      %{value: "last_90", label: "Last 90 days"},
      %{value: "this_year", label: "This year"},
      %{value: "last_year", label: "Last year"}
    ]
  end

  # ── Activity ──────────────────────────────────────────────────────────────

  def activity_log do
    [
      %{title: "Enterprise Sale — Carla Souza", desc: "Enterprise Plan activated — $999.00", date: "Feb 28", icon: "circle-check", color: "text-success"},
      %{title: "New User — Fábio Nunes", desc: "Account approved — Starter Plan", date: "Feb 27", icon: "user-plus", color: "text-primary"},
      %{title: "Cancellation — João Ribeiro", desc: "Enterprise Plan terminated at customer request", date: "Feb 25", icon: "circle-x", color: "text-destructive"},
      %{title: "Plan Upgrade — Diego Melo", desc: "Starter → Pro — prorated charge applied", date: "Feb 24", icon: "circle-arrow-up", color: "text-warning"},
      %{title: "NPS Collected — Q1 2026", desc: "Score: 72 — 183 responses received", date: "Feb 20", icon: "star", color: "text-primary"}
    ]
  end

  def notifications do
    [
      %{title: "Order confirmed", description: "Order #4521 was paid successfully.", variant: :default},
      %{title: "User removed", description: "Hugo Alves' account has been deactivated.", variant: :destructive}
    ]
  end

  # ── Chat ──────────────────────────────────────────────────────────────────

  def chat_rooms do
    [
      %{id: "general", name: "general", description: "General discussion", icon: "hash"},
      %{id: "random", name: "random", description: "Off-topic fun", icon: "hash"},
      %{id: "announcements", name: "announcements", description: "Important updates", icon: "hash"},
      %{id: "design", name: "design", description: "Design and UI/UX", icon: "hash"},
      %{id: "engineering", name: "engineering", description: "Technical discussions", icon: "hash"}
    ]
  end

  def chat_users do
    [
      %{id: "alice", name: "Alice", initials: "AL", status: :online, color: "bg-primary"},
      %{id: "bob", name: "Bob", initials: "BO", status: :online, color: "bg-success"},
      %{id: "carol", name: "Carol", initials: "CA", status: :away, color: "bg-warning"},
      %{id: "david", name: "David", initials: "DA", status: :offline, color: "bg-muted-foreground"},
      %{id: "admin", name: "Admin User", initials: "AU", status: :online, color: "bg-primary"}
    ]
  end

  def chat_seed_messages("general") do
    [
      %{id: "m1", user_id: "alice", text: "Hey everyone! How's the sprint going?", timestamp: "09:00", reactions: %{}, type: :text, reply_to: nil},
      %{id: "m2", user_id: "bob", text: "Good morning! Finished the auth module yesterday 🎉", timestamp: "09:01", reactions: %{"👋" => ["carol"]}, type: :text, reply_to: nil},
      %{id: "m3", user_id: "carol", text: "Nice! I'm working on the dashboard redesign today.", timestamp: "09:02", reactions: %{}, type: :text, reply_to: nil},
      %{id: "m4", user_id: "david", text: "Can someone review my PR when they have a moment?", timestamp: "09:05", reactions: %{"👍" => ["alice", "bob"]}, type: :text, reply_to: nil}
    ]
  end

  def chat_seed_messages("design") do
    [
      %{id: "d1", user_id: "carol", text: "Figma file updated — check the new component library!", timestamp: "08:30", reactions: %{"🎨" => ["alice"]}, type: :text, reply_to: nil},
      %{id: "d2", user_id: "alice", text: "Love the new color palette. Much cleaner.", timestamp: "08:35", reactions: %{}, type: :text, reply_to: nil},
      %{id: "d3", user_id: "carol", text: "Let me know if the dark mode tokens need adjustment.", timestamp: "08:40", reactions: %{}, type: :text, reply_to: nil}
    ]
  end

  def chat_seed_messages("engineering") do
    [
      %{id: "e1", user_id: "david", text: "Upgraded to Phoenix 1.8 — all tests passing ✅", timestamp: "08:00", reactions: %{"🚀" => ["bob", "alice"]}, type: :text, reply_to: nil},
      %{id: "e2", user_id: "bob", text: "Nice! Did you run into any issues with the new layouts?", timestamp: "08:05", reactions: %{}, type: :text, reply_to: nil},
      %{id: "e3", user_id: "david", text: "Just a minor CSS tweak needed for the sidebar. Fixed in 10 min.", timestamp: "08:08", reactions: %{}, type: :text, reply_to: nil}
    ]
  end

  def chat_seed_messages(_room_id) do
    [
      %{id: "generic1", user_id: "alice", text: "Welcome to this channel!", timestamp: "09:00", reactions: %{}, type: :text, reply_to: nil}
    ]
  end
end
