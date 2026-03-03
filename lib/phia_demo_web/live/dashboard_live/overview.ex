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
     |> assign(:orders, FakeData.recent_orders())
     |> assign(:revenue, FakeData.revenue_by_month())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DashboardLayout.layout current_path="/">
      <div class="p-6 space-y-6">
        <div>
          <h1 class="text-2xl font-semibold text-foreground">Visão Geral</h1>
          <p class="text-sm text-muted-foreground mt-1">Resumo do desempenho do mês</p>
        </div>

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

        <.chart_shell
          title="Receita Mensal"
          description="Últimos 12 meses"
          period="Mar 2025 – Fev 2026"
          min_height="220px"
        >
          <svg viewBox="0 0 420 200" class="w-full h-full">
            <% max_val = Enum.max(Enum.map(@revenue, & &1.value)) %>
            <%= for {item, i} <- Enum.with_index(@revenue) do %>
              <% bar_h = trunc(item.value / max_val * 160) %>
              <% x = i * 35 + 4 %>
              <% y = 170 - bar_h %>
              <rect x={x} y={y} width="28" height={bar_h} class="fill-primary opacity-80" rx="3" />
              <text
                x={x + 14}
                y="190"
                text-anchor="middle"
                class="fill-muted-foreground"
                style="font-size:9px"
              >
                {item.mes}
              </text>
            <% end %>
          </svg>
        </.chart_shell>

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
                  <.table_head>Produto</.table_head>
                  <.table_head>Valor</.table_head>
                  <.table_head>Status</.table_head>
                  <.table_head>Data</.table_head>
                </.table_row>
              </.table_header>
              <.table_body>
                <.table_row :for={o <- @orders}>
                  <.table_cell class="font-mono text-xs">{o.id}</.table_cell>
                  <.table_cell>{o.cliente}</.table_cell>
                  <.table_cell class="text-muted-foreground">{o.produto}</.table_cell>
                  <.table_cell class="font-medium">{o.valor}</.table_cell>
                  <.table_cell><.order_status_badge status={o.status} /></.table_cell>
                  <.table_cell class="text-muted-foreground">{o.data}</.table_cell>
                </.table_row>
              </.table_body>
            </.table>
          </.card_content>
        </.card>
      </div>
    </DashboardLayout.layout>
    """
  end

  defp order_status_badge(assigns) do
    ~H"""
    <.badge variant={status_variant(@status)}>
      {status_label(@status)}
    </.badge>
    """
  end

  defp status_variant(:pago), do: :default
  defp status_variant(:pendente), do: :secondary
  defp status_variant(:cancelado), do: :destructive

  defp status_label(:pago), do: "Pago"
  defp status_label(:pendente), do: "Pendente"
  defp status_label(:cancelado), do: "Cancelado"
end
