defmodule PhiaDemoWeb.Demo.Showcase.InputsLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Showcase.Layout

  @fruit_options [
    %{value: "apple", label: "Apple"},
    %{value: "banana", label: "Banana"},
    %{value: "cherry", label: "Cherry"},
    %{value: "grape", label: "Grape"},
    %{value: "kiwi", label: "Kiwi"},
    %{value: "mango", label: "Mango"},
    %{value: "orange", label: "Orange"},
    %{value: "pear", label: "Pear"},
    %{value: "strawberry", label: "Strawberry"},
    %{value: "watermelon", label: "Watermelon"}
  ]

  @country_options [
    %{value: "br", label: "Brazil"},
    %{value: "us", label: "United States"},
    %{value: "de", label: "Germany"},
    %{value: "jp", label: "Japan"},
    %{value: "fr", label: "France"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Inputs — Showcase")
     |> assign(:fruit_value, "apple")
     |> assign(:fruit_open, false)
     |> assign(:fruit_search, "")
     |> assign(:country_value, "br")
     |> assign(:country_open, false)
     |> assign(:country_search, "")
     |> assign(:tags, ["phoenix", "liveview"])
     |> assign(:date_range, nil)
     |> assign(:view_month, Date.utc_today() |> Date.beginning_of_month())
     |> assign(:date_from, nil)
     |> assign(:date_to, nil)}
  end

  @impl true
  def handle_event("fruit-toggle", _, s), do: {:noreply, update(s, :fruit_open, &(!&1))}
  def handle_event("fruit-search", %{"query" => q}, s), do: {:noreply, assign(s, :fruit_search, q)}
  def handle_event("fruit-change", %{"value" => v}, s), do: {:noreply, assign(s, fruit_value: v, fruit_open: false, fruit_search: "")}

  def handle_event("country-toggle", _, s), do: {:noreply, update(s, :country_open, &(!&1))}
  def handle_event("country-search", %{"query" => q}, s), do: {:noreply, assign(s, :country_search, q)}
  def handle_event("country-change", %{"value" => v}, s), do: {:noreply, assign(s, country_value: v, country_open: false, country_search: "")}

  def handle_event("tags-change", %{"tags" => tags}, s), do: {:noreply, assign(s, :tags, tags)}

  def handle_event("date-range-change", %{"from" => from, "to" => to}, s) do
    {:noreply, assign(s, :date_range, %{start: from, end: to})}
  end

  def handle_event("date-range-change", %{"from" => from}, s) do
    {:noreply, assign(s, :date_range, %{start: from, end: nil})}
  end

  def handle_event("date-month-change", %{"year" => y, "month" => m}, s) do
    {:noreply, assign(s, :view_month, Date.new!(String.to_integer(y), String.to_integer(m), 1))}
  end

  @impl true
  def render(assigns) do
    assigns = assign(assigns, fruit_options: @fruit_options, country_options: @country_options)

    ~H"""
    <Layout.layout current_path="/showcase/inputs">
      <div class="p-6 space-y-8 max-w-screen-xl mx-auto">
        <div>
          <h1 class="text-xl font-bold text-foreground tracking-tight">Inputs</h1>
          <p class="text-sm text-muted-foreground mt-0.5">Form components — text fields, selectors, pickers, and rich editors</p>
        </div>

        <%!-- Section helper macro --%>
        <%!-- Input + Textarea --%>
        <div class="grid gap-8 lg:grid-cols-2">
          <.demo_section title="Input" subtitle="Basic text input with label">
            <div class="space-y-3">
              <div class="space-y-1.5">
                <label class="text-sm font-medium text-foreground">Username</label>
                <input type="text" placeholder="e.g. john_doe" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring" />
              </div>
              <div class="space-y-1.5">
                <label class="text-sm font-medium text-foreground">Email</label>
                <input type="email" placeholder="user@example.com" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring" />
              </div>
              <div class="space-y-1.5">
                <label class="text-sm font-medium text-foreground">Disabled</label>
                <input type="text" value="Cannot edit" disabled class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm opacity-50 cursor-not-allowed" />
              </div>
            </div>
          </.demo_section>

          <.demo_section title="Textarea" subtitle="Multi-line text input">
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Description</label>
              <textarea rows="5" placeholder="Write something..." class="flex w-full rounded-md border border-input bg-background px-3 py-2 text-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring resize-none"></textarea>
              <p class="text-xs text-muted-foreground">Max 500 characters</p>
            </div>
          </.demo_section>
        </div>

        <%!-- Combobox --%>
        <div class="grid gap-8 lg:grid-cols-2">
          <.demo_section title="Combobox" subtitle="Searchable select with live filtering">
            <div class="space-y-3">
              <div>
                <label class="text-sm font-medium text-foreground mb-1.5 block">Favorite Fruit</label>
                <.combobox
                  id="showcase-fruit"
                  options={@fruit_options}
                  value={@fruit_value}
                  open={@fruit_open}
                  search={@fruit_search}
                  placeholder="Select fruit..."
                  search_placeholder="Search fruit..."
                  on_change="fruit-change"
                  on_search="fruit-search"
                  on_toggle="fruit-toggle"
                />
              </div>
              <div>
                <label class="text-sm font-medium text-foreground mb-1.5 block">Country</label>
                <.combobox
                  id="showcase-country"
                  options={@country_options}
                  value={@country_value}
                  open={@country_open}
                  search={@country_search}
                  placeholder="Select country..."
                  search_placeholder="Search country..."
                  on_change="country-change"
                  on_search="country-search"
                  on_toggle="country-toggle"
                />
              </div>
            </div>
          </.demo_section>

          <.demo_section title="TagsInput" subtitle="Tag chips — use with Phoenix.HTML.Form.Field">
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Technologies (demo tags)</label>
              <div class="flex flex-wrap gap-1.5 rounded-md border border-input bg-background px-3 py-2 min-h-10">
                <%= for tag <- @tags do %>
                  <span class="inline-flex items-center gap-1 rounded-md bg-primary/10 px-2 py-0.5 text-xs font-medium text-primary">
                    {tag}
                    <button type="button" class="text-primary/60 hover:text-primary ml-0.5">×</button>
                  </span>
                <% end %>
                <input type="text" placeholder="Add tag..." class="flex-1 min-w-20 text-sm bg-transparent outline-none placeholder:text-muted-foreground" />
              </div>
              <p class="text-xs text-muted-foreground">TagsInput requires a Phoenix.HTML.FormField — use inside a <code class="font-mono bg-muted px-1 rounded">.form</code> component.</p>
            </div>
          </.demo_section>
        </div>

        <%!-- DateRangePicker --%>
        <div class="grid gap-8 lg:grid-cols-2">
          <.demo_section title="DateRangePicker" subtitle="Calendar popover with start/end selection">
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-foreground">Date Range</label>
              <.date_range_picker
                id="showcase-daterange"
                view_month={@view_month}
                from={@date_from}
                to={@date_to}
                on_change="date-range-change"
                on_month_change="date-month-change"
              />
              <%= if @date_range && @date_range.start do %>
                <p class="text-xs text-muted-foreground">
                  Selected: {@date_range.start} → {if @date_range.end, do: @date_range.end, else: "..."}
                </p>
              <% end %>
            </div>
          </.demo_section>

          <.demo_section title="Select (native)" subtitle="HTML select with custom styling">
            <div class="space-y-3">
              <div class="space-y-1.5">
                <label class="text-sm font-medium text-foreground">Role</label>
                <select class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring">
                  <option value="">Select role...</option>
                  <option>Admin</option>
                  <option>Editor</option>
                  <option>Viewer</option>
                </select>
              </div>
              <div class="space-y-1.5">
                <label class="text-sm font-medium text-foreground">Size</label>
                <select class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring">
                  <option>Small</option>
                  <option selected>Medium</option>
                  <option>Large</option>
                  <option>Extra Large</option>
                </select>
              </div>
            </div>
          </.demo_section>
        </div>

        <%!-- Checkboxes + Radio --%>
        <div class="grid gap-8 lg:grid-cols-2">
          <.demo_section title="Checkbox" subtitle="Boolean toggles with labels">
            <div class="space-y-3">
              <%= for {label, checked} <- [{"Email notifications", true}, {"SMS alerts", false}, {"Weekly digest", true}, {"Marketing emails", false}] do %>
                <label class="flex items-center gap-3 cursor-pointer group">
                  <input type="checkbox" checked={checked} class="h-4 w-4 rounded border-input text-primary focus:ring-ring" />
                  <span class="text-sm text-foreground group-hover:text-primary transition-colors">{label}</span>
                </label>
              <% end %>
            </div>
          </.demo_section>

          <.demo_section title="RadioGroup" subtitle="Mutually exclusive choice">
            <div class="space-y-3">
              <%= for {val, label, desc} <- [{"free", "Free", "$0/month"}, {"pro", "Pro", "$29/month"}, {"enterprise", "Enterprise", "Custom pricing"}] do %>
                <label class={"flex items-start gap-3 cursor-pointer rounded-lg border p-3 hover:bg-accent/50 transition-colors #{if val == "pro", do: "border-primary bg-primary/5", else: "border-border"}"}>
                  <input type="radio" name="plan" value={val} checked={val == "pro"} class="mt-0.5 h-4 w-4 text-primary focus:ring-ring" />
                  <div>
                    <p class="text-sm font-medium text-foreground">{label}</p>
                    <p class="text-xs text-muted-foreground">{desc}</p>
                  </div>
                </label>
              <% end %>
            </div>
          </.demo_section>
        </div>

      </div>
    </Layout.layout>
    """
  end

  # ── Private demo section wrapper ──────────────────────────────────────────

  attr :title, :string, required: true
  attr :subtitle, :string, required: true
  slot :inner_block, required: true

  defp demo_section(assigns) do
    ~H"""
    <div class="space-y-4">
      <div>
        <h2 class="text-base font-semibold text-foreground">{@title}</h2>
        <p class="text-xs text-muted-foreground mt-0.5">{@subtitle}</p>
      </div>
      <div class="rounded-xl border border-border/60 bg-card p-5 shadow-sm">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
