defmodule PhiaDemoWeb.DashboardLayout do
  @moduledoc "Reusable dashboard shell component with sidebar navigation."

  use Phoenix.Component

  import PhiaUi.Components.Shell
  import PhiaUi.Components.Icon
  import PhiaUi.Components.DarkModeToggle
  import PhiaUi.Components.Tooltip
  import PhiaUi.Components.Avatar

  attr :current_path, :string, required: true
  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <.shell>
      <:topbar>
        <.mobile_sidebar_toggle />
        <span class="ml-2 font-semibold text-foreground tracking-tight">PhiaUI Demo</span>
        <div class="ml-auto flex items-center gap-3">
          <.dark_mode_toggle id="theme-toggle" />
          <div class="hidden sm:flex items-center gap-2.5">
            <.avatar size="sm" class="ring-2 ring-primary/20">
              <.avatar_fallback name="Admin Costa" class="bg-primary/15 text-primary font-semibold" />
            </.avatar>
            <div class="leading-none">
              <p class="text-sm font-semibold text-foreground">Admin Costa</p>
              <p class="text-xs text-muted-foreground mt-0.5">Administrador</p>
            </div>
          </div>
        </div>
      </:topbar>
      <:sidebar>
        <.sidebar>
          <:brand>
            <div class="flex items-center gap-2.5">
              <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground shadow-sm">
                <.icon name="layers" size={:sm} />
              </div>
              <div>
                <span class="text-sm font-bold text-foreground leading-none">PhiaUI</span>
                <p class="text-xs text-muted-foreground leading-none mt-0.5">v0.1.3 Demo</p>
              </div>
            </div>
          </:brand>
          <:nav_items>
            <div class="px-3 mb-1">
              <p class="text-xs font-semibold text-muted-foreground uppercase tracking-wider">Dashboard</p>
            </div>
            <.nav_item current_path={@current_path} href="/" icon="layout-dashboard" label="Visão Geral" />
            <.nav_item current_path={@current_path} href="/analytics" icon="bar-chart-2" label="Analytics" />
            <.nav_item current_path={@current_path} href="/users" icon="users" label="Usuários" />
            <.nav_item current_path={@current_path} href="/orders" icon="package" label="Pedidos" />
            <div class="px-3 mt-4 mb-1">
              <p class="text-xs font-semibold text-muted-foreground uppercase tracking-wider">Showcase</p>
            </div>
            <.nav_item current_path={@current_path} href="/components" icon="puzzle" label="Componentes" />
            <.nav_item current_path={@current_path} href="/settings" icon="sliders-horizontal" label="Configurações" />
          </:nav_items>
          <:footer_items>
            <div class="px-3 mb-1">
              <p class="text-xs text-muted-foreground">PhiaUI © 2026</p>
            </div>
          </:footer_items>
        </.sidebar>
      </:sidebar>
      <%= render_slot(@inner_block) %>
    </.shell>
    """
  end

  # ── Private: single nav item with tooltip ─────────────────────────────────

  attr :current_path, :string, required: true
  attr :href, :string, required: true
  attr :icon, :string, required: true
  attr :label, :string, required: true

  defp nav_item(assigns) do
    ~H"""
    <.tooltip id={"tip-#{@icon}"} delay_ms={400}>
      <.tooltip_trigger tooltip_id={"tip-#{@icon}"}>
        <.sidebar_item href={@href} active={@current_path == @href}>
          <.icon name={@icon} size={:sm} class="shrink-0" />
          {@label}
        </.sidebar_item>
      </.tooltip_trigger>
      <.tooltip_content tooltip_id={"tip-#{@icon}"} position={:right}>{@label}</.tooltip_content>
    </.tooltip>
    """
  end
end
