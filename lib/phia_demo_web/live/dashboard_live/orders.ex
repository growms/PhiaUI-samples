defmodule PhiaDemoWeb.DashboardLive.Orders do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.DashboardLayout

  @page_size 4

  @impl true
  def mount(_params, _session, socket) do
    orders = FakeData.recent_orders()
    summary = FakeData.order_summary()
    total_pages = max(1, ceil(length(orders) / @page_size))

    {:ok,
     socket
     |> assign(:page_title, "Pedidos")
     |> assign(:orders, orders)
     |> assign(:pagos, Enum.count(orders, &(&1.status == :pago)))
     |> assign(:pendentes, Enum.count(orders, &(&1.status == :pendente)))
     |> assign(:cancelados, Enum.count(orders, &(&1.status == :cancelado)))
     |> assign(:summary, summary)
     |> assign(:page, 1)
     |> assign(:total_pages, total_pages)}
  end

  @impl true
  def handle_event("page-changed", %{"page" => page}, socket) do
    {:noreply, assign(socket, :page, String.to_integer(page))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DashboardLayout.layout current_path="/orders">
      <div class="p-6 space-y-6">
        <%!-- Breadcrumb --%>
        <.breadcrumb>
          <.breadcrumb_list>
            <.breadcrumb_item>
              <.breadcrumb_link href="/">Dashboard</.breadcrumb_link>
            </.breadcrumb_item>
            <.breadcrumb_separator />
            <.breadcrumb_item>
              <.breadcrumb_page>Pedidos</.breadcrumb_page>
            </.breadcrumb_item>
          </.breadcrumb_list>
        </.breadcrumb>

        <%!-- Header + ButtonGroup --%>
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
          <div>
            <h1 class="text-2xl font-bold text-foreground tracking-tight">Pedidos</h1>
            <p class="text-sm text-muted-foreground mt-1">{length(@orders)} pedidos encontrados</p>
          </div>
          <.button_group>
            <.button variant={:outline} size={:sm}>
              <svg class="h-4 w-4 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
              </svg>
              CSV
            </.button>
            <.button variant={:outline} size={:sm}>
              <svg class="h-4 w-4 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              PDF
            </.button>
          </.button_group>
        </div>

        <%!-- Stats --%>
        <.metric_grid cols={4}>
          <.stat_card
            title="Pagos"
            value={to_string(@pagos)}
            trend={:up}
            trend_value="+3 hoje"
            description="pedidos pagos"
          />
          <.stat_card
            title="Pendentes"
            value={to_string(@pendentes)}
            trend={:neutral}
            trend_value="em aberto"
            description="aguardando pagamento"
          />
          <.stat_card
            title="Cancelados"
            value={to_string(@cancelados)}
            trend={:down}
            trend_value="-1 vs ontem"
            description="pedidos cancelados"
          />
          <.stat_card
            title="Receita Total"
            value={@summary.total_revenue}
            trend={:up}
            trend_value="+8,4%"
            description={"ticket médio #{@summary.avg_ticket}"}
          />
        </.metric_grid>

        <%!-- Collapsible status filter --%>
        <.collapsible id="order-filters">
          <.collapsible_trigger
            collapsible_id="order-filters"
            class="flex w-full items-center justify-between rounded-lg border bg-card px-4 py-3 text-sm font-medium shadow-sm hover:bg-accent/50 transition-colors"
          >
            <div class="flex items-center gap-2">
              <svg class="h-4 w-4 text-muted-foreground" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2a1 1 0 01-.293.707L13 13.414V19a1 1 0 01-.553.894l-4 2A1 1 0 017 21v-7.586L3.293 6.707A1 1 0 013 6V4z" />
              </svg>
              <span>Filtrar por Status</span>
            </div>
            <svg class="h-4 w-4 text-muted-foreground transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
            </svg>
          </.collapsible_trigger>
          <.collapsible_content id="order-filters-content">
            <div class="mt-2 rounded-lg border bg-card px-4 py-3 shadow-sm">
              <div class="flex flex-wrap gap-2">
                <.badge variant={:outline} class="cursor-pointer hover:bg-accent transition-colors px-3 py-1">Todos</.badge>
                <.badge variant={:default} class="cursor-pointer px-3 py-1">Pago</.badge>
                <.badge variant={:secondary} class="cursor-pointer px-3 py-1">Pendente</.badge>
                <.badge variant={:destructive} class="cursor-pointer px-3 py-1">Cancelado</.badge>
              </div>
            </div>
          </.collapsible_content>
        </.collapsible>

        <%!-- Orders table --%>
        <.card>
          <.card_header>
            <.card_title>Todos os Pedidos</.card_title>
            <.card_description>Página {@page} de {@total_pages} — {length(@orders)} no total</.card_description>
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
                  <.table_head class="text-right">Ações</.table_head>
                </.table_row>
              </.table_header>
              <.table_body>
                <%= for {o, idx} <- Enum.with_index(page_slice(@orders, @page)) do %>
                  <% tip_id = "order-status-#{@page}-#{idx}" %>
                  <.table_row class={row_class(o.status)}>
                    <.table_cell class="font-mono text-xs font-semibold text-primary">{o.id}</.table_cell>
                    <.table_cell class="font-semibold text-foreground">{o.cliente}</.table_cell>
                    <.table_cell class="text-muted-foreground">{o.produto}</.table_cell>
                    <.table_cell class="font-bold">{o.valor}</.table_cell>
                    <.table_cell>
                      <.tooltip id={tip_id} delay_ms={150}>
                        <.tooltip_trigger tooltip_id={tip_id}>
                          <.badge variant={status_variant(o.status)}>{status_label(o.status)}</.badge>
                        </.tooltip_trigger>
                        <.tooltip_content tooltip_id={tip_id} position={:top}>
                          {status_tooltip(o.status)}
                        </.tooltip_content>
                      </.tooltip>
                    </.table_cell>
                    <.table_cell class="text-muted-foreground text-sm">{o.data}</.table_cell>
                    <.table_cell class="text-right">
                      <button
                        type="button"
                        data-drawer-trigger="order-detail-drawer"
                        class="inline-flex items-center justify-center h-8 px-3 rounded-md text-xs font-medium border border-input bg-background hover:bg-accent hover:text-accent-foreground transition-colors"
                      >
                        Detalhes
                      </button>
                    </.table_cell>
                  </.table_row>
                <% end %>
              </.table_body>
            </.table>
          </.card_content>
          <.card_footer class="pt-4">
            <.pagination>
              <.pagination_content>
                <.pagination_item>
                  <.pagination_previous current_page={@page} total_pages={@total_pages} on_change="page-changed" />
                </.pagination_item>
                <%= for p <- 1..@total_pages do %>
                  <.pagination_item>
                    <.pagination_link page={p} current_page={@page} on_change="page-changed">{p}</.pagination_link>
                  </.pagination_item>
                <% end %>
                <.pagination_item>
                  <.pagination_next current_page={@page} total_pages={@total_pages} on_change="page-changed" />
                </.pagination_item>
              </.pagination_content>
            </.pagination>
          </.card_footer>
        </.card>
      </div>

      <%!-- Order Detail Drawer (client-side trigger) --%>
      <.drawer_content id="order-detail-drawer" open={false} direction="right">
        <.drawer_header>
          <h2 id="order-detail-drawer-title" class="text-lg font-semibold text-foreground">Detalhes do Pedido</h2>
          <p class="text-sm text-muted-foreground mt-1">Informações completas da transação</p>
        </.drawer_header>
        <.drawer_close />
        <div class="px-6 pb-6 space-y-6">
          <div class="flex items-center justify-between">
            <p class="font-mono text-lg font-bold text-primary">#4521</p>
            <.badge variant={:default}>Pago</.badge>
          </div>
          <div class="space-y-3">
            <h3 class="text-sm font-semibold text-foreground">Informações</h3>
            <div class="grid grid-cols-2 gap-3 text-sm">
              <div class="space-y-1">
                <p class="text-muted-foreground">Cliente</p>
                <p class="font-medium">Ana Costa</p>
              </div>
              <div class="space-y-1">
                <p class="text-muted-foreground">Data</p>
                <p class="font-medium">01/03/2026</p>
              </div>
              <div class="space-y-1">
                <p class="text-muted-foreground">Produto</p>
                <p class="font-medium">Plano Pro</p>
              </div>
              <div class="space-y-1">
                <p class="text-muted-foreground">Valor</p>
                <p class="font-bold text-primary">R$ 299,00</p>
              </div>
              <div class="space-y-1">
                <p class="text-muted-foreground">Método</p>
                <p class="font-medium">Cartão de Crédito</p>
              </div>
              <div class="space-y-1">
                <p class="text-muted-foreground">Parcelas</p>
                <p class="font-medium">1x sem juros</p>
              </div>
            </div>
          </div>
          <div class="space-y-3">
            <h3 class="text-sm font-semibold text-foreground">Histórico</h3>
            <div class="space-y-3 text-sm">
              <%= for {step, status} <- [
                {"Pedido criado", :done},
                {"Pagamento confirmado", :done},
                {"Acesso liberado", :done},
                {"NF emitida", :pending}
              ] do %>
                <div class="flex items-center gap-3">
                  <div class={"h-2 w-2 rounded-full shrink-0 #{if status == :done, do: "bg-primary", else: "bg-muted-foreground"}"} />
                  <span class={if status == :done, do: "text-foreground", else: "text-muted-foreground"}>
                    {step}
                  </span>
                  <.badge variant={if status == :done, do: :default, else: :outline} class="ml-auto text-xs">
                    {if status == :done, do: "Concluído", else: "Pendente"}
                  </.badge>
                </div>
              <% end %>
            </div>
          </div>
        </div>
        <.drawer_footer>
          <.button variant={:outline} size={:sm}>Enviar Recibo</.button>
          <.button variant={:default} size={:sm}>Emitir NF</.button>
        </.drawer_footer>
      </.drawer_content>
    </DashboardLayout.layout>
    """
  end

  defp page_slice(orders, page) do
    orders
    |> Enum.drop(@page_size * (page - 1))
    |> Enum.take(@page_size)
  end

  defp row_class(:pago), do: "border-l-2 border-l-primary"
  defp row_class(:pendente), do: "border-l-2 border-l-muted-foreground"
  defp row_class(:cancelado), do: "border-l-2 border-l-destructive"

  defp status_variant(:pago), do: :default
  defp status_variant(:pendente), do: :secondary
  defp status_variant(:cancelado), do: :destructive

  defp status_label(:pago), do: "Pago"
  defp status_label(:pendente), do: "Pendente"
  defp status_label(:cancelado), do: "Cancelado"

  defp status_tooltip(:pago), do: "Pagamento confirmado pelo gateway"
  defp status_tooltip(:pendente), do: "Aguardando confirmação de pagamento"
  defp status_tooltip(:cancelado), do: "Pedido cancelado — sem cobrança"
end
