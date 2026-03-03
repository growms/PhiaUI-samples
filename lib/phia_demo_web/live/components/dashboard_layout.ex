defmodule PhiaDemoWeb.DashboardLayout do
  @moduledoc "Reusable dashboard shell component with sidebar navigation."

  use Phoenix.Component

  import PhiaUi.Components.Shell

  attr :current_path, :string, required: true
  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <.shell>
      <:topbar>
        <.mobile_sidebar_toggle />
        <span class="ml-2 font-semibold text-foreground">PhiaUI Demo</span>
        <div class="ml-auto flex items-center gap-3">
          <span class="text-sm text-muted-foreground">Admin</span>
        </div>
      </:topbar>
      <:sidebar>
        <.sidebar>
          <:brand>
            <span class="text-lg font-bold text-foreground">⬡ PhiaUI</span>
          </:brand>
          <:nav_items>
            <.sidebar_item href="/" active={@current_path == "/"}>
              Visão Geral
            </.sidebar_item>
            <.sidebar_item href="/analytics" active={@current_path == "/analytics"}>
              Analytics
            </.sidebar_item>
            <.sidebar_item href="/users" active={@current_path == "/users"}>
              Usuários
            </.sidebar_item>
            <.sidebar_item href="/orders" active={@current_path == "/orders"}>
              Pedidos
            </.sidebar_item>
          </:nav_items>
          <:footer_items>
            <.sidebar_item href="#" active={false}>
              Configurações
            </.sidebar_item>
          </:footer_items>
        </.sidebar>
      </:sidebar>
      <%= render_slot(@inner_block) %>
    </.shell>
    """
  end
end
