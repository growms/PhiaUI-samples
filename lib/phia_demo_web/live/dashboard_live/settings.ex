defmodule PhiaDemoWeb.DashboardLive.Settings do
  @moduledoc """
  Settings page demonstrating Accordion, Alert, DarkModeToggle,
  Badge, ButtonGroup, Skeleton, Tooltip and Card composition patterns.
  """

  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.DashboardLayout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Configurações")
     |> assign(:saved, false)
     |> assign(:notifications_email, true)
     |> assign(:notifications_browser, false)
     |> assign(:notifications_weekly, true)
     |> assign(:loading_profile, false)}
  end

  @impl true
  def handle_event("save_profile", _params, socket) do
    {:noreply,
     socket
     |> assign(:loading_profile, true)
     |> then(fn s ->
       # Simula delay de gravação (demo)
       Process.send_after(self(), :profile_saved, 800)
       s
     end)}
  end

  @impl true
  def handle_event("toggle_notification", %{"key" => key}, socket) do
    key_atom = String.to_existing_atom("notifications_#{key}")
    {:noreply, update(socket, key_atom, &(!&1))}
  end

  @impl true
  def handle_event("discard", _params, socket) do
    {:noreply,
     socket
     |> assign(:saved, false)
     |> push_event("phia-toast", %{
       title: "Descartado",
       description: "As alterações foram descartadas.",
       variant: "default",
       duration_ms: 3000
     })}
  end

  @impl true
  def handle_info(:profile_saved, socket) do
    {:noreply,
     socket
     |> assign(:loading_profile, false)
     |> assign(:saved, true)
     |> push_event("phia-toast", %{
       title: "Configurações salvas",
       description: "Seu perfil foi atualizado com sucesso.",
       variant: "default",
       duration_ms: 4000
     })}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DashboardLayout.layout current_path="/settings">
      <div class="p-6 space-y-6">
        <%!-- Breadcrumb --%>
        <.breadcrumb>
          <.breadcrumb_list>
            <.breadcrumb_item>
              <.breadcrumb_link href="/">Dashboard</.breadcrumb_link>
            </.breadcrumb_item>
            <.breadcrumb_separator />
            <.breadcrumb_item>
              <.breadcrumb_page>Configurações</.breadcrumb_page>
            </.breadcrumb_item>
          </.breadcrumb_list>
        </.breadcrumb>

        <%!-- Header --%>
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-bold text-foreground tracking-tight">Configurações</h1>
            <p class="text-sm text-muted-foreground mt-1">Gerencie sua conta e preferências da plataforma</p>
          </div>
          <.badge variant={if @saved, do: :default, else: :outline}>
            {if @saved, do: "Salvo", else: "Não salvo"}
          </.badge>
        </div>

        <%!-- Saved success alert --%>
        <%= if @saved do %>
          <.alert variant={:success}>
            <.alert_title>Configurações atualizadas</.alert_title>
            <.alert_description>Suas alterações foram salvas e estão ativas imediatamente.</.alert_description>
          </.alert>
        <% end %>

        <%!-- Settings sections via Accordion --%>
        <.accordion id="settings-accordion" type={:single}>

          <%!-- Perfil --%>
          <.accordion_item value="profile" type={:single} accordion_id="settings-accordion">
            <.accordion_trigger value="profile" type={:single} accordion_id="settings-accordion">
              <div class="flex items-center gap-3">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10">
                  <.icon name="user" size={:sm} class="text-primary" />
                </div>
                <div class="text-left">
                  <p class="font-semibold text-foreground">Perfil</p>
                  <p class="text-xs text-muted-foreground font-normal">Nome, e-mail e foto</p>
                </div>
              </div>
            </.accordion_trigger>
            <.accordion_content value="profile">
              <.card class="mt-2 border-0 shadow-none bg-muted/20">
                <.card_content class="p-4 space-y-4">
                  <div class="flex items-center gap-4">
                    <.avatar size="lg" class="ring-2 ring-primary/20">
                      <.avatar_fallback name="Admin Costa" class="bg-primary/15 text-primary font-bold" />
                    </.avatar>
                    <div>
                      <p class="font-semibold text-foreground">Admin Costa</p>
                      <p class="text-sm text-muted-foreground">admin@acme.com</p>
                    </div>
                    <.button variant={:outline} size={:sm} class="ml-auto">Alterar foto</.button>
                  </div>
                  <div class="grid gap-3 sm:grid-cols-2">
                    <div class="space-y-1.5">
                      <label class="text-sm font-medium text-foreground">Nome completo</label>
                      <input
                        type="text"
                        value="Admin Costa"
                        class="flex h-9 w-full rounded-md border border-input bg-background px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                      />
                    </div>
                    <div class="space-y-1.5">
                      <label class="text-sm font-medium text-foreground">E-mail</label>
                      <input
                        type="email"
                        value="admin@acme.com"
                        class="flex h-9 w-full rounded-md border border-input bg-background px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                      />
                    </div>
                    <div class="space-y-1.5 sm:col-span-2">
                      <label class="text-sm font-medium text-foreground">Cargo / Função</label>
                      <input
                        type="text"
                        value="Administrador"
                        class="flex h-9 w-full rounded-md border border-input bg-background px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                      />
                    </div>
                  </div>
                  <div class="flex justify-end">
                    <%= if @loading_profile do %>
                      <.button variant={:default} size={:sm} disabled>
                        <.skeleton class="h-4 w-24" />
                      </.button>
                    <% else %>
                      <.button variant={:default} size={:sm} phx-click="save_profile">
                        Salvar Perfil
                      </.button>
                    <% end %>
                  </div>
                </.card_content>
              </.card>
            </.accordion_content>
          </.accordion_item>

          <%!-- Notificações --%>
          <.accordion_item value="notifications" type={:single} accordion_id="settings-accordion">
            <.accordion_trigger value="notifications" type={:single} accordion_id="settings-accordion">
              <div class="flex items-center gap-3">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10">
                  <.icon name="bell" size={:sm} class="text-primary" />
                </div>
                <div class="text-left">
                  <p class="font-semibold text-foreground">Notificações</p>
                  <p class="text-xs text-muted-foreground font-normal">E-mail, push e resumos</p>
                </div>
              </div>
            </.accordion_trigger>
            <.accordion_content value="notifications">
              <.card class="mt-2 border-0 shadow-none bg-muted/20">
                <.card_content class="p-4 space-y-4">
                  <%= for {key, label, desc} <- [
                    {"email", "Notificações por e-mail", "Receba alertas e atualizações no seu e-mail"},
                    {"browser", "Notificações no navegador", "Alertas push no navegador (requer permissão)"},
                    {"weekly", "Resumo semanal", "Relatório condensado enviado toda segunda-feira"}
                  ] do %>
                    <% current_val = Map.get(assigns, String.to_existing_atom("notifications_#{key}")) %>
                    <div class="flex items-start justify-between gap-4">
                      <div>
                        <p class="text-sm font-medium text-foreground">{label}</p>
                        <p class="text-xs text-muted-foreground mt-0.5">{desc}</p>
                      </div>
                      <button
                        type="button"
                        phx-click="toggle_notification"
                        phx-value-key={key}
                        class={"relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 #{if current_val, do: "bg-primary", else: "bg-input"}"}
                        role="switch"
                        aria-checked={to_string(current_val)}
                      >
                        <span class={"pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow-lg ring-0 transition-transform #{if current_val, do: "translate-x-5", else: "translate-x-0"}"} />
                      </button>
                    </div>
                  <% end %>
                </.card_content>
              </.card>
            </.accordion_content>
          </.accordion_item>

          <%!-- Aparência --%>
          <.accordion_item value="appearance" type={:single} accordion_id="settings-accordion">
            <.accordion_trigger value="appearance" type={:single} accordion_id="settings-accordion">
              <div class="flex items-center gap-3">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10">
                  <.icon name="sun-moon" size={:sm} class="text-primary" />
                </div>
                <div class="text-left">
                  <p class="font-semibold text-foreground">Aparência</p>
                  <p class="text-xs text-muted-foreground font-normal">Tema e preferências visuais</p>
                </div>
              </div>
            </.accordion_trigger>
            <.accordion_content value="appearance">
              <.card class="mt-2 border-0 shadow-none bg-muted/20">
                <.card_content class="p-4 space-y-4">
                  <div class="flex items-center justify-between">
                    <div>
                      <p class="text-sm font-medium text-foreground">Modo escuro</p>
                      <p class="text-xs text-muted-foreground mt-0.5">Alterna entre o tema claro e escuro</p>
                    </div>
                    <.dark_mode_toggle id="settings-theme-toggle" />
                  </div>
                  <div class="flex items-center justify-between">
                    <div>
                      <p class="text-sm font-medium text-foreground">Densidade de interface</p>
                      <p class="text-xs text-muted-foreground mt-0.5">Controla o espaçamento e tamanho dos elementos</p>
                    </div>
                    <select class="h-9 rounded-md border border-input bg-background px-3 text-sm focus:outline-none focus:ring-2 focus:ring-ring">
                      <option>Confortável</option>
                      <option>Compacto</option>
                      <option>Espaçoso</option>
                    </select>
                  </div>
                </.card_content>
              </.card>
            </.accordion_content>
          </.accordion_item>

          <%!-- Segurança --%>
          <.accordion_item value="security" type={:single} accordion_id="settings-accordion">
            <.accordion_trigger value="security" type={:single} accordion_id="settings-accordion">
              <div class="flex items-center gap-3">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-destructive/10">
                  <.icon name="shield" size={:sm} class="text-destructive" />
                </div>
                <div class="text-left">
                  <p class="font-semibold text-foreground">Segurança</p>
                  <p class="text-xs text-muted-foreground font-normal">Senha, 2FA e sessões ativas</p>
                </div>
              </div>
            </.accordion_trigger>
            <.accordion_content value="security">
              <.card class="mt-2 border-0 shadow-none bg-muted/20">
                <.card_content class="p-4 space-y-4">
                  <.alert variant={:warning}>
                    <.alert_title>Autenticação de dois fatores desativada</.alert_title>
                    <.alert_description>
                      Recomendamos ativar o 2FA para maior segurança da sua conta.
                    </.alert_description>
                  </.alert>
                  <div class="space-y-2">
                    <.button variant={:default} size={:sm}>Ativar 2FA</.button>
                    <.button variant={:outline} size={:sm} class="ml-2">Alterar Senha</.button>
                  </div>
                  <div class="space-y-2">
                    <p class="text-sm font-medium text-foreground">Sessões ativas</p>
                    <%= for {device, ip, active} <- [
                      {"Chrome — macOS", "187.x.x.x", true},
                      {"Safari — iPhone", "177.x.x.x", false},
                      {"Firefox — Windows", "189.x.x.x", false}
                    ] do %>
                      <div class="flex items-center justify-between text-sm rounded-md border px-3 py-2 bg-background">
                        <div>
                          <p class="font-medium text-foreground">{device}</p>
                          <p class="text-xs text-muted-foreground">{ip}</p>
                        </div>
                        <.badge variant={if active, do: :default, else: :outline} class="text-xs">
                          {if active, do: "Esta sessão", else: "Ativa"}
                        </.badge>
                      </div>
                    <% end %>
                  </div>
                </.card_content>
              </.card>
            </.accordion_content>
          </.accordion_item>

        </.accordion>

        <%!-- Actions footer --%>
        <.card class="border-dashed">
          <.card_content class="p-4">
            <div class="flex items-center justify-between">
              <p class="text-sm text-muted-foreground">
                Todas as alterações são salvas imediatamente quando você clica em <strong class="text-foreground">Salvar</strong>.
              </p>
              <.button_group>
                <.button variant={:outline} size={:sm} phx-click="discard">Descartar</.button>
                <.button variant={:default} size={:sm} phx-click="save_profile">Salvar Tudo</.button>
              </.button_group>
            </div>
          </.card_content>
        </.card>
      </div>
    </DashboardLayout.layout>
    """
  end
end
