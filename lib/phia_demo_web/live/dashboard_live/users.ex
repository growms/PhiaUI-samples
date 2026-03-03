defmodule PhiaDemoWeb.DashboardLive.Users do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.DashboardLayout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Usuários")
     |> assign(:users, FakeData.users())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DashboardLayout.layout current_path="/users">
      <div class="p-6 space-y-6">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-semibold text-foreground">Usuários</h1>
            <p class="text-sm text-muted-foreground mt-1">{length(@users)} usuários cadastrados</p>
          </div>
          <.button variant={:default} size={:sm}>
            + Novo Usuário
          </.button>
        </div>

        <.card>
          <.card_content class="p-0">
            <.table>
              <.table_header>
                <.table_row>
                  <.table_head>Usuário</.table_head>
                  <.table_head>E-mail</.table_head>
                  <.table_head>Papel</.table_head>
                  <.table_head>Status</.table_head>
                  <.table_head>Cadastro</.table_head>
                  <.table_head class="text-right">Ações</.table_head>
                </.table_row>
              </.table_header>
              <.table_body>
                <.table_row :for={u <- @users}>
                  <.table_cell>
                    <div class="flex items-center gap-3">
                      <div class="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-primary text-primary-foreground text-xs font-semibold">
                        {String.first(u.nome)}
                      </div>
                      <span class="font-medium text-foreground">{u.nome}</span>
                    </div>
                  </.table_cell>
                  <.table_cell class="text-muted-foreground">{u.email}</.table_cell>
                  <.table_cell>
                    <.badge variant={role_variant(u.role)}>{u.role}</.badge>
                  </.table_cell>
                  <.table_cell>
                    <.badge variant={user_status_variant(u.status)}>
                      {user_status_label(u.status)}
                    </.badge>
                  </.table_cell>
                  <.table_cell class="text-muted-foreground">{u.cadastro}</.table_cell>
                  <.table_cell class="text-right">
                    <div class="flex items-center justify-end gap-2">
                      <.button variant={:ghost} size={:sm}>Editar</.button>
                      <.button variant={:ghost} size={:sm} class="text-destructive hover:text-destructive">
                        Remover
                      </.button>
                    </div>
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

  defp role_variant("Admin"), do: :default
  defp role_variant("Editor"), do: :secondary
  defp role_variant(_), do: :outline

  defp user_status_variant(:ativo), do: :default
  defp user_status_variant(:inativo), do: :outline
  defp user_status_variant(:pendente), do: :secondary

  defp user_status_label(:ativo), do: "Ativo"
  defp user_status_label(:inativo), do: "Inativo"
  defp user_status_label(:pendente), do: "Pendente"
end
