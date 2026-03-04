defmodule PhiaDemoWeb.DashboardLive.Overview do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.DashboardLayout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Visão Geral")
     |> assign(:stats, FakeData.stats())
     |> assign(:highlights, FakeData.highlights())
     |> assign(:orders, FakeData.recent_orders())
     |> assign(:revenue, FakeData.revenue_by_month())
     |> assign(:top_products, FakeData.top_products())
     |> assign(:activity, FakeData.activity_log())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DashboardLayout.layout current_path="/">
      <div class="p-6 space-y-6">
        <%!-- Breadcrumb --%>
        <.breadcrumb>
          <.breadcrumb_list>
            <.breadcrumb_item>
              <.breadcrumb_link href="/">Dashboard</.breadcrumb_link>
            </.breadcrumb_item>
            <.breadcrumb_separator />
            <.breadcrumb_item>
              <.breadcrumb_page>Visão Geral</.breadcrumb_page>
            </.breadcrumb_item>
          </.breadcrumb_list>
        </.breadcrumb>

        <%!-- Header --%>
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-bold text-foreground tracking-tight">Visão Geral</h1>
            <p class="text-sm text-muted-foreground mt-1">Resumo do desempenho — Fevereiro 2026</p>
          </div>
          <.badge variant={:default} class="text-xs px-3 py-1">Ao Vivo</.badge>
        </div>

        <%!-- Carousel: Highlights --%>
        <.carousel id="highlights-carousel" loop={true}>
          <.carousel_content>
            <.carousel_item :for={h <- @highlights}>
              <div class="px-1">
                <.card class="border-primary/20 bg-gradient-to-br from-primary/5 to-secondary/50">
                  <.card_content class="p-6">
                    <div class="flex items-start justify-between">
                      <div class="flex-1">
                        <div class="flex items-center gap-2 mb-3">
                          <.badge variant={:default} class="text-xs">{h.badge}</.badge>
                        </div>
                        <p class="text-sm font-medium text-muted-foreground">{h.subtitle}</p>
                        <p class="text-3xl font-bold text-foreground mt-1">{h.stat}</p>
                        <h3 class="text-base font-semibold text-foreground mt-2">{h.title}</h3>
                        <p class="text-sm text-muted-foreground mt-1">{h.detail}</p>
                      </div>
                      <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-primary/10">
                        <.icon name={h.icon} size={:md} class="text-primary" />
                      </div>
                    </div>
                  </.card_content>
                </.card>
              </div>
            </.carousel_item>
          </.carousel_content>
          <.carousel_previous />
          <.carousel_next />
        </.carousel>

        <%!-- Metric Grid --%>
        <.metric_grid cols={4}>
          <.stat_card
            :for={s <- @stats}
            title={s.title}
            value={s.value}
            trend={s.trend}
            trend_value={s.trend_value}
            description={s.description}
          />
        </.metric_grid>

        <%!-- Revenue Chart --%>
        <.chart_shell
          title="Receita Mensal"
          description="Últimos 12 meses — Mar 2025 a Fev 2026"
          period="R$"
          min_height="260px"
        >
          <svg viewBox="0 0 432 220" class="w-full h-full">
            <% max_val = Enum.max(Enum.map(@revenue, & &1.value)) %>
            <%= for pct <- [0.25, 0.5, 0.75, 1.0] do %>
              <% y = 185 - trunc(pct * 160) %>
              <line
                x1="32"
                y1={y}
                x2="430"
                y2={y}
                class="stroke-border"
                stroke-width="1"
                stroke-dasharray="4 4"
              />
              <text x="28" y={y + 4} text-anchor="end" class="fill-muted-foreground" style="font-size:8px">
                {trunc(max_val * pct / 1000)}k
              </text>
            <% end %>
            <%= for {item, i} <- Enum.with_index(@revenue) do %>
              <% bar_h = trunc(item.value / max_val * 160) %>
              <% x = i * 33 + 34 %>
              <% y = 185 - bar_h %>
              <rect x={x} y={y} width="26" height={bar_h} class="fill-primary opacity-80" rx="3" />
              <text
                x={x + 13}
                y="205"
                text-anchor="middle"
                class="fill-muted-foreground"
                style="font-size:8.5px"
              >
                {item.mes}
              </text>
            <% end %>
          </svg>
        </.chart_shell>

        <%!-- Two-column: Orders + Top Products --%>
        <div class="grid gap-6 lg:grid-cols-2">
          <.card>
            <.card_header>
              <.card_title>Pedidos Recentes</.card_title>
              <.card_description>Últimas 10 transações</.card_description>
            </.card_header>
            <.card_content class="p-0">
              <.table>
                <.table_header>
                  <.table_row>
                    <.table_head>ID</.table_head>
                    <.table_head>Cliente</.table_head>
                    <.table_head>Valor</.table_head>
                    <.table_head>Status</.table_head>
                  </.table_row>
                </.table_header>
                <.table_body>
                  <.table_row :for={o <- Enum.take(@orders, 6)}>
                    <.table_cell class="font-mono text-xs">{o.id}</.table_cell>
                    <.table_cell class="font-medium">{o.cliente}</.table_cell>
                    <.table_cell>{o.valor}</.table_cell>
                    <.table_cell>
                      <.badge variant={order_variant(o.status)}>{order_label(o.status)}</.badge>
                    </.table_cell>
                  </.table_row>
                </.table_body>
              </.table>
            </.card_content>
          </.card>

          <.card>
            <.card_header>
              <.card_title>Top Produtos</.card_title>
              <.card_description>Por receita no período</.card_description>
            </.card_header>
            <.card_content>
              <div class="space-y-4">
                <%= for p <- @top_products do %>
                  <div class="space-y-1.5">
                    <div class="flex items-center justify-between text-sm">
                      <span class="font-medium text-foreground">{p.name}</span>
                      <span class="text-muted-foreground text-xs">{p.revenue}</span>
                    </div>
                    <div class="h-2 w-full rounded-full bg-secondary">
                      <div class="h-2 rounded-full bg-primary transition-all" style={"width: #{p.pct}%"} />
                    </div>
                    <p class="text-xs text-muted-foreground">{p.orders} pedidos</p>
                  </div>
                <% end %>
              </div>
            </.card_content>
          </.card>
        </div>

        <%!-- Skeleton loading demo --%>
        <.card>
          <.card_header>
            <.card_title>Estados de Carregamento</.card_title>
            <.card_description>Demonstração do componente <code class="text-xs font-mono bg-muted px-1 py-0.5 rounded">Skeleton</code></.card_description>
          </.card_header>
          <.card_content>
            <div class="grid gap-6 sm:grid-cols-3">
              <%= for _ <- 1..3 do %>
                <div class="flex items-center gap-3">
                  <.skeleton shape={:circle} width="40px" height="40px" />
                  <div class="flex-1 space-y-2">
                    <.skeleton class="h-4 w-3/4" />
                    <.skeleton class="h-3 w-1/2" />
                  </div>
                </div>
              <% end %>
              <div class="sm:col-span-3">
                <.skeleton_text lines={2} />
              </div>
            </div>
          </.card_content>
        </.card>

        <%!-- Accordion: Activity --%>
        <.card>
          <.card_header>
            <.card_title>Atividade Recente</.card_title>
            <.card_description>Últimos eventos da plataforma</.card_description>
          </.card_header>
          <.card_content>
            <.accordion id="activity-accordion" type={:single}>
              <%= for {a, i} <- Enum.with_index(@activity) do %>
                <.accordion_item
                  value={"act-#{i}"}
                  type={:single}
                  accordion_id="activity-accordion"
                >
                  <.accordion_trigger
                    value={"act-#{i}"}
                    type={:single}
                    accordion_id="activity-accordion"
                  >
                    {a.title}
                  </.accordion_trigger>
                  <.accordion_content value={"act-#{i}"}>
                    <div class="flex items-center justify-between text-sm pb-2">
                      <span class="text-muted-foreground">{a.desc}</span>
                      <.badge variant={:outline} class="text-xs">{a.date}</.badge>
                    </div>
                  </.accordion_content>
                </.accordion_item>
              <% end %>
            </.accordion>
          </.card_content>
        </.card>
      </div>
    </DashboardLayout.layout>
    """
  end

  defp order_variant(:pago), do: :default
  defp order_variant(:pendente), do: :secondary
  defp order_variant(:cancelado), do: :destructive

  defp order_label(:pago), do: "Pago"
  defp order_label(:pendente), do: "Pendente"
  defp order_label(:cancelado), do: "Cancelado"
end
