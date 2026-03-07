defmodule PhiaDemoWeb.Demo.AiChatV2.Layout do
  @moduledoc "AI Chat V2 app shell layout."

  use Phoenix.Component

  import PhiaUi.Components.Shell
  import PhiaUi.Components.Icon
  import PhiaDemoWeb.ProjectNav

  attr :current_path, :string, required: true
  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <.shell>
      <:topbar>
        <.mobile_sidebar_toggle />
        <.project_topbar current_project={:ai_chat_v2} dark_mode_id="aichatv2-dm" />
      </:topbar>
      <:sidebar>
        <.sidebar>
          <:brand>
            <div class="flex items-center gap-2.5">
              <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground shadow-sm">
                <.icon name="message-square" size={:sm} />
              </div>
              <div>
                <span class="text-sm font-bold text-foreground leading-none">AI Chat v2</span>
                <p class="text-[10px] text-muted-foreground leading-none mt-0.5 font-medium">Advanced Interface</p>
              </div>
            </div>
          </:brand>
          <:nav_items>
            <.nav_section label="Workspace">
              <.nav_item current_path={@current_path} href="/ai-chat-v2" icon="message-square" label="Chat" />
              <.nav_item current_path={@current_path} href="/ai-chat-v2" icon="settings" label="Model Settings" />
            </.nav_section>
            <.nav_section label="History">
              <.nav_item current_path={@current_path} href="/ai-chat-v2" icon="message-circle" label="All conversations" />
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

  attr :label, :string, required: true
  slot :inner_block, required: true

  defp nav_section(assigns) do
    ~H"""
    <div class="mb-4">
      <p class="px-3 mb-1.5 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/50">
        {@label}
      </p>
      <div class="space-y-0.5">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

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
        "group relative flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm transition-all duration-150",
        if(@active,
          do: "bg-primary/10 text-primary font-semibold",
          else: "font-medium text-muted-foreground hover:bg-accent hover:text-foreground"
        )
      ]}
    >
      <span :if={@active} class="absolute left-0 top-1/2 -translate-y-1/2 h-5 w-0.5 rounded-r-full bg-primary" />
      <.icon name={@icon} size={:sm} class={if(@active, do: "shrink-0 text-primary", else: "shrink-0 text-muted-foreground/60 group-hover:text-foreground")} />
      <span class="flex-1">{@label}</span>
    </a>
    """
  end
end
