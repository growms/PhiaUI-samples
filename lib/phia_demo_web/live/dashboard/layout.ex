defmodule PhiaDemoWeb.Demo.Dashboard.Layout do
  @moduledoc "Dashboard shell component with sidebar navigation."

  use Phoenix.Component

  import PhiaUi.Components.Shell
  import PhiaUi.Components.Icon
  import PhiaUi.Components.DarkModeToggle
  import PhiaUi.Components.Avatar

  attr :current_path, :string, required: true
  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <.shell>
      <:topbar>
        <.mobile_sidebar_toggle />
        <div class="ml-auto flex items-center gap-3">
          <.dark_mode_toggle id="theme-toggle" />
          <div class="hidden sm:flex items-center gap-2.5">
            <.avatar size="sm" class="ring-2 ring-primary/20">
              <.avatar_fallback name="Admin User" class="bg-primary/10 text-primary text-xs font-semibold" />
            </.avatar>
            <div class="leading-none">
              <p class="text-sm font-semibold text-foreground">Admin User</p>
              <p class="text-xs text-muted-foreground mt-0.5">Administrator</p>
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
                <p class="text-[10px] text-muted-foreground leading-none mt-0.5 font-medium">v0.1.3 · Dashboard</p>
              </div>
            </div>
          </:brand>
          <:nav_items>
            <.nav_section label="Dashboard">
              <.nav_item current_path={@current_path} href="/dashboard" icon="layout-dashboard" label="Overview" />
              <.nav_item current_path={@current_path} href="/dashboard/analytics" icon="chart-bar" label="Analytics" />
              <.nav_item current_path={@current_path} href="/dashboard/users" icon="users" label="Users" />
              <.nav_item current_path={@current_path} href="/dashboard/orders" icon="package" label="Orders" />
              <.nav_item current_path={@current_path} href="/dashboard/settings" icon="sliders-horizontal" label="Settings" />
            </.nav_section>
            <.nav_section label="Projects">
              <.nav_item current_path={@current_path} href="/showcase" icon="puzzle" label="Showcase" />
              <.nav_item current_path={@current_path} href="/chat" icon="message-circle" label="Chat" />
            </.nav_section>
          </:nav_items>
          <:footer_items>
            <div class="px-3 py-1">
              <p class="text-[10px] text-muted-foreground/60 font-medium">PhiaUI &copy; 2026</p>
            </div>
          </:footer_items>
        </.sidebar>
      </:sidebar>
      <%= render_slot(@inner_block) %>
    </.shell>
    """
  end

  # ── Private: section label ─────────────────────────────────────────────────

  attr :label, :string, required: true
  slot :inner_block, required: true

  defp nav_section(assigns) do
    ~H"""
    <div class="mb-4">
      <p class="px-3 mb-1.5 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">
        {@label}
      </p>
      <div class="space-y-0.5">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  # ── Private: single nav item ───────────────────────────────────────────────

  attr :current_path, :string, required: true
  attr :href, :string, required: true
  attr :icon, :string, required: true
  attr :label, :string, required: true

  defp nav_item(assigns) do
    active = assigns.current_path == assigns.href
    assigns = assign(assigns, :active, active)

    ~H"""
    <a
      href={@href}
      class={[
        "group flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm transition-all duration-150",
        if(@active,
          do: "bg-primary/10 text-primary font-semibold shadow-sm",
          else: "font-medium text-muted-foreground hover:bg-accent hover:text-foreground"
        )
      ]}
    >
      <.icon
        name={@icon}
        size={:sm}
        class={if(@active, do: "shrink-0 text-primary", else: "shrink-0 text-muted-foreground/70 group-hover:text-foreground")}
      />
      {@label}
    </a>
    """
  end
end
