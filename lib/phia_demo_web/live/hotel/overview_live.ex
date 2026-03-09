defmodule PhiaDemoWeb.Demo.Hotel.OverviewLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Hotel.Layout

  @bookings [
    %{id: "LG-B00108", guest: "Angus Copper",      type: "Deluxe",   room: "Room 101", nights: 3, dates: "June 19–22, 2028", status: "Checked-In"},
    %{id: "LG-B00109", guest: "Catherine Lopp",    type: "Standard", room: "Room 202", nights: 2, dates: "June 19–21, 2028", status: "Checked-In"},
    %{id: "LG-B00110", guest: "Edgar Irving",      type: "Suite",    room: "Room 303", nights: 5, dates: "June 19–24, 2028", status: "Pending"},
    %{id: "LG-B00111", guest: "Ice B. Holand",     type: "Standard", room: "Room 105", nights: 4, dates: "June 19–23, 2028", status: "Checked-In"}
  ]

  @activities [
    %{name: "Wade Warren",      initials: "WW", color: "bg-teal-500",    desc: "Room #2747, requested for a coffee and water",          time: "16 mins"},
    %{name: "Esther Howard",    initials: "EH", color: "bg-violet-500",  desc: "Room #3565, Book and manage conference room for meeting", time: "24 mins"},
    %{name: "Leslie Alexander", initials: "LA", color: "bg-emerald-500", desc: "Room #3546, Provide information about local restaurants", time: "32 mins"},
    %{name: "Guy Hawkins",      initials: "GH", color: "bg-amber-500",   desc: "Room #5654, Allow guests to view and settle their bills", time: "48 mins"}
  ]

  @campaign_labels ["25 Nov", "26 Nov", "27 Nov", "28 Nov", "29 Nov", "30 Nov", "01 Dec"]
  @campaign_data   [120, 180, 140, 210, 170, 240, 195]

  @revenue_labels ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"]
  @revenue_data   [3200, 4100, 2800, 5200, 3900, 4700, 2100]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Hotel — Overview")
     |> assign(:bookings, @bookings)
     |> assign(:activities, @activities)
     |> assign(:campaign_labels, @campaign_labels)
     |> assign(:campaign_data, @campaign_data)
     |> assign(:revenue_labels, @revenue_labels)
     |> assign(:revenue_data, @revenue_data)
     |> assign(:revenue_period, "W")}
  end

  @impl true
  def handle_event("revenue-period", %{"period" => period}, socket) do
    {:noreply, assign(socket, :revenue_period, period)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/hotel">
      <div class="p-4 md:p-6 space-y-6 max-w-screen-2xl mx-auto">

        <%!-- Header --%>
        <div class="flex flex-wrap items-center justify-between gap-3 phia-animate">
          <h1 class="text-xl font-bold text-foreground tracking-tight">Hotel Management</h1>
          <div class="flex items-center gap-2">
            <button class="inline-flex items-center gap-1.5 rounded-lg border border-border px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-accent hover:text-foreground transition-colors min-h-[44px]">
              <.icon name="file-text" size={:xs} />
              Reports
            </button>
            <button class="inline-flex items-center gap-1.5 rounded-lg bg-primary px-3 py-2 text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors min-h-[44px]">
              <.icon name="plus" size={:xs} />
              Add New
            </button>
          </div>
        </div>

        <%!-- Stat Cards --%>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-3 sm:gap-4 phia-animate-d1">
          <div class="rounded-xl p-5 text-white space-y-1 bg-teal-700 shadow-sm">
            <div class="flex items-center justify-between">
              <span class="text-xs font-medium text-white/80">Today's check-in</span>
              <.icon name="clock" size={:sm} class="text-white/70" />
            </div>
            <p class="text-3xl font-bold tabular-nums">200</p>
            <p class="text-xs text-white/70">Unit Number: 1,000</p>
          </div>

          <div class="rounded-xl p-5 text-white space-y-1 bg-emerald-700 shadow-sm">
            <div class="flex items-center justify-between">
              <span class="text-xs font-medium text-white/80">Today check-out</span>
              <.icon name="log-out" size={:sm} class="text-white/70" />
            </div>
            <p class="text-3xl font-bold tabular-nums">34</p>
            <p class="text-xs text-white/70">Unit Number: 520</p>
          </div>

          <div class="rounded-xl p-5 text-white space-y-1 bg-pink-700 shadow-sm">
            <div class="flex items-center justify-between">
              <span class="text-xs font-medium text-white/80">Total guests</span>
              <.icon name="users" size={:sm} class="text-white/70" />
            </div>
            <p class="text-3xl font-bold tabular-nums">3,432</p>
            <p class="text-xs text-white/70">Unit Number: 152</p>
          </div>

          <div class="rounded-xl p-5 text-white space-y-1 bg-amber-800 shadow-sm">
            <div class="flex items-center justify-between">
              <span class="text-xs font-medium text-white/80">Total amount</span>
              <.icon name="circle-dollar-sign" size={:sm} class="text-white/70" />
            </div>
            <p class="text-2xl font-bold tabular-nums">$668,726</p>
            <p class="text-xs text-white/70">Unit Number: 266</p>
          </div>
        </div>

        <%!-- Reservations + Campaign row --%>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 phia-animate-d2">

          <%!-- Reservations card --%>
          <.card class="border-border/60 shadow-sm">
            <.card_header class="pb-2">
              <.card_title>Reservations</.card_title>
            </.card_header>
            <.card_content class="px-6 pb-4">
              <.phia_chart
                id="hotel-reservations-pie"
                type={:pie}
                series={[%{name: "Reservations", data: [230, 87, 45]}]}
                labels={["Confirmed", "Checked In", "Checked Out"]}
                height="200px"
              />
              <div class="mt-4 pt-4 border-t border-border/60 text-center">
                <p class="text-2xl font-bold text-foreground tabular-nums">$86,000</p>
                <p class="text-sm text-muted-foreground mt-0.5">Total Sales This Week</p>
              </div>
            </.card_content>
          </.card>

          <%!-- Campaign Overview card --%>
          <.card class="border-border/60 shadow-sm">
            <.card_header class="pb-2">
              <div class="flex items-center justify-between">
                <.card_title>Campaign Overview</.card_title>
                <div class="flex items-center gap-2">
                  <span class="text-xs text-muted-foreground border border-border rounded-md px-2 py-1">This Week</span>
                  <button class="text-muted-foreground hover:text-foreground transition-colors p-1 min-h-[44px] min-w-[44px] flex items-center justify-center">
                    <.icon name="download" size={:xs} />
                  </button>
                </div>
              </div>
            </.card_header>
            <.card_content class="px-6 pb-4">
              <div class="grid grid-cols-3 gap-4 mb-4">
                <div>
                  <p class="text-xs text-muted-foreground">Booked</p>
                  <p class="text-2xl font-bold text-foreground tabular-nums">290</p>
                </div>
                <div>
                  <p class="text-xs text-muted-foreground">Visited</p>
                  <p class="text-2xl font-bold text-foreground tabular-nums">638</p>
                </div>
                <div>
                  <p class="text-xs text-muted-foreground">Performance</p>
                  <p class="text-sm font-semibold text-emerald-600 dark:text-emerald-400 mt-1">+12% vs last week</p>
                </div>
              </div>
              <.phia_chart
                id="hotel-campaign-line"
                type={:line}
                series={[%{name: "Bookings", data: @campaign_data}]}
                labels={@campaign_labels}
                height="140px"
              />
            </.card_content>
          </.card>
        </div>

        <%!-- Activities + Revenue + Bookings Stats row --%>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 phia-animate-d3">

          <%!-- Recent Activities --%>
          <.card class="border-border/60 shadow-sm">
            <.card_header class="pb-2">
              <.card_title>Recent Activities</.card_title>
            </.card_header>
            <.card_content class="px-6 pb-2">
              <div class="space-y-4">
                <div :for={a <- @activities} class="flex items-start gap-3">
                  <div class={"flex h-9 w-9 shrink-0 items-center justify-center rounded-full text-white text-xs font-bold " <> a.color}>
                    {a.initials}
                  </div>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-semibold text-foreground truncate">{a.name}</p>
                    <p class="text-xs text-muted-foreground leading-relaxed line-clamp-2">{a.desc}</p>
                  </div>
                  <span class="text-xs text-muted-foreground shrink-0 whitespace-nowrap">{a.time}</span>
                </div>
              </div>
            </.card_content>
            <.card_footer class="px-6 pt-2 pb-4">
              <button class="text-sm font-medium text-primary hover:text-primary/80 transition-colors flex items-center gap-1 min-h-[44px]">
                View all
                <.icon name="arrow-right" size={:xs} />
              </button>
            </.card_footer>
          </.card>

          <%!-- Revenue Stat --%>
          <.card class="border-border/60 shadow-sm">
            <.card_header class="pb-2">
              <div class="flex items-center justify-between flex-wrap gap-2">
                <div>
                  <p class="text-2xl font-bold text-foreground tabular-nums">$12,480.00</p>
                  <.badge variant={:secondary} class="mt-1 text-emerald-600 dark:text-emerald-400 bg-emerald-500/10 text-xs">
                    +16% from last month
                  </.badge>
                </div>
                <%!-- Period tabs --%>
                <div class="flex rounded-lg border border-border overflow-hidden text-xs font-medium">
                  <%= for p <- ["D", "W", "M", "Y"] do %>
                    <button
                      phx-click="revenue-period"
                      phx-value-period={p}
                      class={[
                        "px-2.5 py-1.5 transition-colors min-h-[36px]",
                        if(@revenue_period == p,
                          do: "bg-primary text-primary-foreground",
                          else: "text-muted-foreground hover:bg-accent hover:text-foreground"
                        )
                      ]}
                    >
                      {p}
                    </button>
                  <% end %>
                </div>
              </div>
            </.card_header>
            <.card_content class="px-6 pb-4">
              <.phia_chart
                id="hotel-revenue-bar"
                type={:bar}
                series={[%{name: "Revenue", data: @revenue_data}]}
                labels={@revenue_labels}
                height="160px"
              />
            </.card_content>
          </.card>

          <%!-- Bookings Stats --%>
          <.card class="border-border/60 shadow-sm">
            <.card_header class="pb-2">
              <div class="flex items-center justify-between flex-wrap gap-2">
                <div>
                  <p class="text-2xl font-bold text-foreground tabular-nums">20,395.50</p>
                  <p class="text-xs text-muted-foreground mt-0.5">Total Bookings</p>
                </div>
                <div class="flex rounded-lg border border-border overflow-hidden text-xs font-medium">
                  <%= for p <- ["D", "W", "M", "Y"] do %>
                    <button class={[
                      "px-2.5 py-1.5 transition-colors min-h-[36px]",
                      if(p == "W",
                        do: "bg-primary text-primary-foreground",
                        else: "text-muted-foreground hover:bg-accent hover:text-foreground"
                      )
                    ]}>
                      {p}
                    </button>
                  <% end %>
                </div>
              </div>
            </.card_header>
            <.card_content class="px-6 pb-4 space-y-4">
              <%!-- Booking type bar --%>
              <div class="space-y-2">
                <div class="flex h-3 w-full overflow-hidden rounded-full">
                  <div class="bg-emerald-500 h-full" style="width: 73%" />
                  <div class="bg-red-400 h-full flex-1" />
                </div>
                <div class="flex items-center justify-between text-xs">
                  <div class="flex items-center gap-1.5">
                    <span class="h-2 w-2 rounded-full bg-emerald-500 shrink-0"></span>
                    <span class="text-muted-foreground">Online Booking</span>
                    <span class="font-semibold text-foreground">14,839</span>
                  </div>
                  <div class="flex items-center gap-1.5">
                    <span class="h-2 w-2 rounded-full bg-red-400 shrink-0"></span>
                    <span class="text-muted-foreground">Offline Booking</span>
                    <span class="font-semibold text-foreground">5,556</span>
                  </div>
                </div>
              </div>

              <div class="rounded-lg bg-muted/50 border border-border/60 px-4 py-3 mt-4">
                <div class="flex items-start gap-2">
                  <.icon name="lock" size={:xs} class="text-muted-foreground mt-0.5 shrink-0" />
                  <p class="text-xs text-muted-foreground leading-relaxed">
                    Unlock in-depth analysis with a premium subscription
                  </p>
                </div>
              </div>
            </.card_content>
          </.card>
        </div>

        <%!-- Booking List --%>
        <.card class="border-border/60 shadow-sm phia-animate-d4">
          <.card_header class="pb-3">
            <div class="flex flex-wrap items-center justify-between gap-3">
              <.card_title>Booking List</.card_title>
              <div class="flex items-center gap-2">
                <div class="relative">
                  <.icon name="search" size={:xs} class="absolute left-2.5 top-1/2 -translate-y-1/2 text-muted-foreground pointer-events-none" />
                  <input
                    type="text"
                    placeholder="Search bookings..."
                    class="h-9 w-48 rounded-lg border border-border bg-background pl-8 pr-3 text-sm placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary/30"
                  />
                </div>
                <select class="h-9 rounded-lg border border-border bg-background px-3 text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-primary/30">
                  <option>All Status</option>
                  <option>Checked-In</option>
                  <option>Pending</option>
                  <option>Checked-Out</option>
                </select>
              </div>
            </div>
          </.card_header>
          <.card_content class="p-0">
            <div class="overflow-x-auto">
              <table class="w-full text-sm">
                <thead>
                  <tr class="border-b border-border/60 text-xs text-muted-foreground font-medium">
                    <th class="px-4 py-3 text-left whitespace-nowrap">Booking ID</th>
                    <th class="px-4 py-3 text-left whitespace-nowrap">Guest Name</th>
                    <th class="px-4 py-3 text-left whitespace-nowrap">Room Type</th>
                    <th class="px-4 py-3 text-left whitespace-nowrap">Room Number</th>
                    <th class="px-4 py-3 text-left whitespace-nowrap">Duration</th>
                    <th class="px-4 py-3 text-left whitespace-nowrap">Check-In & Check-Out</th>
                    <th class="px-4 py-3 text-left whitespace-nowrap">Status</th>
                  </tr>
                </thead>
                <tbody>
                  <tr :for={b <- @bookings} class="border-b border-border/40 hover:bg-muted/30 transition-colors">
                    <td class="px-4 py-3.5 font-mono text-xs text-muted-foreground whitespace-nowrap">{b.id}</td>
                    <td class="px-4 py-3.5 font-medium text-foreground whitespace-nowrap">{b.guest}</td>
                    <td class="px-4 py-3.5 whitespace-nowrap">
                      <.badge variant={:outline} class="text-xs">
                        {b.type}
                      </.badge>
                    </td>
                    <td class="px-4 py-3.5 text-muted-foreground whitespace-nowrap">{b.room}</td>
                    <td class="px-4 py-3.5 text-muted-foreground whitespace-nowrap">{b.nights} nights</td>
                    <td class="px-4 py-3.5 text-muted-foreground whitespace-nowrap">{b.dates}</td>
                    <td class="px-4 py-3.5 whitespace-nowrap">
                      <span class={[
                        "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium",
                        if b.status == "Checked-In" do
                          "bg-emerald-500/10 text-emerald-700 dark:text-emerald-400"
                        else
                          "bg-amber-500/10 text-amber-700 dark:text-amber-400"
                        end
                      ]}>
                        {b.status}
                      </span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div class="flex items-center justify-between px-4 py-3 border-t border-border/60">
              <p class="text-xs text-muted-foreground">Page 1 of 2</p>
              <.pagination>
                <.pagination_content>
                  <.pagination_item>
                    <.pagination_previous current_page={1} total_pages={2} on_change="noop" />
                  </.pagination_item>
                  <%= for p <- 1..2 do %>
                    <.pagination_item>
                      <.pagination_link page={p} current_page={1} on_change="noop">{p}</.pagination_link>
                    </.pagination_item>
                  <% end %>
                  <.pagination_item>
                    <.pagination_next current_page={1} total_pages={2} on_change="noop" />
                  </.pagination_item>
                </.pagination_content>
              </.pagination>
            </div>
          </.card_content>
        </.card>

      </div>
    </Layout.layout>
    """
  end
end
