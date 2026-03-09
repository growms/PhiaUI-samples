defmodule PhiaDemoWeb.Demo.Notifications.IndexLive do
  use PhiaDemoWeb, :live_view

  import PhiaDemoWeb.ProjectNav

  @all_notifications [
    %{id: 1,  type: :ticket,  read: false, title: "New Ticket Assigned",
      desc: "You have been assigned to ticket #1234 – Website Redesign",
      time: "5 minutes ago", action: nil,            avatar: nil},
    %{id: 2,  type: :team,    read: false, title: "Joaquina Weisenborn",
      desc: "Requesting access permission",
      time: "12 pm",         action: :accept_decline, avatar: "JW"},
    %{id: 3,  type: :message, read: false, title: "New Message",
      desc: "Sarah Johnson sent you a message in the Website Redesign project",
      time: "1 hour ago",    action: nil,            avatar: nil},
    %{id: 4,  type: :team,    read: true,  title: "Team Update",
      desc: "New team member John Smith has joined the project",
      time: "2 hours ago",   action: nil,            avatar: nil},
    %{id: 5,  type: :ticket,  read: false, title: "Ticket Status Update",
      desc: "Ticket #1235 – Bug Fix has been marked as completed",
      time: "3 hours ago",   action: nil,            avatar: nil},
    %{id: 6,  type: :message, read: false, title: "New Message",
      desc: "Michael Brown mentioned you in a comment on ticket #1236",
      time: "5 hours ago",   action: nil,            avatar: nil},
    %{id: 7,  type: :team,    read: true,  title: "Team Update",
      desc: "Project deadline has been updated to June 15, 2024",
      time: "1 day ago",     action: nil,            avatar: nil},
    %{id: 8,  type: :ticket,  read: true,  title: "New Ticket Created",
      desc: "A new ticket has been created: #1237 – API Integration",
      time: "1 day ago",     action: nil,            avatar: nil},
    %{id: 9,  type: :message, read: true,  title: "New Message",
      desc: "Emily Davis shared a document in the Website Redesign project",
      time: "2 days ago",    action: nil,            avatar: nil},
    %{id: 10, type: :ticket,  read: true,  title: "Ticket Comment Added",
      desc: "David Wilson added a comment on ticket #1236 – Database Migration",
      time: "2 days ago",    action: nil,            avatar: nil},
    %{id: 11, type: :message, read: true,  title: "New Message",
      desc: "Alex Thompson sent you a message about the API Documentation",
      time: "3 days ago",    action: nil,            avatar: nil},
    %{id: 12, type: :ticket,  read: true,  title: "Ticket Resolved",
      desc: "Ticket #1233 – Login Issue has been resolved and closed",
      time: "3 days ago",    action: nil,            avatar: nil},
    %{id: 13, type: :team,    read: true,  title: "Team Update",
      desc: "You have been added to the Mobile App Development team",
      time: "4 days ago",    action: nil,            avatar: nil},
    %{id: 14, type: :message, read: false, title: "New Message",
      desc: "Lisa Chen mentioned you in the design review comments",
      time: "4 days ago",    action: nil,            avatar: nil},
    %{id: 15, type: :ticket,  read: true,  title: "New Ticket Assigned",
      desc: "You have been assigned to ticket #1238 – Performance Optimization",
      time: "5 days ago",    action: nil,            avatar: nil},
    %{id: 16, type: :team,    read: true,  title: "Team Update",
      desc: "Sprint planning meeting scheduled for Monday at 10:00 AM",
      time: "5 days ago",    action: nil,            avatar: nil},
    %{id: 17, type: :message, read: true,  title: "New Message",
      desc: "Robert Kim shared the Q3 report in the Analytics channel",
      time: "6 days ago",    action: nil,            avatar: nil},
    %{id: 18, type: :ticket,  read: true,  title: "Ticket Status Update",
      desc: "Ticket #1232 – UI Improvements has been moved to In Review",
      time: "1 week ago",    action: nil,            avatar: nil},
    %{id: 19, type: :team,    read: false, title: "Team Update",
      desc: "New project kickoff: E-Commerce Platform Redesign",
      time: "1 week ago",    action: nil,            avatar: nil},
    %{id: 20, type: :message, read: true,  title: "New Message",
      desc: "Jennifer Park sent you the updated wireframes for approval",
      time: "1 week ago",    action: nil,            avatar: nil},
    %{id: 21, type: :ticket,  read: true,  title: "Ticket Comment Added",
      desc: "Mark Johnson added a comment on ticket #1230 – Backend Refactoring",
      time: "2 weeks ago",   action: nil,            avatar: nil}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Notifications")
     |> assign(:all_notifications, @all_notifications)
     |> assign(:search, "")
     |> assign(:status_filter, "all")
     |> assign(:type_filter, "all")
     |> assign(:page, 1)
     |> assign(:status_open, false)
     |> assign(:type_open, false)
     |> assign(:view_mode, :list)
     |> recalc()}
  end

  @impl true
  def handle_event("mark-all-read", _, socket) do
    updated = Enum.map(socket.assigns.all_notifications, &%{&1 | read: true})
    {:noreply, socket |> assign(:all_notifications, updated) |> recalc()}
  end

  def handle_event("accept-request", %{"id" => id}, socket) do
    {:noreply, socket |> resolve_action(String.to_integer(id)) |> recalc()}
  end

  def handle_event("decline-request", %{"id" => id}, socket) do
    {:noreply, socket |> resolve_action(String.to_integer(id)) |> recalc()}
  end

  def handle_event("search", %{"query" => q}, socket) do
    {:noreply,
     socket
     |> assign(search: q, page: 1, status_open: false, type_open: false)
     |> recalc()}
  end

  def handle_event("toggle-status-open", _, socket) do
    {:noreply, assign(socket, status_open: !socket.assigns.status_open, type_open: false)}
  end

  def handle_event("toggle-type-open", _, socket) do
    {:noreply, assign(socket, type_open: !socket.assigns.type_open, status_open: false)}
  end

  def handle_event("close-dropdowns", _, socket) do
    {:noreply, assign(socket, status_open: false, type_open: false)}
  end

  def handle_event("filter-status", %{"status" => s}, socket) do
    {:noreply, socket |> assign(status_filter: s, status_open: false, page: 1) |> recalc()}
  end

  def handle_event("filter-type", %{"type" => t}, socket) do
    {:noreply, socket |> assign(type_filter: t, type_open: false, page: 1) |> recalc()}
  end

  def handle_event("set-view", %{"mode" => mode}, socket) do
    {:noreply, assign(socket, :view_mode, String.to_existing_atom(mode))}
  end

  def handle_event("prev-page", _, socket) do
    {:noreply, socket |> update(:page, &max(&1 - 1, 1)) |> recalc()}
  end

  def handle_event("next-page", _, socket) do
    tp = socket.assigns.total_pages
    {:noreply, socket |> update(:page, &min(&1 + 1, tp)) |> recalc()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-background text-foreground">

      <%!-- Transparent backdrop: closes any open dropdown --%>
      <div
        :if={@status_open or @type_open}
        phx-click="close-dropdowns"
        class="fixed inset-0 z-40"
      />

      <%!-- Top navigation bar --%>
      <header class="sticky top-0 z-50 flex h-14 items-center border-b border-border/60 bg-background/95 backdrop-blur px-4">
        <.project_topbar current_project={:notifications} dark_mode_id="notif-dm" />
      </header>

      <%!-- Content --%>
      <main class="p-4 md:p-6 max-w-4xl mx-auto space-y-5">

        <%!-- Page header --%>
        <div class="flex flex-wrap items-center justify-between gap-3 phia-animate">
          <div class="flex items-center gap-3">
            <h1 class="text-xl font-bold text-foreground tracking-tight">Notifications</h1>
            <span
              :if={@unread_count > 0}
              class="inline-flex items-center justify-center rounded-full bg-primary px-2 py-0.5 text-[11px] font-bold text-primary-foreground min-w-[22px]"
            >
              {@unread_count}
            </span>
          </div>
          <div class="flex items-center gap-2">
            <button
              phx-click="mark-all-read"
              class="inline-flex items-center gap-1.5 rounded-lg border border-border px-3 py-2 text-sm font-medium text-foreground hover:bg-accent transition-colors min-h-[44px]"
            >
              <.icon name="check" size={:xs} />
              Mark All as Read
            </button>
            <button class="flex h-9 w-9 items-center justify-center rounded-lg border border-border text-muted-foreground hover:bg-accent transition-colors min-h-[44px] min-w-[44px]">
              <.icon name="settings" size={:xs} />
            </button>
          </div>
        </div>

        <%!-- Filters bar --%>
        <div class="flex flex-wrap items-center gap-2 phia-animate-d1">

          <%!-- Search --%>
          <div class="relative flex-1 min-w-[180px]">
            <.icon
              name="search"
              size={:xs}
              class="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground pointer-events-none"
            />
            <input
              type="text"
              phx-change="search"
              phx-debounce="200"
              name="query"
              value={@search}
              placeholder="Search notifications..."
              class="h-9 w-full rounded-lg border border-border bg-background pl-9 pr-3 text-sm placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary/30"
            />
          </div>

          <%!-- Status dropdown --%>
          <div class="relative z-50">
            <button
              phx-click="toggle-status-open"
              class="inline-flex items-center gap-1.5 rounded-lg border border-border bg-background px-3 h-9 text-sm font-medium text-foreground hover:bg-accent transition-colors whitespace-nowrap"
            >
              {status_label(@status_filter)}
              <.icon
                name="chevron-down"
                size={:xs}
                class={if @status_open, do: "rotate-180 transition-transform duration-150", else: "transition-transform duration-150"}
              />
            </button>
            <div
              :if={@status_open}
              class="absolute top-full mt-1 left-0 w-36 rounded-lg border border-border bg-popover shadow-xl z-50 py-1 overflow-hidden"
            >
              <button
                :for={{val, label} <- [{"all", "All"}, {"unread", "Unread"}, {"read", "Read"}]}
                phx-click="filter-status"
                phx-value-status={val}
                class={[
                  "flex w-full items-center gap-2 px-3 py-2 text-sm hover:bg-accent transition-colors",
                  if(@status_filter == val, do: "text-primary font-semibold", else: "text-foreground")
                ]}
              >
                <span
                  :if={@status_filter == val}
                  class="h-1.5 w-1.5 rounded-full bg-primary shrink-0"
                />
                {label}
              </button>
            </div>
          </div>

          <%!-- Type dropdown --%>
          <div class="relative z-50">
            <button
              phx-click="toggle-type-open"
              class="inline-flex items-center gap-1.5 rounded-lg border border-border bg-background px-3 h-9 text-sm font-medium text-foreground hover:bg-accent transition-colors whitespace-nowrap"
            >
              {type_label(@type_filter)}
              <.icon
                name="chevron-down"
                size={:xs}
                class={if @type_open, do: "rotate-180 transition-transform duration-150", else: "transition-transform duration-150"}
              />
            </button>
            <div
              :if={@type_open}
              class="absolute top-full mt-1 left-0 w-36 rounded-lg border border-border bg-popover shadow-xl z-50 py-1 overflow-hidden"
            >
              <button
                :for={{val, label} <- [{"all", "All"}, {"ticket", "Ticket"}, {"team", "Team"}, {"message", "Message"}]}
                phx-click="filter-type"
                phx-value-type={val}
                class={[
                  "flex w-full items-center gap-2 px-3 py-2 text-sm hover:bg-accent transition-colors",
                  if(@type_filter == val, do: "text-primary font-semibold", else: "text-foreground")
                ]}
              >
                <span
                  :if={@type_filter == val}
                  class="h-1.5 w-1.5 rounded-full bg-primary shrink-0"
                />
                {label}
              </button>
            </div>
          </div>

          <%!-- View mode toggle --%>
          <div class="flex rounded-lg border border-border overflow-hidden">
            <button
              phx-click="set-view"
              phx-value-mode="list"
              aria-label="List view"
              class={[
                "flex h-9 w-9 items-center justify-center transition-colors",
                if(@view_mode == :list,
                  do: "bg-primary text-primary-foreground",
                  else: "text-muted-foreground hover:bg-accent hover:text-foreground")
              ]}
            >
              <.icon name="list" size={:xs} />
            </button>
            <button
              phx-click="set-view"
              phx-value-mode="grid"
              aria-label="Grid view"
              class={[
                "flex h-9 w-9 items-center justify-center transition-colors",
                if(@view_mode == :grid,
                  do: "bg-primary text-primary-foreground",
                  else: "text-muted-foreground hover:bg-accent hover:text-foreground")
              ]}
            >
              <.icon name="layout-grid" size={:xs} />
            </button>
          </div>
        </div>

        <%!-- Empty state --%>
        <div
          :if={@page_notifications == []}
          class="flex flex-col items-center justify-center py-20 text-center phia-animate-d2"
        >
          <div class="flex h-14 w-14 items-center justify-center rounded-full bg-muted/60 mb-4">
            <.icon name="bell" size={:md} class="text-muted-foreground/40" />
          </div>
          <p class="text-sm font-semibold text-foreground">No notifications found</p>
          <p class="text-xs text-muted-foreground mt-1">Try adjusting your filters or search query</p>
        </div>

        <%!-- Notifications card --%>
        <div :if={@page_notifications != []} class="phia-animate-d2">
          <.card class="border-border/60 shadow-sm overflow-hidden">
            <.card_content class="p-0">

              <%!-- List view --%>
              <div :if={@view_mode == :list} class="divide-y divide-border/60">
                <.notif_row :for={n <- @page_notifications} notif={n} />
              </div>

              <%!-- Grid view --%>
              <div
                :if={@view_mode == :grid}
                class="grid grid-cols-1 md:grid-cols-2"
              >
                <div
                  :for={n <- @page_notifications}
                  class="border-b border-border/60 md:odd:border-r"
                >
                  <.notif_row notif={n} />
                </div>
              </div>

            </.card_content>
          </.card>

          <%!-- Pagination --%>
          <div class="flex flex-wrap items-center justify-between gap-3 mt-4">
            <p class="text-sm text-muted-foreground">
              Showing {@page_start} to {@page_end} of {@total_count} notification(s)
            </p>
            <div class="flex items-center gap-2">
              <button
                phx-click="prev-page"
                disabled={@page <= 1}
                class={[
                  "rounded-lg border border-border px-4 py-2 text-sm font-medium transition-colors min-h-[44px]",
                  if(@page <= 1,
                    do: "opacity-40 cursor-not-allowed text-muted-foreground",
                    else: "text-foreground hover:bg-accent")
                ]}
              >
                Previous
              </button>
              <button
                phx-click="next-page"
                disabled={@page >= @total_pages}
                class={[
                  "rounded-lg border border-border px-4 py-2 text-sm font-medium transition-colors min-h-[44px]",
                  if(@page >= @total_pages,
                    do: "opacity-40 cursor-not-allowed text-muted-foreground",
                    else: "text-foreground hover:bg-accent")
                ]}
              >
                Next
              </button>
            </div>
          </div>
        </div>

      </main>
    </div>
    """
  end

  # ── Notification row component ───────────────────────────────────────────────

  attr :notif, :map, required: true

  defp notif_row(assigns) do
    ~H"""
    <div class={[
      "flex items-start gap-4 px-5 py-4 transition-colors hover:bg-muted/30",
      if(!@notif.read, do: "bg-amber-500/[0.06]", else: "")
    ]}>

      <%!-- Avatar / type icon --%>
      <div class={[
        "flex h-10 w-10 shrink-0 items-center justify-center rounded-full text-white text-sm font-bold mt-0.5",
        avatar_bg(@notif)
      ]}>
        <%= if @notif.avatar do %>
          {@notif.avatar}
        <% else %>
          <.icon name={type_icon(@notif.type)} size={:sm} />
        <% end %>
      </div>

      <%!-- Main content --%>
      <div class="flex-1 min-w-0">
        <div class="flex flex-wrap items-start justify-between gap-x-6 gap-y-0.5">
          <div class="min-w-0 flex-1">
            <p class="text-sm font-semibold text-foreground">{@notif.title}</p>
            <p class="text-sm text-muted-foreground mt-0.5 leading-relaxed">{@notif.desc}</p>
            <%!-- Accept / Decline action buttons --%>
            <div :if={@notif.action == :accept_decline} class="flex items-center gap-2 mt-2.5">
              <button
                phx-click="accept-request"
                phx-value-id={@notif.id}
                class="rounded-lg border border-border px-4 py-1.5 text-xs font-semibold text-foreground hover:bg-accent transition-colors min-h-[36px]"
              >
                Accept
              </button>
              <button
                phx-click="decline-request"
                phx-value-id={@notif.id}
                class="rounded-lg bg-red-500 px-4 py-1.5 text-xs font-semibold text-white hover:bg-red-600 transition-colors min-h-[36px]"
              >
                Decline
              </button>
            </div>
          </div>
          <%!-- Type label + time --%>
          <div class="flex items-center gap-4 text-xs text-muted-foreground shrink-0 mt-0.5 whitespace-nowrap">
            <span>{type_text(@notif.type)}</span>
            <span>{@notif.time}</span>
          </div>
        </div>
      </div>

      <%!-- Unread indicator dot --%>
      <div
        :if={!@notif.read}
        class="mt-2.5 h-2 w-2 shrink-0 rounded-full bg-primary"
      />
    </div>
    """
  end

  # ── Private helpers ──────────────────────────────────────────────────────────

  defp resolve_action(socket, id) do
    updated =
      Enum.map(socket.assigns.all_notifications, fn n ->
        if n.id == id, do: %{n | action: nil, read: true}, else: n
      end)
    assign(socket, :all_notifications, updated)
  end

  defp recalc(socket) do
    all    = socket.assigns.all_notifications
    status = socket.assigns.status_filter
    type   = socket.assigns.type_filter
    search = socket.assigns.search
    page   = socket.assigns.page

    filtered =
      all
      |> Enum.filter(&status_match?(&1, status))
      |> Enum.filter(&type_match?(&1, type))
      |> Enum.filter(&search_match?(&1, search))

    total       = length(filtered)
    total_pages = max(1, div(total + 9, 10))
    page        = min(max(page, 1), total_pages)
    offset      = (page - 1) * 10

    socket
    |> assign(:page, page)
    |> assign(:total_count, total)
    |> assign(:total_pages, total_pages)
    |> assign(:page_start, if(total > 0, do: offset + 1, else: 0))
    |> assign(:page_end, min(offset + 10, total))
    |> assign(:page_notifications, Enum.slice(filtered, offset, 10))
    |> assign(:unread_count, Enum.count(all, &(!&1.read)))
  end

  defp status_match?(_n, "all"),    do: true
  defp status_match?(n,  "unread"), do: !n.read
  defp status_match?(n,  "read"),   do: n.read

  defp type_match?(_n, "all"), do: true
  defp type_match?(n,  type),  do: to_string(n.type) == type

  defp search_match?(_n, ""), do: true
  defp search_match?(n, q) do
    q = String.downcase(q)
    String.contains?(String.downcase(n.title), q) or
      String.contains?(String.downcase(n.desc), q)
  end

  defp status_label("all"),    do: "Status"
  defp status_label("unread"), do: "Unread"
  defp status_label("read"),   do: "Read"

  defp type_label("all"),     do: "Type"
  defp type_label("ticket"),  do: "Ticket"
  defp type_label("team"),    do: "Team"
  defp type_label("message"), do: "Message"

  defp type_text(:ticket),  do: "Ticket"
  defp type_text(:team),    do: "Team"
  defp type_text(:message), do: "Message"

  defp type_icon(:ticket),  do: "inbox"
  defp type_icon(:team),    do: "users"
  defp type_icon(:message), do: "message-circle"

  defp avatar_bg(%{avatar: av}) when not is_nil(av), do: "bg-slate-400"
  defp avatar_bg(%{type: :ticket}),                  do: "bg-blue-500"
  defp avatar_bg(%{type: :team}),                    do: "bg-violet-500"
  defp avatar_bg(%{type: :message}),                 do: "bg-emerald-500"
end
