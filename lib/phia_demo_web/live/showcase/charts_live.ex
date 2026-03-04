defmodule PhiaDemoWeb.Demo.Showcase.ChartsLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.Demo.Showcase.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Charts — Showcase")
     |> assign(:stats, FakeData.stats())
     |> assign(:revenue, FakeData.revenue_by_month())
     |> assign(:visits, FakeData.visits_by_month())
     |> assign(:traffic, FakeData.traffic_by_source())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/showcase/charts">
      <div class="p-6 space-y-8 max-w-screen-xl mx-auto">
        <div>
          <h1 class="text-xl font-bold text-foreground tracking-tight">Charts</h1>
          <p class="text-sm text-muted-foreground mt-0.5">SVG-based charts and data visualization components</p>
        </div>

        <%!-- StatCard + MetricGrid --%>
        <.demo_section title="StatCard + MetricGrid" subtitle="KPI cards with trend indicators in a responsive grid">
          <.metric_grid cols={2}>
            <.stat_card :for={s <- Enum.take(@stats, 2)} title={s.title} value={s.value} trend={s.trend} trend_value={s.trend_value} description={s.description} class="border-border/60" />
          </.metric_grid>
        </.demo_section>

        <%!-- Area Chart --%>
        <.demo_section title="Area Chart" subtitle="SVG polygon + polyline with grid lines">
          <.card_header class="p-0 pb-4">
            <div class="flex items-start justify-between">
              <div>
                <.card_title>Monthly Revenue</.card_title>
                <.card_description>Last 12 months</.card_description>
              </div>
              <p class="text-lg font-bold text-foreground">$284,590</p>
            </div>
          </.card_header>
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
          <svg viewBox="0 0 612 190" class="w-full" style="height:200px">
            <%= for pct <- [0.25, 0.5, 0.75, 1.0] do %>
              <% gy = Float.round(165.0 - pct * 135.0, 1) %>
              <line x1="44" y1={gy} x2="592" y2={gy} class="stroke-border" stroke-width="1" stroke-dasharray="4 3" />
              <text x="38" y={gy + 4} text-anchor="end" class="fill-muted-foreground" style="font-size:9px">
                {trunc(max_val * pct / 1000)}k
              </text>
            <% end %>
            <polygon points={area_pts} class="fill-primary" fill-opacity="0.08" />
            <polyline points={line_pts} class="stroke-primary" fill="none" stroke-width="2" stroke-linejoin="round" stroke-linecap="round" />
            <%= for {x, y} <- pts do %>
              <circle cx={x} cy={y} r="3" class="fill-background stroke-primary" stroke-width="1.5" />
            <% end %>
            <%= for {item, i} <- Enum.with_index(@revenue) do %>
              <% lx2 = Float.round(44.0 + i * (548.0 / n), 1) %>
              <text x={lx2} y="183" text-anchor="middle" class="fill-muted-foreground" style="font-size:9px">
                {item.month}
              </text>
            <% end %>
          </svg>
        </.demo_section>

        <%!-- Bar Chart --%>
        <.demo_section title="Bar Chart" subtitle="SVG rect-based vertical bars">
          <% bar_data = Enum.take(@revenue, 6) %>
          <% max_bar = Enum.max(Enum.map(bar_data, & &1.value)) %>
          <% chart_h = 160 %>
          <% bar_w = 36 %>
          <% gap = 20 %>
          <% n_bars = length(bar_data) %>
          <% total_w = n_bars * bar_w + (n_bars - 1) * gap + 40 %>
          <svg viewBox={"0 0 #{total_w} #{chart_h + 30}"} class="w-full" style="height:190px">
            <%= for {item, i} <- Enum.with_index(bar_data) do %>
              <% bar_h = Float.round(item.value / max_bar * chart_h, 1) %>
              <% x = 20 + i * (bar_w + gap) %>
              <% y = chart_h - bar_h %>
              <rect x={x} y={y} width={bar_w} height={bar_h} rx="4" class="fill-primary" fill-opacity="0.8" />
              <text x={x + bar_w / 2} y={chart_h + 15} text-anchor="middle" class="fill-muted-foreground" style="font-size:9px">
                {item.month}
              </text>
              <text x={x + bar_w / 2} y={y - 4} text-anchor="middle" class="fill-primary font-semibold" style="font-size:8px; font-weight:600">
                {trunc(item.value / 1000)}k
              </text>
            <% end %>
          </svg>
        </.demo_section>

        <%!-- Donut Chart --%>
        <.demo_section title="Donut Chart" subtitle="SVG stroke-dasharray technique">
          <div class="flex gap-8 items-center">
            <div class="w-36 h-36 shrink-0">
              <% total = Enum.sum(Enum.map(@traffic, & &1.value)) %>
              <% {_offset, slices} =
                Enum.reduce(@traffic, {0, []}, fn item, {offset, acc} ->
                  pct = item.value / total * 100
                  {offset + pct, [{item, offset, pct} | acc]}
                end) %>
              <svg viewBox="0 0 120 120" class="w-full h-full">
                <%= for {item, offset, pct} <- Enum.reverse(slices) do %>
                  <circle cx="60" cy="60" r="40" fill="none"
                    class={"stroke-current #{String.replace(item.color, "fill-", "text-")}"}
                    stroke-width="20"
                    stroke-dasharray={"#{Float.round(pct * 2.513, 1)} #{100 * 2.513}"}
                    stroke-dashoffset={"-#{Float.round(offset * 2.513, 1)}"}
                    transform="rotate(-90 60 60)"
                  />
                <% end %>
                <text x="60" y="56" text-anchor="middle" class="fill-foreground" style="font-size:12px; font-weight:700">
                  {total}k
                </text>
                <text x="60" y="69" text-anchor="middle" class="fill-muted-foreground" style="font-size:8px">
                  total
                </text>
              </svg>
            </div>
            <ul class="space-y-2 text-sm">
              <%= for item <- @traffic do %>
                <li class="flex items-center justify-between gap-4">
                  <span class="flex items-center gap-2">
                    <span class={"inline-block w-2.5 h-2.5 rounded-full #{item.color}"} />
                    <span class="text-foreground">{item.source}</span>
                  </span>
                  <span class="font-semibold text-muted-foreground">{item.value}%</span>
                </li>
              <% end %>
            </ul>
          </div>
        </.demo_section>

        <%!-- ChartShell --%>
        <.demo_section title="ChartShell" subtitle="Card wrapper for chart content with header metadata">
          <.chart_shell
            title="Monthly Visitors"
            description="Unique visitors per month"
            period="Last 12 months"
            min_height="200px"
          >
            <svg viewBox="0 0 420 200" class="w-full h-full">
              <% max_val = Enum.max(Enum.map(@visits, & &1.value)) %>
              <% n = length(@visits) - 1 %>
              <% coords = Enum.with_index(@visits) |> Enum.map(fn {item, i} ->
                x = Float.round(18.0 + i * (384.0 / n), 1)
                y = Float.round(170.0 - item.value / max_val * 150.0, 1)
                {x, y}
              end) %>
              <% line_pts = Enum.map_join(coords, " ", fn {x, y} -> "#{x},#{y}" end) %>
              <% {fx, _} = List.first(coords) %>
              <% {lx, _} = List.last(coords) %>
              <% area_pts = "#{fx},170 #{line_pts} #{lx},170" %>
              <polygon points={area_pts} class="fill-primary" fill-opacity="0.08" />
              <polyline points={line_pts} class="stroke-primary fill-none" stroke-width="2" stroke-linejoin="round" stroke-linecap="round" />
              <%= for {item, {x, y}} <- Enum.zip(@visits, coords) do %>
                <circle cx={x} cy={y} r="3" class="fill-background stroke-primary" stroke-width="1.5" />
                <text x={x} y="190" text-anchor="middle" class="fill-muted-foreground" style="font-size:9px">
                  {item.month}
                </text>
              <% end %>
            </svg>
          </.chart_shell>
        </.demo_section>

      </div>
    </Layout.layout>
    """
  end

  attr :title, :string, required: true
  attr :subtitle, :string, required: true
  slot :inner_block, required: true

  defp demo_section(assigns) do
    ~H"""
    <div class="space-y-4">
      <div>
        <h2 class="text-base font-semibold text-foreground">{@title}</h2>
        <p class="text-xs text-muted-foreground mt-0.5">{@subtitle}</p>
      </div>
      <div class="rounded-xl border border-border/60 bg-card p-5 shadow-sm">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
