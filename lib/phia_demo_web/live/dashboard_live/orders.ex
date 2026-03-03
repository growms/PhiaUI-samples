defmodule PhiaDemoWeb.DashboardLive.Orders do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.DashboardLayout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Pedidos")
     |> assign(:orders, FakeData.recent_orders())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DashboardLayout.layout current_path="/orders">
      <div class="p-6 space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-semibold text-foreground">Pedidos</h1>
            <p class="text-sm text-muted-foreground mt-1">{length(@orders)} pedidos encontrados</p>
          </div>
          <div class="flex items-center gap-2">
            <.button variant={:outline} size={:sm}>Exportar CSV</.button>
            <.button variant={:default} size={:sm}>+ Novo Pedido</.button>
          </div>
        </div>

        <div class="grid gap-4 sm:grid-cols-3">
          <.card>
            <.card_content class="pt-6">
              <div class="text-2xl font-bold text-foreground">
                {Enum.count(@orders, &(&1.status == :pago))}
              </div>
              <p class="text-sm text-muted-foreground">Pagos</p>
            </.card_content>
          </.card>
          <.card>
            <.card_content class="pt-6">
              <div class="text-2xl font-bold text-foreground">
                {Enum.count(@orders, &(&1.status == :pendente))}
              </div>
              <p class="text-sm text-muted-foreground">Pendentes</p>
            </.card_content>
          </.card>
          <.card>
            <.card_content class="pt-6">
              <div class="text-2xl font-bold text-foreground">
                {Enum.count(@orders, &(&1.status == :cancelado))}
              </div>
              <p class="text-sm text-muted-foreground">Cancelados</p>
            </.card_content>
          </.card>
        </div>

        <.card>
          <.card_header>
            <.card_title>Todos os Pedidos</.card_title>
            <.card_description>Lista completa de transações</.card_description>
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
                <.table_row :for={o <- @orders}>
                  <.table_cell class="font-mono text-xs font-medium">{o.id}</.table_cell>
                  <.table_cell class="font-medium">{o.cliente}</.table_cell>
                  <.table_cell class="text-muted-foreground">{o.produto}</.table_cell>
                  <.table_cell class="font-semibold">{o.valor}</.table_cell>
                  <.table_cell>
                    <.badge variant={status_variant(o.status)}>
                      {status_label(o.status)}
                    </.badge>
                  </.table_cell>
                  <.table_cell class="text-muted-foreground">{o.data}</.table_cell>
                  <.table_cell class="text-right">
                    <.button variant={:ghost} size={:sm}>Ver</.button>
                  </.table_cell>
                </.table_row>
              </.table_body>
            </.table>
          </.card_content>
        </.card>
      </div>
    </DashboardLayout.layout>
    """
  end

  defp status_variant(:pago), do: :default
  defp status_variant(:pendente), do: :secondary
  defp status_variant(:cancelado), do: :destructive

  defp status_label(:pago), do: "Pago"
  defp status_label(:pendente), do: "Pendente"
  defp status_label(:cancelado), do: "Cancelado"
end
