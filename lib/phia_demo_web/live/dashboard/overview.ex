defmodule PhiaDemoWeb.Demo.Dashboard.Overview do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.Demo.Dashboard.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Overview")
     |> assign(:stats, FakeData.stats())
     |> assign(:orders, FakeData.recent_orders())
     |> assign(:revenue, FakeData.revenue_by_month())
     |> assign(:top_products, FakeData.top_products())
     |> assign(:activity, FakeData.activity_log())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/dashboard">
      <div class="p-6 space-y-6 max-w-screen-2xl mx-auto">

        <%!-- Page Header --%>
        <div class="flex items-center justify-between phia-animate">
          <div>
            <h1 class="text-xl font-bold text-foreground tracking-tight">Overview</h1>
            <p class="text-sm text-muted-foreground mt-0.5">February 2026 · performance summary</p>
          </div>
          <div class="flex items-center gap-2">
            <span class="inline-flex items-center gap-1.5 rounded-full bg-success/10 px-3 py-1 text-xs font-semibold text-success">
              <span class="h-1.5 w-1.5 rounded-full bg-success animate-pulse"></span>
              Live
            </span>
          </div>
        </div>

        <%!-- KPI Stat Cards --%>
        <div class="grid grid-cols-2 gap-4 lg:grid-cols-4 phia-animate-d1">
          <.stat_card
            :for={s <- @stats}
            title={s.title}
            value={s.value}
            trend={s.trend}
            trend_value={s.trend_value}
            description={s.description}
            class="border-border/60 shadow-sm"
          >
            <:icon>
              <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-primary/10">
                <.icon name={s.icon} size={:sm} class="text-primary" />
              </div>
            </:icon>
          </.stat_card>
        </div>

        <%!-- Revenue Area Chart --%>
        <.card class="border-border/60 shadow-sm phia-animate-d2">
          <.card_header class="pb-4">
            <div class="flex items-start justify-between">
              <div>
                <.card_title>Monthly Revenue</.card_title>
                <.card_description>Last 12 months · Mar 2025 – Feb 2026</.card_description>
              </div>
              <div class="text-right">
                <p class="text-2xl font-bold text-foreground tracking-tight">$284,590</p>
                <p class="text-xs text-success font-medium mt-0.5">+12.5% vs. last period</p>
              </div>
            </div>
          </.card_header>
          <.card_content class="px-6 pb-6 pt-0">
            <% max_val = Enum.max(Enum.map(@revenue, & &1.value)) %>
            <% n = length(@revenue) - 1 %>
            <% pts = Enum.with_index(@revenue) |> Enum.map(fn {item, i} ->
              x = 44.0 + i * (548.0 / n)
              y = 165.0 - item.value / max_val * 135.0
              {Float.round(x, 1), Float.round(y, 1)}
            end) %>
            <% {fx, _} = List.first(pts) %>
            <% {lx, _} = List.last(pts) %>
            <% area_pts = "#{fx},165 " <> Enum.map_join(pts, " ", fn {x, y} -> "#{x},#{y}" end) <> " #{lx},165" %>
            <% line_pts = Enum.map_join(pts, " ", fn {x, y} -> "#{x},#{y}" end) %>
            <svg viewBox="0 0 612 190" class="w-full" style="height:220px">
              <%!-- Grid lines --%>
              <%= for pct <- [0.25, 0.5, 0.75, 1.0] do %>
                <% gy = Float.round(165.0 - pct * 135.0, 1) %>
                <line x1="44" y1={gy} x2="592" y2={gy} class="stroke-border" stroke-width="1" stroke-dasharray="4 3" />
                <text x="38" y={gy + 4} text-anchor="end" class="fill-muted-foreground" style="font-size:9px">
                  {trunc(max_val * pct / 1000)}k
                </text>
              <% end %>
              <%!-- Area fill --%>
              <polygon points={area_pts} class="fill-primary" fill-opacity="0.08" />
              <%!-- Line --%>
              <polyline points={line_pts} class="stroke-primary" fill="none" stroke-width="2" stroke-linejoin="round" stroke-linecap="round" />
              <%!-- Data dots --%>
              <%= for {x, y} <- pts do %>
                <circle cx={x} cy={y} r="3" class="fill-background stroke-primary" stroke-width="1.5" />
              <% end %>
              <%!-- X-axis month labels --%>
              <%= for {item, i} <- Enum.with_index(@revenue) do %>
                <% lx2 = Float.round(44.0 + i * (548.0 / n), 1) %>
                <text x={lx2} y="183" text-anchor="middle" class="fill-muted-foreground" style="font-size:9px">
                  {item.month}
                </text>
              <% end %>
            </svg>
          </.card_content>
        </.card>

        <%!-- Two-column: Recent Orders + Right Panel --%>
        <div class="grid gap-6 lg:grid-cols-5 phia-animate-d3">

          <%!-- Recent Orders (wider) --%>
          <.card class="lg:col-span-3 border-border/60 shadow-sm">
            <.card_header class="pb-3">
              <div class="flex items-center justify-between">
                <div>
                  <.card_title>Recent Orders</.card_title>
                  <.card_description>Latest 10 transactions</.card_description>
                </div>
                <.badge variant={:outline} class="text-xs font-medium">
                  {length(@orders)} orders
                </.badge>
              </div>
            </.card_header>
            <.card_content class="p-0">
              <.table>
                <.table_header>
                  <.table_row class="hover:bg-transparent">
                    <.table_head class="pl-6">ID</.table_head>
                    <.table_head>Customer</.table_head>
                    <.table_head>Amount</.table_head>
                    <.table_head class="pr-6">Status</.table_head>
                  </.table_row>
                </.table_header>
                <.table_body>
                  <.table_row :for={o <- @orders}>
                    <.table_cell class="pl-6 font-mono text-xs text-muted-foreground">{o.id}</.table_cell>
                    <.table_cell class="font-medium">{o.customer}</.table_cell>
                    <.table_cell class="font-medium">{o.amount}</.table_cell>
                    <.table_cell class="pr-6">
                      <.badge variant={order_variant(o.status)} class="text-xs">
                        {order_label(o.status)}
                      </.badge>
                    </.table_cell>
                  </.table_row>
                </.table_body>
              </.table>
            </.card_content>
          </.card>

          <%!-- Right panel: Top Products + Order Status --%>
          <div class="lg:col-span-2 space-y-6">

            <%!-- Top Products --%>
            <.card class="border-border/60 shadow-sm">
              <.card_header class="pb-3">
                <.card_title>Top Products</.card_title>
                <.card_description>By revenue in the period</.card_description>
              </.card_header>
              <.card_content class="pt-0">
                <div class="space-y-4">
                  <%= for p <- @top_products do %>
                    <div class="space-y-1">
                      <div class="flex items-center justify-between text-sm">
                        <span class="font-medium text-foreground">{p.name}</span>
                        <span class="text-xs font-semibold text-muted-foreground">{p.revenue}</span>
                      </div>
                      <div class="h-1.5 w-full rounded-full bg-muted">
                        <div class="h-1.5 rounded-full bg-primary transition-all duration-500" style={"width: #{p.pct}%"} />
                      </div>
                      <p class="text-xs text-muted-foreground">{p.orders} orders</p>
                    </div>
                  <% end %>
                </div>
              </.card_content>
            </.card>

            <%!-- Order Status Breakdown --%>
            <.card class="border-border/60 shadow-sm">
              <.card_header class="pb-3">
                <.card_title>Order Breakdown</.card_title>
                <.card_description>Status distribution</.card_description>
              </.card_header>
              <.card_content class="pt-0">
                <% paid = Enum.count(@orders, & &1.status == :paid) %>
                <% pending = Enum.count(@orders, & &1.status == :pending) %>
                <% cancelled = Enum.count(@orders, & &1.status == :cancelled) %>
                <% total = length(@orders) %>
                <% circ = 251.3 %>
                <% paid_len = Float.round(paid / total * circ, 1) %>
                <% pending_len = Float.round(pending / total * circ, 1) %>
                <% cancelled_len = Float.round(cancelled / total * circ, 1) %>
                <div class="flex items-center gap-6">
                  <svg viewBox="0 0 100 100" class="w-24 h-24 shrink-0" style="transform: rotate(-90deg)">
                    <circle cx="50" cy="50" r="40" fill="transparent" class="stroke-muted" stroke-width="14" />
                    <circle cx="50" cy="50" r="40" fill="transparent" class="stroke-primary" stroke-width="14"
                      stroke-dasharray={"#{paid_len} #{circ}"} stroke-dashoffset="0" stroke-linecap="round" />
                    <circle cx="50" cy="50" r="40" fill="transparent" class="stroke-warning" stroke-width="14"
                      stroke-dasharray={"#{pending_len} #{circ}"} stroke-dashoffset={"-#{paid_len}"} stroke-linecap="round" />
                    <circle cx="50" cy="50" r="40" fill="transparent" class="stroke-destructive" stroke-width="14"
                      stroke-dasharray={"#{cancelled_len} #{circ}"} stroke-dashoffset={"-#{paid_len + pending_len}"} stroke-linecap="round" />
                  </svg>
                  <div class="space-y-2 text-sm">
                    <div class="flex items-center gap-2">
                      <span class="h-2 w-2 rounded-full bg-primary shrink-0"></span>
                      <span class="text-muted-foreground">Paid</span>
                      <span class="ml-auto font-semibold text-foreground">{paid}</span>
                    </div>
                    <div class="flex items-center gap-2">
                      <span class="h-2 w-2 rounded-full bg-warning shrink-0"></span>
                      <span class="text-muted-foreground">Pending</span>
                      <span class="ml-auto font-semibold text-foreground">{pending}</span>
                    </div>
                    <div class="flex items-center gap-2">
                      <span class="h-2 w-2 rounded-full bg-destructive shrink-0"></span>
                      <span class="text-muted-foreground">Cancelled</span>
                      <span class="ml-auto font-semibold text-foreground">{cancelled}</span>
                    </div>
                  </div>
                </div>
              </.card_content>
            </.card>

          </div>
        </div>

        <%!-- Activity Feed --%>
        <.card class="border-border/60 shadow-sm phia-animate-d4">
          <.card_header class="pb-3">
            <.card_title>Recent Activity</.card_title>
            <.card_description>Latest platform events</.card_description>
          </.card_header>
          <.card_content class="p-0">
            <div class="divide-y divide-border/40">
              <%= for a <- @activity do %>
                <div class="flex items-start gap-4 px-6 py-4">
                  <div class={"flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-muted #{a.color}"}>
                    <.icon name={a.icon} size={:xs} />
                  </div>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-medium text-foreground">{a.title}</p>
                    <p class="text-xs text-muted-foreground mt-0.5 truncate">{a.desc}</p>
                  </div>
                  <span class="shrink-0 text-xs text-muted-foreground">{a.date}</span>
                </div>
              <% end %>
            </div>
          </.card_content>
        </.card>

      </div>
    </Layout.layout>
    """
  end

  defp order_variant(:paid), do: :default
  defp order_variant(:pending), do: :secondary
  defp order_variant(:cancelled), do: :destructive

  defp order_label(:paid), do: "Paid"
  defp order_label(:pending), do: "Pending"
  defp order_label(:cancelled), do: "Cancelled"
end
