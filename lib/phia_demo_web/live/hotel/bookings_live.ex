defmodule PhiaDemoWeb.Demo.Hotel.BookingsLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Hotel.Layout

  @rooms ["Room 1", "Room 2", "Room 3", "Room 4", "Room 5", "Room 6"]

  # Time slots from 07:00 to 13:00 (inclusive)
  @time_slots [
    "07:00 AM", "08:00 AM", "09:00 AM", "10:00 AM",
    "11:00 AM", "12:00 PM", "13:00 PM"
  ]

  # Bookings keyed by {hour_index, room_index} (0-based)
  # hour_index: 0=07:00, 1=08:00, 2=09:00, ...
  # room_index: 0=Room1, 1=Room2, ...
  @bookings %{
    {0, 0} => %{id: "ID1928309", guest: "Renata",   span: 1, color: "bg-orange-500/20 border-l-2 border-orange-500"},
    {0, 1} => %{id: "ID1928310", guest: "Marcel",   span: 1, color: "bg-green-500/20 border-l-2 border-green-500"},
    {0, 2} => %{id: "ID1928311", guest: "Damar",    span: 3, color: "bg-violet-500/20 border-l-2 border-violet-500"},
    {2, 0} => %{id: "ID1928312", guest: "Renata",   span: 1, color: "bg-orange-500/20 border-l-2 border-orange-500"},
    {2, 1} => %{id: "ID1928313", guest: "Dr. Yosep",span: 1, color: "bg-blue-500/20 border-l-2 border-blue-500"},
    {4, 0} => %{id: "ID1928314", guest: "Jauhari",  span: 1, color: "bg-orange-500/20 border-l-2 border-orange-500"},
    {4, 1} => %{id: "ID1928315", guest: "Anita",    span: 1, color: "bg-blue-500/20 border-l-2 border-blue-500"}
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Hotel — Bookings")
     |> assign(:current_date, Date.new!(2026, 3, 9))
     |> assign(:view_mode, :grid)
     |> assign(:rooms, @rooms)
     |> assign(:time_slots, @time_slots)
     |> assign(:bookings, @bookings)}
  end

  @impl true
  def handle_event("prev-day", _params, socket) do
    {:noreply, update(socket, :current_date, &Date.add(&1, -1))}
  end

  def handle_event("next-day", _params, socket) do
    {:noreply, update(socket, :current_date, &Date.add(&1, 1))}
  end

  def handle_event("set-view", %{"mode" => mode}, socket) do
    {:noreply, assign(socket, :view_mode, String.to_existing_atom(mode))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/hotel/bookings">
      <div class="p-4 md:p-6 space-y-4 max-w-screen-2xl mx-auto">

        <%!-- Header --%>
        <div class="flex flex-wrap items-center justify-between gap-3 phia-animate">
          <h1 class="text-xl font-bold text-foreground tracking-tight">Bookings</h1>

          <div class="flex items-center gap-2 flex-wrap">
            <%!-- Date navigation --%>
            <div class="flex items-center gap-1 rounded-lg border border-border bg-background">
              <button
                phx-click="prev-day"
                class="flex items-center justify-center h-9 w-9 rounded-l-lg text-muted-foreground hover:bg-accent hover:text-foreground transition-colors min-h-[44px] min-w-[44px]"
                aria-label="Previous day"
              >
                <.icon name="chevron-left" size={:xs} />
              </button>
              <span class="px-3 text-sm font-medium text-foreground whitespace-nowrap">
                {format_date(@current_date)}
              </span>
              <button
                phx-click="next-day"
                class="flex items-center justify-center h-9 w-9 rounded-r-lg text-muted-foreground hover:bg-accent hover:text-foreground transition-colors min-h-[44px] min-w-[44px]"
                aria-label="Next day"
              >
                <.icon name="chevron-right" size={:xs} />
              </button>
            </div>

            <%!-- View toggle --%>
            <div class="flex rounded-lg border border-border overflow-hidden">
              <button
                phx-click="set-view"
                phx-value-mode="grid"
                class={[
                  "flex items-center justify-center h-9 w-9 transition-colors min-h-[44px] min-w-[44px]",
                  if(@view_mode == :grid, do: "bg-primary text-primary-foreground", else: "text-muted-foreground hover:bg-accent hover:text-foreground")
                ]}
                aria-label="Grid view"
              >
                <.icon name="layout-grid" size={:xs} />
              </button>
              <button
                phx-click="set-view"
                phx-value-mode="list"
                class={[
                  "flex items-center justify-center h-9 w-9 transition-colors min-h-[44px] min-w-[44px]",
                  if(@view_mode == :list, do: "bg-primary text-primary-foreground", else: "text-muted-foreground hover:bg-accent hover:text-foreground")
                ]}
                aria-label="List view"
              >
                <.icon name="list" size={:xs} />
              </button>
            </div>

            <%!-- Add booking --%>
            <button class="inline-flex items-center gap-1.5 rounded-lg bg-primary px-3 py-2 text-sm font-semibold text-primary-foreground hover:bg-primary/90 transition-colors min-h-[44px]">
              <.icon name="plus" size={:xs} />
              Booking Room
            </button>
          </div>
        </div>

        <%!-- Room Schedule Grid --%>
        <.card class="border-border/60 shadow-sm phia-animate-d1">
          <.card_content class="p-0">
            <div class="overflow-x-auto">
              <div class="min-w-[900px]">

                <%!-- Column headers --%>
                <div class="grid border-b border-border/60 bg-muted/40" style="grid-template-columns: 80px repeat(6, minmax(140px, 1fr))">
                  <div class="px-3 py-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider border-r border-border/60">
                    Time
                  </div>
                  <div
                    :for={room <- @rooms}
                    class="px-3 py-3 text-sm font-semibold text-foreground border-r border-border/60 last:border-r-0"
                  >
                    {room}
                  </div>
                </div>

                <%!-- Time rows --%>
                <div>
                  <%= for {slot, hour_idx} <- Enum.with_index(@time_slots) do %>
                    <div
                      class="grid border-b border-border/40 last:border-b-0"
                      style="grid-template-columns: 80px repeat(6, minmax(140px, 1fr))"
                    >
                      <%!-- Time label --%>
                      <div class="px-3 py-0 flex items-start pt-2 border-r border-border/60 h-24 shrink-0">
                        <span class="text-xs font-medium text-muted-foreground whitespace-nowrap">{slot}</span>
                      </div>

                      <%!-- Room cells --%>
                      <%= for {_room, room_idx} <- Enum.with_index(@rooms) do %>
                        <div class="relative border-r border-border/40 last:border-r-0 h-24 p-1">
                          <%= case Map.get(@bookings, {hour_idx, room_idx}) do %>
                            <% nil -> %>
                              <%!-- empty cell --%>
                            <% booking -> %>
                              <div class={[
                                "absolute inset-1 rounded-md p-2 flex flex-col justify-between overflow-hidden",
                                booking.color
                              ]}
                              style={"height: calc(#{booking.span * 6}rem - 8px); z-index: 10;"}>
                                <div>
                                  <p class="text-[10px] font-semibold text-foreground/70 tabular-nums leading-none">{booking.id}</p>
                                  <p class="text-sm font-bold text-foreground mt-0.5 leading-tight">{booking.guest}</p>
                                </div>
                                <p class="text-[10px] text-muted-foreground">
                                  {Enum.at(@time_slots, hour_idx)} – {Enum.at(@time_slots, min(hour_idx + booking.span, length(@time_slots) - 1))} PM
                                </p>
                              </div>
                          <% end %>
                        </div>
                      <% end %>
                    </div>
                  <% end %>
                </div>

              </div>
            </div>
          </.card_content>
        </.card>

        <%!-- Legend --%>
        <div class="flex flex-wrap items-center gap-4 text-xs text-muted-foreground phia-animate-d2">
          <span class="font-medium text-foreground">Legend:</span>
          <div class="flex items-center gap-1.5">
            <span class="h-3 w-3 rounded-sm bg-orange-500/20 border-l-2 border-orange-500"></span>
            Renata / Jauhari
          </div>
          <div class="flex items-center gap-1.5">
            <span class="h-3 w-3 rounded-sm bg-green-500/20 border-l-2 border-green-500"></span>
            Marcel
          </div>
          <div class="flex items-center gap-1.5">
            <span class="h-3 w-3 rounded-sm bg-violet-500/20 border-l-2 border-violet-500"></span>
            Damar (3h)
          </div>
          <div class="flex items-center gap-1.5">
            <span class="h-3 w-3 rounded-sm bg-blue-500/20 border-l-2 border-blue-500"></span>
            Dr. Yosep / Anita
          </div>
        </div>

      </div>
    </Layout.layout>
    """
  end

  defp format_date(%Date{} = date) do
    day_name =
      case Date.day_of_week(date) do
        1 -> "Mon"
        2 -> "Tue"
        3 -> "Wed"
        4 -> "Thu"
        5 -> "Fri"
        6 -> "Sat"
        7 -> "Sun"
      end

    month_name =
      case date.month do
        1  -> "Jan";  2  -> "Feb";  3  -> "Mar";  4  -> "Apr"
        5  -> "May";  6  -> "Jun";  7  -> "Jul";  8  -> "Aug"
        9  -> "Sep";  10 -> "Oct";  11 -> "Nov";  12 -> "Dec"
      end

    "#{day_name}, #{month_name} #{date.day}"
  end
end
