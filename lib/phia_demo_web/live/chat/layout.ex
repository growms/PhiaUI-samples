defmodule PhiaDemoWeb.Demo.Chat.Layout do
  @moduledoc "Chat app shell with channel sidebar."

  use Phoenix.Component

  import PhiaUi.Components.Icon
  import PhiaUi.Components.DarkModeToggle
  import PhiaUi.Components.Avatar

  attr :rooms, :list, required: true
  attr :current_room_id, :string, required: true
  attr :users, :list, required: true
  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <div class="flex h-screen overflow-hidden bg-background">
      <%!-- Sidebar --%>
      <aside class="hidden md:flex flex-col w-56 shrink-0 border-r border-border/60 bg-sidebar">
        <%!-- Brand --%>
        <div class="flex items-center gap-2 px-4 py-3 border-b border-border/40">
          <div class="flex h-7 w-7 items-center justify-center rounded-lg bg-primary text-primary-foreground shadow-sm">
            <.icon name="message-circle" size={:xs} />
          </div>
          <div>
            <span class="text-sm font-bold text-foreground leading-none">Chat</span>
            <p class="text-[10px] text-muted-foreground leading-none mt-0.5">PhiaUI Demo</p>
          </div>
        </div>

        <div class="flex-1 overflow-y-auto py-2 space-y-4">
          <%!-- Channels --%>
          <div>
            <p class="px-3 mb-1 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">
              Channels
            </p>
            <%= for room <- @rooms do %>
              <a
                href={"/chat/#{room.id}"}
                class={[
                  "flex items-center gap-2 px-3 py-1.5 mx-1 rounded-md text-sm transition-colors",
                  if(room.id == @current_room_id,
                    do: "bg-primary/10 text-primary font-semibold",
                    else: "text-muted-foreground hover:bg-accent hover:text-foreground"
                  )
                ]}
              >
                <.icon name="hash" size={:xs} class="shrink-0 opacity-70" />
                {room.name}
              </a>
            <% end %>
          </div>

          <%!-- Online users --%>
          <div>
            <p class="px-3 mb-1 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">
              Members
            </p>
            <%= for user <- @users do %>
              <div class="flex items-center gap-2 px-3 py-1.5 mx-1 rounded-md text-sm text-muted-foreground">
                <div class="relative">
                  <.avatar size="sm">
                    <.avatar_fallback name={user.name} class={"#{user.color}/20 text-xs font-semibold"} />
                  </.avatar>
                  <span class={[
                    "absolute -bottom-0.5 -right-0.5 h-2 w-2 rounded-full ring-1 ring-background",
                    case user.status do
                      :online -> "bg-success"
                      :away -> "bg-warning"
                      :offline -> "bg-muted-foreground"
                    end
                  ]} />
                </div>
                <span class="truncate">{user.name}</span>
              </div>
            <% end %>
          </div>

          <%!-- Projects nav --%>
          <div>
            <p class="px-3 mb-1 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">
              Projects
            </p>
            <a href="/dashboard" class="flex items-center gap-2 px-3 py-1.5 mx-1 rounded-md text-sm text-muted-foreground hover:bg-accent hover:text-foreground transition-colors">
              <.icon name="layout-dashboard" size={:xs} class="shrink-0 opacity-70" />
              Dashboard
            </a>
            <a href="/showcase" class="flex items-center gap-2 px-3 py-1.5 mx-1 rounded-md text-sm text-muted-foreground hover:bg-accent hover:text-foreground transition-colors">
              <.icon name="puzzle" size={:xs} class="shrink-0 opacity-70" />
              Showcase
            </a>
          </div>
        </div>
      </aside>

      <%!-- Main content --%>
      <div class="flex flex-col flex-1 min-w-0">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
