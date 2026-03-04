defmodule PhiaDemoWeb.Demo.Dashboard.Analytics do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.Demo.Dashboard.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Analytics")
     |> assign(:stats, FakeData.analytics_stats())
     |> assign(:visits, FakeData.visits_by_month())
     |> assign(:traffic, FakeData.traffic_by_source())
     |> assign(:period_options, FakeData.period_options())
     |> assign(:period, "last_30")
     |> assign(:period_open, false)
     |> assign(:period_search, "")}
  end

  @impl true
  def handle_event("period-toggle", _params, socket) do
    {:noreply, update(socket, :period_open, &(!&1))}
  end

  @impl true
  def handle_event("period-search", %{"query" => q}, socket) do
    {:noreply, assign(socket, :period_search, q)}
  end

  @impl true
  def handle_event("period-change", %{"value" => v}, socket) do
    {:noreply, assign(socket, period: v, period_open: false, period_search: "")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/dashboard/analytics">
      <div class="p-6 space-y-6 max-w-screen-2xl mx-auto">

        <%!-- Header + period filter --%>
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
          <div>
            <h1 class="text-xl font-bold text-foreground tracking-tight">Analytics</h1>
            <p class="text-sm text-muted-foreground mt-0.5">Traffic and engagement metrics</p>
          </div>
          <div class="w-full sm:w-56">
            <.combobox
              id="period-combobox"
              options={@period_options}
              value={@period}
              open={@period_open}
              search={@period_search}
              placeholder="Select period..."
              search_placeholder="Search period..."
              on_change="period-change"
              on_search="period-search"
              on_toggle="period-toggle"
            />
          </div>
        </div>

        <%!-- Info Alert --%>
        <.alert variant={:default}>
          <.alert_title>Data updated</.alert_title>
          <.alert_description>
            Showing: <strong>{period_label(@period, @period_options)}</strong> — Last sync: Mar 3, 2026 at 08:00
          </.alert_description>
        </.alert>

        <%!-- Metric Grid --%>
        <.metric_grid cols={3}>
          <.stat_card
            :for={s <- @stats}
            title={s.title}
            value={s.value}
            trend={s.trend}
            trend_value={s.trend_value}
            description={s.description}
            class="border-border/60 shadow-sm"
          />
        </.metric_grid>

        <%!-- Charts row --%>
        <div class="grid gap-6 lg:grid-cols-2">
          <.chart_shell
            title="Monthly Visitors"
            description="Unique visitors per month"
            period="Last 12 months"
            min_height="240px"
          >
            <svg viewBox="0 0 420 210" class="w-full h-full">
              <% max_val = Enum.max(Enum.map(@visits, & &1.value)) %>
              <% n = length(@visits) - 1 %>
              <% coords = Enum.with_index(@visits) |> Enum.map(fn {item, i} ->
                x = Float.round(18.0 + i * (384.0 / n), 1)
                y = Float.round(175.0 - item.value / max_val * 155.0, 1)
                {x, y}
              end) %>
              <% line_pts = Enum.map_join(coords, " ", fn {x, y} -> "#{x},#{y}" end) %>
              <% {fx, _} = List.first(coords) %>
              <% {lx, _} = List.last(coords) %>
              <% area_pts = "#{fx},175 #{line_pts} #{lx},175" %>
              <polygon points={area_pts} class="fill-primary" fill-opacity="0.08" />
              <polyline points={line_pts} class="stroke-primary fill-none" stroke-width="2" stroke-linejoin="round" stroke-linecap="round" />
              <%= for {item, {x, y}} <- Enum.zip(@visits, coords) do %>
                <circle cx={x} cy={y} r="3" class="fill-background stroke-primary" stroke-width="1.5" />
                <text x={x} y="197" text-anchor="middle" class="fill-muted-foreground" style="font-size:9px">
                  {item.month}
                </text>
              <% end %>
            </svg>
          </.chart_shell>

          <.chart_shell
            title="Traffic by Source"
            description="Distribution by acquisition channel"
            min_height="240px"
          >
            <div class="flex gap-6 items-center h-full py-2">
              <div class="relative w-32 h-32 shrink-0">
                <svg viewBox="0 0 120 120" class="w-full h-full">
                  <% total = Enum.sum(Enum.map(@traffic, & &1.value)) %>
                  <% {_offset, slices} =
                    Enum.reduce(@traffic, {0, []}, fn item, {offset, acc} ->
                      pct = item.value / total * 100
                      {offset + pct, [{item, offset, pct} | acc]}
                    end) %>
                  <%= for {item, offset, pct} <- Enum.reverse(slices) do %>
                    <circle
                      cx="60" cy="60" r="40" fill="none"
                      class={"stroke-current #{String.replace(item.color, "fill-", "text-")}"}
                      stroke-width="20"
                      stroke-dasharray={"#{Float.round(pct * 2.513, 1)} #{100 * 2.513}"}
                      stroke-dashoffset={"-#{Float.round(offset * 2.513, 1)}"}
                      transform="rotate(-90 60 60)"
                    />
                  <% end %>
                  <text x="60" y="56" text-anchor="middle" class="fill-foreground" style="font-size:11px; font-weight:700">
                    {total}k
                  </text>
                  <text x="60" y="69" text-anchor="middle" class="fill-muted-foreground" style="font-size:8px">
                    visits
                  </text>
                </svg>
              </div>
              <ul class="space-y-2 text-sm flex-1">
                <%= for item <- @traffic do %>
                  <li class="flex items-center justify-between gap-2">
                    <span class="flex items-center gap-2">
                      <span class={"inline-block w-2 h-2 rounded-full #{item.color}"} />
                      <span class="text-foreground">{item.source}</span>
                    </span>
                    <span class="font-semibold text-muted-foreground">{item.value}%</span>
                  </li>
                <% end %>
              </ul>
            </div>
          </.chart_shell>
        </div>

        <%!-- Conversion by channel --%>
        <.card class="border-border/60 shadow-sm">
          <.card_header>
            <.card_title>Conversion by Channel</.card_title>
            <.card_description>Relative conversion rate by traffic source</.card_description>
          </.card_header>
          <.card_content class="pt-0">
            <div class="space-y-4">
              <%= for {item, conv} <- Enum.zip(@traffic, [5.2, 3.8, 2.1, 7.4, 1.3]) do %>
                <div class="space-y-1.5">
                  <div class="flex justify-between text-sm">
                    <span class="font-medium text-foreground">{item.source}</span>
                    <span class="font-semibold text-primary">{conv}%</span>
                  </div>
                  <div class="h-1.5 w-full rounded-full bg-muted">
                    <div class="h-1.5 rounded-full bg-primary transition-all" style={"width: #{Float.round(conv / 8 * 100, 1)}%"} />
                  </div>
                </div>
              <% end %>
            </div>
          </.card_content>
        </.card>

        <%!-- Empty state --%>
        <.card class="border-border/60 shadow-sm">
          <.card_header>
            <.card_title>Data by Channel</.card_title>
            <.card_description>Select a channel to view the full breakdown</.card_description>
          </.card_header>
          <.card_content class="pt-0">
            <.empty>
              <:icon>
                <div class="flex h-12 w-12 items-center justify-center rounded-full bg-primary/10">
                  <svg class="h-6 w-6 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 013 19.875v-6.75zM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V8.625zM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V4.125z" />
                  </svg>
                </div>
              </:icon>
              <:title>Select a channel</:title>
              <:description>Click on one of the channels in the list above to view the full conversion breakdown.</:description>
              <:action>
                <.button variant={:outline} size={:sm}>View All Channels</.button>
              </:action>
            </.empty>
          </.card_content>
        </.card>

      </div>
    </Layout.layout>
    """
  end

  defp period_label(value, options) do
    case Enum.find(options, &(&1.value == value)) do
      %{label: label} -> label
      nil -> value
    end
  end
end
