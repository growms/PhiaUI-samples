defmodule PhiaDemoWeb.Demo.Dashboard.Settings do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Dashboard.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Settings")
     |> assign(:saved, false)
     |> assign(:notifications_email, true)
     |> assign(:notifications_browser, false)
     |> assign(:notifications_weekly, true)
     |> assign(:loading_profile, false)}
  end

  @impl true
  def handle_event("save_profile", _params, socket) do
    {:noreply,
     socket
     |> assign(:loading_profile, true)
     |> then(fn s ->
       Process.send_after(self(), :profile_saved, 800)
       s
     end)}
  end

  @impl true
  def handle_event("toggle_notification", %{"key" => key}, socket) do
    key_atom = String.to_existing_atom("notifications_#{key}")
    {:noreply, update(socket, key_atom, &(!&1))}
  end

  @impl true
  def handle_event("discard", _params, socket) do
    {:noreply,
     socket
     |> assign(:saved, false)
     |> push_event("phia-toast", %{
       title: "Discarded",
       description: "Your changes have been discarded.",
       variant: "default",
       duration_ms: 3000
     })}
  end

  @impl true
  def handle_info(:profile_saved, socket) do
    {:noreply,
     socket
     |> assign(:loading_profile, false)
     |> assign(:saved, true)
     |> push_event("phia-toast", %{
       title: "Settings saved",
       description: "Your profile has been updated successfully.",
       variant: "default",
       duration_ms: 4000
     })}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/dashboard/settings">
      <div class="p-6 space-y-6">
        <%!-- Breadcrumb --%>
        <.breadcrumb>
          <.breadcrumb_list>
            <.breadcrumb_item>
              <.breadcrumb_link href="/dashboard">Dashboard</.breadcrumb_link>
            </.breadcrumb_item>
            <.breadcrumb_separator />
            <.breadcrumb_item>
              <.breadcrumb_page>Settings</.breadcrumb_page>
            </.breadcrumb_item>
          </.breadcrumb_list>
        </.breadcrumb>

        <%!-- Header --%>
        <div class="flex items-center justify-between phia-animate">
          <div>
            <h1 class="text-2xl font-bold text-foreground tracking-tight">Settings</h1>
            <p class="text-sm text-muted-foreground mt-1">Manage your account and platform preferences</p>
          </div>
          <.badge variant={if @saved, do: :default, else: :outline}>
            {if @saved, do: "Saved", else: "Unsaved"}
          </.badge>
        </div>

        <%= if @saved do %>
          <.alert variant={:success}>
            <.alert_title>Settings updated</.alert_title>
            <.alert_description>Your changes have been saved and are active immediately.</.alert_description>
          </.alert>
        <% end %>

        <div class="phia-animate-d1">
        <.accordion id="settings-accordion" type={:single}>

          <%!-- Profile --%>
          <.accordion_item value="profile" type={:single} accordion_id="settings-accordion">
            <.accordion_trigger value="profile" type={:single} accordion_id="settings-accordion">
              <div class="flex items-center gap-3">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10">
                  <.icon name="user" size={:sm} class="text-primary" />
                </div>
                <div class="text-left">
                  <p class="font-semibold text-foreground">Profile</p>
                  <p class="text-xs text-muted-foreground font-normal">Name, email, and avatar</p>
                </div>
              </div>
            </.accordion_trigger>
            <.accordion_content value="profile">
              <.card class="mt-2 border-0 shadow-none bg-muted/20">
                <.card_content class="p-4 space-y-4">
                  <div class="flex items-center gap-4">
                    <.avatar size="lg" class="ring-2 ring-primary/20">
                      <.avatar_fallback name="Admin User" class="bg-primary/15 text-primary font-bold" />
                    </.avatar>
                    <div>
                      <p class="font-semibold text-foreground">Admin User</p>
                      <p class="text-sm text-muted-foreground">admin@acme.com</p>
                    </div>
                    <.button variant={:outline} size={:sm} class="ml-auto">Change photo</.button>
                  </div>
                  <div class="grid gap-3 sm:grid-cols-2">
                    <div class="space-y-1.5">
                      <label class="text-sm font-medium text-foreground">Full name</label>
                      <input type="text" value="Admin User" class="flex h-9 w-full rounded-md border border-input bg-background px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring" />
                    </div>
                    <div class="space-y-1.5">
                      <label class="text-sm font-medium text-foreground">Email</label>
                      <input type="email" value="admin@acme.com" class="flex h-9 w-full rounded-md border border-input bg-background px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring" />
                    </div>
                  </div>
                  <div class="flex justify-end">
                    <%= if @loading_profile do %>
                      <.button variant={:default} size={:sm} disabled>
                        <.skeleton class="h-4 w-24" />
                      </.button>
                    <% else %>
                      <.button variant={:default} size={:sm} phx-click="save_profile">Save Profile</.button>
                    <% end %>
                  </div>
                </.card_content>
              </.card>
            </.accordion_content>
          </.accordion_item>

          <%!-- Notifications --%>
          <.accordion_item value="notifications" type={:single} accordion_id="settings-accordion">
            <.accordion_trigger value="notifications" type={:single} accordion_id="settings-accordion">
              <div class="flex items-center gap-3">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10">
                  <.icon name="bell" size={:sm} class="text-primary" />
                </div>
                <div class="text-left">
                  <p class="font-semibold text-foreground">Notifications</p>
                  <p class="text-xs text-muted-foreground font-normal">Email, push, and digests</p>
                </div>
              </div>
            </.accordion_trigger>
            <.accordion_content value="notifications">
              <.card class="mt-2 border-0 shadow-none bg-muted/20">
                <.card_content class="p-4 space-y-4">
                  <%= for {key, label, desc} <- [
                    {"email", "Email notifications", "Receive alerts and updates via email"},
                    {"browser", "Browser notifications", "Push alerts in the browser"},
                    {"weekly", "Weekly digest", "Condensed report sent every Monday"}
                  ] do %>
                    <% current_val = Map.get(assigns, String.to_existing_atom("notifications_#{key}")) %>
                    <div class="flex items-start justify-between gap-4">
                      <div>
                        <p class="text-sm font-medium text-foreground">{label}</p>
                        <p class="text-xs text-muted-foreground mt-0.5">{desc}</p>
                      </div>
                      <button type="button" phx-click="toggle_notification" phx-value-key={key}
                        class={"relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 #{if current_val, do: "bg-primary", else: "bg-input"}"}
                        role="switch" aria-checked={to_string(current_val)}>
                        <span class={"pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow-lg ring-0 transition-transform #{if current_val, do: "translate-x-5", else: "translate-x-0"}"} />
                      </button>
                    </div>
                  <% end %>
                </.card_content>
              </.card>
            </.accordion_content>
          </.accordion_item>

          <%!-- Appearance --%>
          <.accordion_item value="appearance" type={:single} accordion_id="settings-accordion">
            <.accordion_trigger value="appearance" type={:single} accordion_id="settings-accordion">
              <div class="flex items-center gap-3">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10">
                  <.icon name="sun-moon" size={:sm} class="text-primary" />
                </div>
                <div class="text-left">
                  <p class="font-semibold text-foreground">Appearance</p>
                  <p class="text-xs text-muted-foreground font-normal">Theme and visual preferences</p>
                </div>
              </div>
            </.accordion_trigger>
            <.accordion_content value="appearance">
              <.card class="mt-2 border-0 shadow-none bg-muted/20">
                <.card_content class="p-4 space-y-4">
                  <div class="flex items-center justify-between">
                    <div>
                      <p class="text-sm font-medium text-foreground">Dark mode</p>
                      <p class="text-xs text-muted-foreground mt-0.5">Toggle between light and dark theme</p>
                    </div>
                    <.dark_mode_toggle id="settings-theme-toggle" />
                  </div>
                </.card_content>
              </.card>
            </.accordion_content>
          </.accordion_item>

          <%!-- Security --%>
          <.accordion_item value="security" type={:single} accordion_id="settings-accordion">
            <.accordion_trigger value="security" type={:single} accordion_id="settings-accordion">
              <div class="flex items-center gap-3">
                <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-destructive/10">
                  <.icon name="shield" size={:sm} class="text-destructive" />
                </div>
                <div class="text-left">
                  <p class="font-semibold text-foreground">Security</p>
                  <p class="text-xs text-muted-foreground font-normal">Password, 2FA, and active sessions</p>
                </div>
              </div>
            </.accordion_trigger>
            <.accordion_content value="security">
              <.card class="mt-2 border-0 shadow-none bg-muted/20">
                <.card_content class="p-4 space-y-4">
                  <.alert variant={:warning}>
                    <.alert_title>Two-factor authentication disabled</.alert_title>
                    <.alert_description>We recommend enabling 2FA for better account security.</.alert_description>
                  </.alert>
                  <div class="space-y-2">
                    <.button variant={:default} size={:sm}>Enable 2FA</.button>
                    <.button variant={:outline} size={:sm} class="ml-2">Change Password</.button>
                  </div>
                </.card_content>
              </.card>
            </.accordion_content>
          </.accordion_item>

        </.accordion>
        </div>

        <%!-- Actions footer --%>
        <.card class="border-dashed">
          <.card_content class="p-4">
            <div class="flex items-center justify-between">
              <p class="text-sm text-muted-foreground">
                All changes are saved immediately when you click <strong class="text-foreground">Save</strong>.
              </p>
              <.button_group>
                <.button variant={:outline} size={:sm} phx-click="discard">Discard</.button>
                <.button variant={:default} size={:sm} phx-click="save_profile">Save All</.button>
              </.button_group>
            </div>
          </.card_content>
        </.card>
      </div>
    </Layout.layout>
    """
  end
end
