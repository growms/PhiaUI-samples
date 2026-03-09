defmodule PhiaDemoWeb.Demo.Profile.V1Live do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Profile.Layout

  @transactions [
    %{product: "Mock premium pack",            status: "pending", date: "12/10/2025", amount: "$35"},
    %{product: "Enterprise plan subscription", status: "paid",    date: "11/13/2025", amount: "$155"},
    %{product: "Business board pro license",   status: "paid",    date: "10/13/2025", amount: "$85"},
    %{product: "Custom integration package",   status: "failed",  date: "09/13/2025", amount: "$295"},
    %{product: "Developer toolkit license",    status: "paid",    date: "08/15/2025", amount: "$125"},
    %{product: "Support package renewal",      status: "pending", date: "07/22/2025", amount: "$75"}
  ]

  @connections [
    %{name: "Olivia Davis",    email: "olivia.davis@example.com",    connected: false, color: "bg-orange-500"},
    %{name: "John Doe",        email: "john.doe@example.com",        connected: true,  color: "bg-blue-500"},
    %{name: "Alice Smith",     email: "alice.smith@example.com",     connected: false, color: "bg-violet-500"},
    %{name: "Emily Martinez",  email: "emily.martinez@example.com",  connected: true,  color: "bg-rose-500"},
    %{name: "James Wilson",    email: "james.wilson@example.com",    connected: true,  color: "bg-emerald-500"}
  ]

  @activities [
    %{
      title:  "Shadcn UI Kit Application UI v2.0.0",
      badge:  "Latest",
      date:   "Released on December 2nd, 2025",
      desc:   "Get access to over 20+ pages including a dashboard layout, charts, kanban board, calendar, and pre-order E-commerce & Marketing pages.",
      action: "Download ZIP"
    },
    %{
      title: "Shadcn UI Kit Figma v1.3.0",
      badge: nil,
      date:  "Released on December 2nd, 2025",
      desc:  "All of the pages and components are first designed in Figma and we keep a parity between the two versions even as we update the project.",
      action: nil
    },
    %{
      title: "Shadcn UI Kit Library v1.2.2",
      badge: nil,
      date:  "Released on December 2nd, 2025",
      desc:  "Get started with dozens of web components and interactive elements built on top of Tailwind CSS.",
      action: nil
    }
  ]

  @skills ["Photoshop", "Figma", "HTML", "React", "Tailwind CSS", "CSS", "Laravel", "Node.js"]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Profile V1")
     |> assign(:active_tab, "Overview")
     |> assign(:transactions, @transactions)
     |> assign(:connections, @connections)
     |> assign(:activities, @activities)
     |> assign(:skills, @skills)}
  end

  @impl true
  def handle_event("switch-tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :active_tab, tab)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/profile">
      <div class="p-4 md:p-6 space-y-5 max-w-screen-xl mx-auto">

        <%!-- Page Header --%>
        <div class="flex items-center justify-between phia-animate">
          <h1 class="text-xl font-bold text-foreground tracking-tight">Profile Page</h1>
          <button class="inline-flex items-center gap-1.5 rounded-lg border border-border px-3 py-2 text-sm font-medium text-foreground hover:bg-accent transition-colors min-h-[44px]">
            <.icon name="settings" size={:xs} />
            Settings
          </button>
        </div>

        <%!-- Tabs --%>
        <div class="flex items-center gap-0.5 border-b border-border/60 phia-animate-d1">
          <%= for tab <- ["Overview", "Projects", "Activities", "Members"] do %>
            <button
              phx-click="switch-tab"
              phx-value-tab={tab}
              class={[
                "px-4 py-2.5 text-sm font-medium transition-colors -mb-px border-b-2 min-h-[44px]",
                if tab == @active_tab do
                  "border-primary text-primary"
                else
                  "border-transparent text-muted-foreground hover:text-foreground"
                end
              ]}
            >
              {tab}
            </button>
          <% end %>
        </div>

        <%!-- Main layout: profile card + right content --%>
        <div class="grid grid-cols-1 lg:grid-cols-[340px_1fr] gap-5 phia-animate-d2">

          <%!-- Left — Profile Card --%>
          <.card class="border-border/60 shadow-sm self-start">
            <.card_content class="p-6 flex flex-col items-center text-center">

              <%!-- Avatar --%>
              <div class="h-20 w-20 rounded-full bg-gradient-to-br from-amber-400 to-rose-500 flex items-center justify-center text-white text-2xl font-bold mb-4 ring-4 ring-background shadow-lg shrink-0">
                AH
              </div>

              <%!-- Name + Pro badge + title --%>
              <div class="flex items-center gap-2 mb-1">
                <h2 class="text-lg font-bold text-foreground">Anshan Haso</h2>
                <span class="inline-flex items-center rounded-full bg-primary px-2 py-0.5 text-[10px] font-bold text-primary-foreground leading-none">
                  Pro
                </span>
              </div>
              <p class="text-sm text-muted-foreground mb-6">Project Manager</p>

              <%!-- Stats row --%>
              <div class="flex w-full justify-around border-t border-border/60 pt-5 mb-6">
                <div class="text-center">
                  <p class="text-xl font-bold text-foreground tabular-nums">184</p>
                  <p class="text-xs text-muted-foreground mt-0.5">Post</p>
                </div>
                <div class="w-px bg-border/60" />
                <div class="text-center">
                  <p class="text-xl font-bold text-foreground tabular-nums">32</p>
                  <p class="text-xs text-muted-foreground mt-0.5">Projects</p>
                </div>
                <div class="w-px bg-border/60" />
                <div class="text-center">
                  <p class="text-xl font-bold text-foreground tabular-nums">4.5K</p>
                  <p class="text-xs text-muted-foreground mt-0.5">Members</p>
                </div>
              </div>

              <%!-- Contact info --%>
              <div class="w-full space-y-3 text-left mb-6">
                <div class="flex items-center gap-2.5 text-sm text-muted-foreground">
                  <.icon name="send" size={:xs} class="shrink-0 text-muted-foreground/60" />
                  <span class="truncate">hello@tobybelhome.com</span>
                </div>
                <div class="flex items-center gap-2.5 text-sm text-muted-foreground">
                  <.icon name="message-circle" size={:xs} class="shrink-0 text-muted-foreground/60" />
                  <span>(+1-876) 8654 239 581</span>
                </div>
                <div class="flex items-center gap-2.5 text-sm text-muted-foreground">
                  <.icon name="home" size={:xs} class="shrink-0 text-muted-foreground/60" />
                  <span>Canada</span>
                </div>
                <div class="flex items-center gap-2.5 text-sm text-muted-foreground">
                  <.icon name="link" size={:xs} class="shrink-0 text-muted-foreground/60" />
                  <span class="truncate">https://shadcnuikit.com</span>
                </div>
                <div class="flex items-center gap-2.5 text-sm text-muted-foreground">
                  <.icon name="link" size={:xs} class="shrink-0 text-muted-foreground/60" />
                  <span class="truncate">https://bundui.io/</span>
                </div>
              </div>

              <%!-- Complete Your Profile --%>
              <div class="w-full mb-6">
                <div class="flex items-center justify-between mb-2">
                  <p class="text-sm font-semibold text-foreground">Complete Your Profile</p>
                  <span class="text-xs text-muted-foreground">3/6</span>
                </div>
                <div class="h-2 w-full rounded-full bg-muted overflow-hidden">
                  <div class="h-full rounded-full bg-primary transition-all" style="width: 50%" />
                </div>
              </div>

              <%!-- Skills --%>
              <div class="w-full text-left">
                <p class="text-sm font-semibold text-foreground mb-3">Skills</p>
                <div class="flex flex-wrap gap-2">
                  <span
                    :for={skill <- @skills}
                    class="inline-flex items-center rounded-md border border-border bg-muted/50 px-2.5 py-1 text-xs font-medium text-foreground"
                  >
                    {skill}
                  </span>
                </div>
              </div>

            </.card_content>
          </.card>

          <%!-- Right — Activity + Transactions + Connections --%>
          <div class="space-y-5 min-w-0">

            <%!-- Latest Activity --%>
            <.card class="border-border/60 shadow-sm">
              <.card_header class="pb-3">
                <div class="flex items-center justify-between">
                  <.card_title>Latest Activity</.card_title>
                  <button class="text-sm font-medium text-primary hover:text-primary/80 transition-colors">
                    View All
                  </button>
                </div>
              </.card_header>
              <.card_content class="px-6 pb-6 space-y-5">
                <%= for activity <- @activities do %>
                  <div class="flex gap-3 pb-5 last:pb-0 border-b border-border/40 last:border-b-0">
                    <div class="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-primary/10">
                      <.icon name="layers" size={:xs} class="text-primary" />
                    </div>
                    <div class="flex-1 min-w-0">
                      <div class="flex flex-wrap items-center gap-2 mb-1">
                        <p class="text-sm font-semibold text-foreground">{activity.title}</p>
                        <span
                          :if={activity.badge}
                          class="inline-flex items-center rounded-full bg-emerald-500/10 px-2 py-0.5 text-[10px] font-bold text-emerald-600 dark:text-emerald-400"
                        >
                          {activity.badge}
                        </span>
                      </div>
                      <p class="text-xs text-muted-foreground mb-1.5 flex items-center gap-1">
                        <.icon name="calendar" size={:xs} />
                        {activity.date}
                      </p>
                      <p class="text-sm text-muted-foreground leading-relaxed">{activity.desc}</p>
                      <button
                        :if={activity.action}
                        class="mt-3 inline-flex items-center gap-1.5 rounded-lg border border-border px-3 py-1.5 text-xs font-medium text-foreground hover:bg-accent transition-colors"
                      >
                        <.icon name="upload" size={:xs} class="rotate-180" />
                        {activity.action}
                      </button>
                    </div>
                  </div>
                <% end %>
              </.card_content>
            </.card>

            <%!-- Transaction History + Connections (side by side on md+) --%>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">

              <%!-- Transaction History --%>
              <.card class="border-border/60 shadow-sm">
                <.card_header class="pb-3">
                  <.card_title>Transaction History</.card_title>
                </.card_header>
                <.card_content class="p-0">
                  <div class="overflow-x-auto">
                    <table class="w-full text-sm min-w-[360px]">
                      <thead>
                        <tr class="border-b border-border/60 text-xs text-muted-foreground font-medium">
                          <th class="px-4 py-2.5 text-left">Product</th>
                          <th class="px-4 py-2.5 text-left">Status</th>
                          <th class="px-4 py-2.5 text-left whitespace-nowrap">Date</th>
                          <th class="px-4 py-2.5 text-right whitespace-nowrap">Amt</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr
                          :for={t <- @transactions}
                          class="border-b border-border/40 last:border-b-0 hover:bg-muted/30 transition-colors"
                        >
                          <td class="px-4 py-3 font-medium text-foreground text-xs max-w-[130px] truncate">
                            {t.product}
                          </td>
                          <td class="px-4 py-3">
                            <span class={[
                              "inline-flex items-center rounded-full px-2 py-0.5 text-[10px] font-semibold whitespace-nowrap",
                              case t.status do
                                "paid"    -> "bg-emerald-500/10 text-emerald-700 dark:text-emerald-400"
                                "pending" -> "bg-amber-500/10 text-amber-700 dark:text-amber-400"
                                "failed"  -> "bg-red-500/10 text-red-700 dark:text-red-400"
                                _         -> "bg-muted text-muted-foreground"
                              end
                            ]}>
                              {t.status}
                            </span>
                          </td>
                          <td class="px-4 py-3 text-xs text-muted-foreground whitespace-nowrap">{t.date}</td>
                          <td class="px-4 py-3 text-xs font-semibold text-foreground text-right tabular-nums">
                            {t.amount}
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </.card_content>
              </.card>

              <%!-- Connections --%>
              <.card class="border-border/60 shadow-sm">
                <.card_header class="pb-3">
                  <.card_title>Connections</.card_title>
                </.card_header>
                <.card_content class="px-6 pb-5 space-y-4">
                  <div
                    :for={conn <- @connections}
                    class="flex items-center gap-3"
                  >
                    <div class={"flex h-9 w-9 shrink-0 items-center justify-center rounded-full text-white text-sm font-bold " <> conn.color}>
                      {String.first(conn.name)}
                    </div>
                    <div class="flex-1 min-w-0">
                      <p class="text-sm font-semibold text-foreground truncate">{conn.name}</p>
                      <p class="text-xs text-muted-foreground truncate">{conn.email}</p>
                    </div>
                    <button class={[
                      "shrink-0 rounded-lg border px-3 py-1.5 text-xs font-semibold transition-colors min-h-[36px]",
                      if conn.connected do
                        "border-border text-muted-foreground hover:bg-accent hover:text-foreground"
                      else
                        "border-primary/40 bg-primary/10 text-primary hover:bg-primary hover:text-primary-foreground"
                      end
                    ]}>
                      {if conn.connected, do: "Disconnect", else: "Connect"}
                    </button>
                  </div>
                </.card_content>
              </.card>

            </div>
          </div>
        </div>

      </div>
    </Layout.layout>
    """
  end
end
