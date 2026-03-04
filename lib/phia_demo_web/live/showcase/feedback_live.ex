defmodule PhiaDemoWeb.Demo.Showcase.FeedbackLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Showcase.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Feedback — Showcase")
     |> assign(:progress_value, 65)
     |> assign(:toast_count, 0)}
  end

  @impl true
  def handle_event("fire-toast", %{"variant" => variant}, socket) do
    count = socket.assigns.toast_count + 1

    {:noreply,
     socket
     |> assign(:toast_count, count)
     |> push_event("phia-toast", %{
       title: "Notification ##{count}",
       description: "This is a #{variant} toast message.",
       variant: variant,
       duration_ms: 4000
     })}
  end

  def handle_event("progress-inc", _, socket) do
    {:noreply, update(socket, :progress_value, &min(100, &1 + 10))}
  end

  def handle_event("progress-dec", _, socket) do
    {:noreply, update(socket, :progress_value, &max(0, &1 - 10))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/showcase/feedback">
      <div class="p-6 space-y-8 max-w-screen-xl mx-auto">
        <div>
          <h1 class="text-xl font-bold text-foreground tracking-tight">Feedback</h1>
          <p class="text-sm text-muted-foreground mt-0.5">Notification and overlay components</p>
        </div>

        <%!-- Alert --%>
        <.demo_section title="Alert" subtitle="Inline status messages in 4 variants">
          <div class="space-y-3">
            <.alert variant={:default}>
              <.alert_title>Default Alert</.alert_title>
              <.alert_description>This is a general-purpose informational alert.</.alert_description>
            </.alert>
            <.alert variant={:success}>
              <.alert_title>Success</.alert_title>
              <.alert_description>Your changes were saved successfully.</.alert_description>
            </.alert>
            <.alert variant={:warning}>
              <.alert_title>Warning</.alert_title>
              <.alert_description>Please review your settings before continuing.</.alert_description>
            </.alert>
            <.alert variant={:destructive}>
              <.alert_title>Error</.alert_title>
              <.alert_description>Something went wrong. Please try again.</.alert_description>
            </.alert>
          </div>
        </.demo_section>

        <%!-- Toast --%>
        <.demo_section title="Toast" subtitle="Transient pop-up notifications">
          <div class="flex flex-wrap gap-2">
            <%= for {variant, label} <- [{"default", "Default"}, {"success", "Success"}, {"destructive", "Error"}] do %>
              <.button variant={:outline} size={:sm} phx-click="fire-toast" phx-value-variant={variant}>
                Fire {label} Toast
              </.button>
            <% end %>
          </div>
          <p class="text-xs text-muted-foreground mt-2">
            {if @toast_count > 0, do: "#{@toast_count} toast(s) fired.", else: "Click a button to fire a toast."}
          </p>
        </.demo_section>

        <%!-- Dialog --%>
        <.demo_section title="Dialog" subtitle="Modal overlay with focus trap">
          <.dialog id="showcase-dialog">
            <.dialog_trigger for="showcase-dialog">
              <.button variant={:outline} size={:sm}>Open Dialog</.button>
            </.dialog_trigger>
            <.dialog_content id="showcase-dialog">
              <.dialog_header>
                <.dialog_title id="showcase-dialog-title">Confirm Action</.dialog_title>
                <.dialog_description id="showcase-dialog-desc">
                  This is a dialog. It traps focus and closes on Escape or backdrop click.
                </.dialog_description>
              </.dialog_header>
              <div class="py-4">
                <p class="text-sm text-muted-foreground">Dialog body content goes here.</p>
              </div>
              <.dialog_footer>
                <.dialog_close for="showcase-dialog" class="inline-flex items-center justify-center border border-input bg-background hover:bg-accent h-10 px-4 rounded-md text-sm font-medium transition-colors">
                  Cancel
                </.dialog_close>
                <.button variant={:default}>Confirm</.button>
              </.dialog_footer>
            </.dialog_content>
          </.dialog>
        </.demo_section>

        <%!-- AlertDialog --%>
        <.demo_section title="AlertDialog" subtitle="Destructive confirmation dialog">
          <.alert_dialog id="showcase-alert-dialog" open={false} aria-labelledby="sad-title" aria-describedby="sad-desc">
            <.alert_dialog_header>
              <.alert_dialog_title id="sad-title">Are you absolutely sure?</.alert_dialog_title>
              <.alert_dialog_description id="sad-desc">
                This action cannot be undone. This will permanently delete the item and all its data.
              </.alert_dialog_description>
            </.alert_dialog_header>
            <.alert_dialog_footer>
              <.alert_dialog_cancel>Cancel</.alert_dialog_cancel>
              <.alert_dialog_action variant="destructive">Delete</.alert_dialog_action>
            </.alert_dialog_footer>
          </.alert_dialog>
          <p class="text-xs text-muted-foreground">(AlertDialog is typically triggered programmatically from server-side events.)</p>
        </.demo_section>

        <%!-- Tooltip --%>
        <.demo_section title="Tooltip" subtitle="Hover or focus label for UI elements">
          <div class="flex flex-wrap items-center gap-4">
            <%= for {id, label, pos} <- [{"tip-top", "Top", :top}, {"tip-bottom", "Bottom", :bottom}, {"tip-left", "Left", :left}, {"tip-right", "Right", :right}] do %>
              <.tooltip id={id} delay_ms={100}>
                <.tooltip_trigger tooltip_id={id}>
                  <.button variant={:outline} size={:sm}>{label}</.button>
                </.tooltip_trigger>
                <.tooltip_content tooltip_id={id} position={pos}>
                  Tooltip on {label |> String.downcase()}
                </.tooltip_content>
              </.tooltip>
            <% end %>
          </div>
        </.demo_section>

        <%!-- Popover --%>
        <.demo_section title="Popover" subtitle="Floating panel anchored to a trigger">
          <div class="flex gap-3">
            <.popover id="showcase-popover">
              <.popover_trigger popover_id="showcase-popover">
                <.button variant={:outline} size={:sm}>Open Popover</.button>
              </.popover_trigger>
              <.popover_content popover_id="showcase-popover" class="w-64">
                <div class="space-y-2">
                  <h4 class="font-semibold text-sm text-foreground">Popover Title</h4>
                  <p class="text-xs text-muted-foreground">
                    This popover auto-positions and flips when near the viewport edge.
                  </p>
                  <.button variant={:default} size={:sm} class="w-full">Action</.button>
                </div>
              </.popover_content>
            </.popover>
          </div>
        </.demo_section>

        <%!-- DropdownMenu --%>
        <.demo_section title="DropdownMenu" subtitle="Context menu attached to a trigger button">
          <.dropdown_menu id="showcase-dropdown">
            <.dropdown_menu_trigger class="h-9 px-3 inline-flex items-center gap-2 rounded-md border border-input bg-background hover:bg-accent text-sm font-medium transition-colors">
              <.icon name="settings" size={:sm} />
              Options
              <.icon name="chevron-down" size={:xs} />
            </.dropdown_menu_trigger>
            <.dropdown_menu_content>
              <.dropdown_menu_label>My Account</.dropdown_menu_label>
              <.dropdown_menu_separator />
              <.dropdown_menu_group>
                <.dropdown_menu_item>Profile</.dropdown_menu_item>
                <.dropdown_menu_item>Settings</.dropdown_menu_item>
                <.dropdown_menu_item>Billing</.dropdown_menu_item>
              </.dropdown_menu_group>
              <.dropdown_menu_separator />
              <.dropdown_menu_item class="text-destructive focus:text-destructive">
                Log out
              </.dropdown_menu_item>
            </.dropdown_menu_content>
          </.dropdown_menu>
        </.demo_section>

        <%!-- Drawer --%>
        <.demo_section title="Drawer" subtitle="Sliding panel from screen edge">
          <div class="flex gap-3">
            <button type="button" data-drawer-trigger="showcase-drawer"
              class="inline-flex items-center gap-1.5 h-9 px-3 rounded-md border border-input bg-background hover:bg-accent text-sm font-medium transition-colors">
              <.icon name="panel-right" size={:sm} />
              Open Drawer
            </button>
          </div>
        </.demo_section>

        <.drawer_content id="showcase-drawer" open={false} direction="right">
          <.drawer_header>
            <h2 id="showcase-drawer-title" class="text-lg font-semibold text-foreground">Drawer Panel</h2>
            <p class="text-sm text-muted-foreground mt-1">Content slides in from the right edge.</p>
          </.drawer_header>
          <.drawer_close />
          <div class="px-6 pb-6 space-y-4">
            <p class="text-sm text-muted-foreground">Drawer supports right, left, and bottom directions. Press Escape or click outside to close.</p>
            <.alert variant={:default}>
              <.alert_title>Inside a Drawer</.alert_title>
              <.alert_description>Components compose normally inside drawers.</.alert_description>
            </.alert>
          </div>
          <.drawer_footer>
            <.button variant={:default} size={:sm}>Confirm</.button>
          </.drawer_footer>
        </.drawer_content>

        <%!-- Progress --%>
        <.demo_section title="Progress" subtitle="Linear progress indicator with live updates">
          <div class="space-y-4">
            <div class="space-y-2">
              <div class="flex justify-between text-sm">
                <span class="font-medium text-foreground">Upload progress</span>
                <span class="text-muted-foreground">{@progress_value}%</span>
              </div>
              <div class="h-2 w-full rounded-full bg-muted overflow-hidden">
                <div class="h-2 rounded-full bg-primary transition-all duration-300" style={"width: #{@progress_value}%"} />
              </div>
            </div>
            <div class="flex gap-2">
              <.button variant={:outline} size={:sm} phx-click="progress-dec">−10%</.button>
              <.button variant={:outline} size={:sm} phx-click="progress-inc">+10%</.button>
            </div>
          </div>
        </.demo_section>

      </div>
    </Layout.layout>
    """
  end

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
