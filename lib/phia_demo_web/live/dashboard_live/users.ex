defmodule PhiaDemoWeb.DashboardLive.Users do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.FakeData
  alias PhiaDemoWeb.DashboardLayout

  @page_size 4

  @impl true
  def mount(_params, _session, socket) do
    all_users = FakeData.users()

    {:ok,
     socket
     |> assign(:page_title, "Usuários")
     |> assign(:all_users, all_users)
     |> assign(:role_options, FakeData.role_options())
     |> assign(:role_filter, "all")
     |> assign(:role_open, false)
     |> assign(:role_search, "")
     |> assign(:page, 1)
     |> assign(:confirm_delete_user_id, nil)
     |> recalc_users(all_users, "all", 1)}
  end

  @impl true
  def handle_event("role-toggle", _params, socket) do
    {:noreply, update(socket, :role_open, &(!&1))}
  end

  @impl true
  def handle_event("role-search", %{"query" => q}, socket) do
    {:noreply, assign(socket, :role_search, q)}
  end

  @impl true
  def handle_event("role-change", %{"value" => v}, socket) do
    users = apply_filter(socket.assigns.all_users, v)
    {:noreply, socket |> assign(role_filter: v, role_open: false, role_search: "", page: 1) |> recalc_users(users, v, 1)}
  end

  @impl true
  def handle_event("page-changed", %{"page" => page}, socket) do
    page = String.to_integer(page)
    users = apply_filter(socket.assigns.all_users, socket.assigns.role_filter)
    {:noreply, socket |> assign(:page, page) |> recalc_users(users, socket.assigns.role_filter, page)}
  end

  @impl true
  def handle_event("init_delete", %{"id" => id}, socket) do
    {:noreply, assign(socket, :confirm_delete_user_id, String.to_integer(id))}
  end

  @impl true
  def handle_event("cancel_delete", _params, socket) do
    {:noreply, assign(socket, :confirm_delete_user_id, nil)}
  end

  @impl true
  def handle_event("delete_user", _params, socket) do
    user_id = socket.assigns.confirm_delete_user_id
    all_users = Enum.reject(socket.assigns.all_users, &(&1.id == user_id))
    users = apply_filter(all_users, socket.assigns.role_filter)
    total_pages = max(1, ceil(length(users) / @page_size))
    page = min(socket.assigns.page, total_pages)

    {:noreply,
     socket
     |> assign(:all_users, all_users)
     |> assign(:confirm_delete_user_id, nil)
     |> recalc_users(users, socket.assigns.role_filter, page)
     |> push_event("phia-toast", %{
       title: "Usuário removido",
       description: "O usuário foi removido com sucesso.",
       variant: "destructive",
       duration_ms: 4000
     })}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DashboardLayout.layout current_path="/users">
      <div class="p-6 space-y-6">
        <%!-- Breadcrumb --%>
        <.breadcrumb>
          <.breadcrumb_list>
            <.breadcrumb_item>
              <.breadcrumb_link href="/">Dashboard</.breadcrumb_link>
            </.breadcrumb_item>
            <.breadcrumb_separator />
            <.breadcrumb_item>
              <.breadcrumb_page>Usuários</.breadcrumb_page>
            </.breadcrumb_item>
          </.breadcrumb_list>
        </.breadcrumb>

        <%!-- Header --%>
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
          <div>
            <h1 class="text-2xl font-bold text-foreground tracking-tight">Usuários</h1>
            <p class="text-sm text-muted-foreground mt-1">{length(@all_users)} usuários cadastrados</p>
          </div>
          <.dialog id="new-user-dialog">
            <.dialog_trigger for="new-user-dialog">
              <.button variant={:default} size={:sm}>
                <svg class="h-4 w-4 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4" />
                </svg>
                Novo Usuário
              </.button>
            </.dialog_trigger>
            <.dialog_content id="new-user-dialog">
              <.dialog_header>
                <.dialog_title id="new-user-dialog-title">Novo Usuário</.dialog_title>
                <.dialog_description id="new-user-dialog-description">
                  Preencha os dados para convidar um novo usuário para a plataforma.
                </.dialog_description>
              </.dialog_header>
              <div class="grid gap-4 py-4">
                <div class="grid gap-1.5">
                  <label class="text-sm font-medium text-foreground" for="new-user-name">Nome completo</label>
                  <input
                    id="new-user-name"
                    type="text"
                    placeholder="Ex: Maria Silva"
                    class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                  />
                </div>
                <div class="grid gap-1.5">
                  <label class="text-sm font-medium text-foreground" for="new-user-email">E-mail</label>
                  <input
                    id="new-user-email"
                    type="email"
                    placeholder="email@empresa.com"
                    class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                  />
                </div>
                <div class="grid gap-1.5">
                  <label class="text-sm font-medium text-foreground" for="new-user-role">Papel</label>
                  <select
                    id="new-user-role"
                    class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                  >
                    <option>Admin</option>
                    <option>Editor</option>
                    <option>Viewer</option>
                  </select>
                </div>
              </div>
              <.dialog_footer>
                <.dialog_close
                  for="new-user-dialog"
                  class="inline-flex items-center justify-center border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2 rounded-md text-sm font-medium transition-colors"
                >
                  Cancelar
                </.dialog_close>
                <.button variant={:default}>Enviar Convite</.button>
              </.dialog_footer>
            </.dialog_content>
          </.dialog>
        </div>

        <%!-- Stats --%>
        <.metric_grid cols={3}>
          <.stat_card
            title="Ativos"
            value={to_string(@ativos)}
            trend={:up}
            trend_value="+2 este mês"
            description="usuários ativos"
          />
          <.stat_card
            title="Inativos"
            value={to_string(@inativos)}
            trend={:neutral}
            trend_value="sem mudança"
            description="usuários inativos"
          />
          <.stat_card
            title="Pendentes"
            value={to_string(@pendentes)}
            trend={:neutral}
            trend_value="aguardando"
            description="aprovação pendente"
          />
        </.metric_grid>

        <%!-- Pending alert --%>
        <%= if @pendentes > 0 do %>
          <.alert variant={:warning}>
            <.alert_title>Usuários aguardando aprovação</.alert_title>
            <.alert_description>
              {@pendentes} {if @pendentes == 1, do: "usuário precisa", else: "usuários precisam"} de revisão antes de acessar a plataforma.
            </.alert_description>
          </.alert>
        <% end %>

        <%!-- Filter bar --%>
        <div class="flex items-center justify-between gap-4">
          <div class="w-56">
            <.combobox
              id="role-filter-combobox"
              options={@role_options}
              value={@role_filter}
              open={@role_open}
              search={@role_search}
              placeholder="Filtrar por papel..."
              search_placeholder="Buscar papel..."
              on_change="role-change"
              on_search="role-search"
              on_toggle="role-toggle"
            />
          </div>
          <p class="text-sm text-muted-foreground">{length(@filtered_users)} resultado(s)</p>
        </div>

        <%!-- Users table + Drawer for details --%>
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
                <.table_row :for={u <- @visible_users}>
                  <.table_cell>
                    <div class="flex items-center gap-3">
                      <.avatar size="sm" class="ring-2 ring-primary/20">
                        <.avatar_fallback name={u.nome} class="bg-primary/15 text-primary text-xs font-semibold" />
                      </.avatar>
                      <span class="font-semibold text-foreground">{u.nome}</span>
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
                  <.table_cell class="text-muted-foreground text-sm">{u.cadastro}</.table_cell>
                  <.table_cell class="text-right">
                    <div class="flex items-center justify-end gap-1">
                      <%!-- Drawer trigger: opens user detail panel --%>
                      <button
                        type="button"
                        data-drawer-trigger="user-detail-drawer"
                        class="inline-flex items-center justify-center h-8 px-3 rounded-md text-xs font-medium border border-input bg-background hover:bg-accent hover:text-accent-foreground transition-colors"
                      >
                        Ver
                      </button>
                      <.dropdown_menu id={"user-menu-#{u.id}"}>
                        <.dropdown_menu_trigger class="h-8 w-8 p-0 inline-flex items-center justify-center rounded-md hover:bg-accent hover:text-accent-foreground transition-colors">
                          <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                            <circle cx="12" cy="5" r="1.5" />
                            <circle cx="12" cy="12" r="1.5" />
                            <circle cx="12" cy="19" r="1.5" />
                          </svg>
                          <span class="sr-only">Ações para {u.nome}</span>
                        </.dropdown_menu_trigger>
                        <.dropdown_menu_content>
                          <.dropdown_menu_label>Ações</.dropdown_menu_label>
                          <.dropdown_menu_separator />
                          <.dropdown_menu_group>
                            <.dropdown_menu_item>Editar Perfil</.dropdown_menu_item>
                            <.dropdown_menu_item>Redefinir Senha</.dropdown_menu_item>
                            <.dropdown_menu_item>
                              {if u.status == :ativo, do: "Desativar Conta", else: "Reativar Conta"}
                            </.dropdown_menu_item>
                          </.dropdown_menu_group>
                          <.dropdown_menu_separator />
                          <.dropdown_menu_item
                            class="text-destructive focus:text-destructive"
                            phx-click={JS.push("init_delete", value: %{id: u.id})}
                          >
                            Remover Usuário
                          </.dropdown_menu_item>
                        </.dropdown_menu_content>
                      </.dropdown_menu>
                    </div>
                  </.table_cell>
                </.table_row>
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

      <%!-- User Detail Drawer (client-side trigger) --%>
      <.drawer_content id="user-detail-drawer" open={false} direction="right">
        <.drawer_header>
          <h2 id="user-detail-drawer-title" class="text-lg font-semibold text-foreground">Perfil do Usuário</h2>
          <p class="text-sm text-muted-foreground mt-1">Detalhes e histórico da conta</p>
        </.drawer_header>
        <.drawer_close />
        <div class="px-6 pb-6 space-y-6">
          <div class="flex items-center gap-4">
            <.avatar size="lg" class="ring-2 ring-primary/20">
              <.avatar_fallback name="Ana Costa" class="bg-primary/15 text-primary font-semibold text-lg" />
            </.avatar>
            <div>
              <p class="font-semibold text-foreground text-lg">Ana Costa</p>
              <p class="text-sm text-muted-foreground">ana@acme.com</p>
              <div class="flex items-center gap-2 mt-1">
                <.badge variant={:default}>Admin</.badge>
                <.badge variant={:default}>Ativo</.badge>
              </div>
            </div>
          </div>
          <div class="space-y-3">
            <h3 class="text-sm font-semibold text-foreground">Informações da Conta</h3>
            <div class="grid grid-cols-2 gap-3 text-sm">
              <div class="space-y-1">
                <p class="text-muted-foreground">ID</p>
                <p class="font-mono font-medium">#1001</p>
              </div>
              <div class="space-y-1">
                <p class="text-muted-foreground">Cadastro</p>
                <p class="font-medium">Jan 2024</p>
              </div>
              <div class="space-y-1">
                <p class="text-muted-foreground">Último acesso</p>
                <p class="font-medium">Hoje, 07:42</p>
              </div>
              <div class="space-y-1">
                <p class="text-muted-foreground">Plano</p>
                <p class="font-medium">Enterprise</p>
              </div>
            </div>
          </div>
          <div class="space-y-3">
            <h3 class="text-sm font-semibold text-foreground">Atividade Recente</h3>
            <div class="space-y-2 text-sm">
              <%= for {event, color} <- [
                {"Login — IP 187.x.x.x", "bg-primary"},
                {"Relatório exportado", "bg-secondary"},
                {"Configurações atualizadas", "bg-secondary"},
                {"Senha redefinida", "bg-destructive"}
              ] do %>
                <div class="flex items-center gap-3">
                  <div class={"h-2 w-2 rounded-full #{color} shrink-0"} />
                  <span class="text-foreground flex-1">{event}</span>
                </div>
              <% end %>
            </div>
          </div>
        </div>
        <.drawer_footer>
          <.button variant={:outline} size={:sm}>Editar Perfil</.button>
          <.button variant={:destructive} size={:sm}>Desativar</.button>
        </.drawer_footer>
      </.drawer_content>

      <%!-- Confirm Delete Dialog --%>
      <.alert_dialog
        id="confirm-delete-dialog"
        open={@confirm_delete_user_id != nil}
        aria-labelledby="confirm-delete-title"
        aria-describedby="confirm-delete-desc"
      >
        <.alert_dialog_header>
          <.alert_dialog_title id="confirm-delete-title">Remover usuário</.alert_dialog_title>
          <.alert_dialog_description id="confirm-delete-desc">
            Esta ação é permanente. O usuário será removido e perderá acesso à plataforma imediatamente.
          </.alert_dialog_description>
        </.alert_dialog_header>
        <.alert_dialog_footer>
          <.alert_dialog_cancel phx-click="cancel_delete">Cancelar</.alert_dialog_cancel>
          <.alert_dialog_action variant="destructive" phx-click="delete_user">
            Remover Permanentemente
          </.alert_dialog_action>
        </.alert_dialog_footer>
      </.alert_dialog>
    </DashboardLayout.layout>
    """
  end

  # ── Private ──────────────────────────────────────────────────────────────

  defp recalc_users(socket, filtered_users, _role, page) do
    total_pages = max(1, ceil(length(filtered_users) / @page_size))
    page = min(page, total_pages)
    all = socket.assigns.all_users

    socket
    |> assign(:filtered_users, filtered_users)
    |> assign(:visible_users, page_slice(filtered_users, page))
    |> assign(:page, page)
    |> assign(:total_pages, total_pages)
    |> assign(:ativos, Enum.count(all, &(&1.status == :ativo)))
    |> assign(:inativos, Enum.count(all, &(&1.status == :inativo)))
    |> assign(:pendentes, Enum.count(all, &(&1.status == :pendente)))
  end

  defp apply_filter(users, "all"), do: users
  defp apply_filter(users, role), do: Enum.filter(users, &(&1.role == role))

  defp page_slice(users, page) do
    users
    |> Enum.drop(@page_size * (page - 1))
    |> Enum.take(@page_size)
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
