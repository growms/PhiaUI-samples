defmodule PhiaDemoWeb.Demo.Showcase.DisplayLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Showcase.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Display — Showcase")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/showcase/display">
      <div class="p-6 space-y-8 max-w-screen-xl mx-auto">
        <div>
          <h1 class="text-xl font-bold text-foreground tracking-tight">Display</h1>
          <p class="text-sm text-muted-foreground mt-0.5">Visual components for presenting data and content</p>
        </div>

        <%!-- Badge --%>
        <.demo_section title="Badge" subtitle="Status labels and tags in multiple variants">
          <div class="flex flex-wrap gap-2">
            <.badge variant={:default}>Default</.badge>
            <.badge variant={:secondary}>Secondary</.badge>
            <.badge variant={:outline}>Outline</.badge>
            <.badge variant={:destructive}>Destructive</.badge>
            <.badge variant={:default} class="bg-success/80">Success</.badge>
            <.badge variant={:secondary} class="bg-warning/20 text-warning border-warning/30">Warning</.badge>
          </div>
        </.demo_section>

        <%!-- Avatar --%>
        <.demo_section title="Avatar" subtitle="User avatars with fallback initials">
          <div class="flex flex-wrap items-center gap-4">
            <.avatar size="sm"><.avatar_fallback name="Alice" class="bg-primary/10 text-primary text-xs" /></.avatar>
            <.avatar size="sm"><.avatar_fallback name="Bob Smith" class="bg-secondary text-secondary-foreground text-xs" /></.avatar>
            <.avatar size="default"><.avatar_fallback name="Carol Jones" class="bg-muted text-muted-foreground text-sm font-semibold" /></.avatar>
            <.avatar size="lg"><.avatar_fallback name="David Lee" class="bg-primary/10 text-primary text-base font-bold" /></.avatar>
            <.avatar size="xl"><.avatar_fallback name="Eve" class="bg-destructive/15 text-destructive text-lg font-bold" /></.avatar>
          </div>
          <%!-- Avatar group --%>
          <div class="flex -space-x-3 mt-4">
            <%= for name <- ["Alice B", "Bob C", "Carol D", "David E"] do %>
              <.avatar size="sm" class="ring-2 ring-background">
                <.avatar_fallback name={name} class="bg-primary/10 text-primary text-xs font-semibold" />
              </.avatar>
            <% end %>
          </div>
        </.demo_section>

        <%!-- Card --%>
        <.demo_section title="Card" subtitle="Composed card with header, content, footer">
          <div class="grid gap-4 sm:grid-cols-2">
            <.card>
              <.card_header>
                <.card_title>Simple Card</.card_title>
                <.card_description>Basic card with header and content</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-muted-foreground">Card body content goes here. Cards can contain any HTML or component.</p>
              </.card_content>
            </.card>
            <.card>
              <.card_header>
                <.card_title>With Footer</.card_title>
                <.card_description>Card with action footer</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-muted-foreground">Card content with a footer below.</p>
              </.card_content>
              <.card_footer class="gap-2">
                <.button variant={:outline} size={:sm}>Cancel</.button>
                <.button variant={:default} size={:sm}>Confirm</.button>
              </.card_footer>
            </.card>
          </div>
        </.demo_section>

        <%!-- Skeleton --%>
        <.demo_section title="Skeleton" subtitle="Loading placeholder for deferred content">
          <div class="space-y-4">
            <div class="flex items-center gap-4">
              <.skeleton class="h-12 w-12 rounded-full" />
              <div class="space-y-2 flex-1">
                <.skeleton class="h-4 w-1/2" />
                <.skeleton class="h-3 w-1/3" />
              </div>
            </div>
            <.skeleton class="h-32 w-full rounded-xl" />
            <div class="grid grid-cols-3 gap-3">
              <.skeleton class="h-20 rounded-lg" />
              <.skeleton class="h-20 rounded-lg" />
              <.skeleton class="h-20 rounded-lg" />
            </div>
          </div>
        </.demo_section>

        <%!-- Accordion --%>
        <.demo_section title="Accordion" subtitle="Collapsible sections, single or multiple open">
          <.accordion id="showcase-accordion" type={:single}>
            <.accordion_item value="a1" type={:single} accordion_id="showcase-accordion">
              <.accordion_trigger value="a1" type={:single} accordion_id="showcase-accordion">
                What is PhiaUI?
              </.accordion_trigger>
              <.accordion_content value="a1">
                PhiaUI is a Phoenix LiveView component library built on Tailwind CSS v4 with Lucide icons. Components are fully server-rendered.
              </.accordion_content>
            </.accordion_item>
            <.accordion_item value="a2" type={:single} accordion_id="showcase-accordion">
              <.accordion_trigger value="a2" type={:single} accordion_id="showcase-accordion">
                How does dark mode work?
              </.accordion_trigger>
              <.accordion_content value="a2">
                Dark mode toggles the <code class="font-mono bg-muted px-1 rounded text-xs">.dark</code> class on the HTML element. CSS custom properties handle all color overrides.
              </.accordion_content>
            </.accordion_item>
            <.accordion_item value="a3" type={:single} accordion_id="showcase-accordion">
              <.accordion_trigger value="a3" type={:single} accordion_id="showcase-accordion">
                Is it production-ready?
              </.accordion_trigger>
              <.accordion_content value="a3">
                PhiaUI is actively developed. The current version is v0.1.3 and is suitable for demos and prototype apps.
              </.accordion_content>
            </.accordion_item>
          </.accordion>
        </.demo_section>

        <%!-- Table --%>
        <.demo_section title="Table" subtitle="Data table with header, rows, and actions">
          <.table>
            <.table_header>
              <.table_row class="hover:bg-transparent">
                <.table_head>Name</.table_head>
                <.table_head>Role</.table_head>
                <.table_head>Status</.table_head>
                <.table_head class="text-right">Joined</.table_head>
              </.table_row>
            </.table_header>
            <.table_body>
              <%= for {name, role, status, joined} <- [
                {"Alice Brown", "Admin", :active, "Jan 2024"},
                {"Bob Chen", "Editor", :active, "Feb 2024"},
                {"Carol Davis", "Viewer", :inactive, "Mar 2024"},
                {"David Evans", "Editor", :pending, "Apr 2024"}
              ] do %>
                <.table_row>
                  <.table_cell class="font-medium">{name}</.table_cell>
                  <.table_cell><.badge variant={:outline} class="text-xs">{role}</.badge></.table_cell>
                  <.table_cell>
                    <.badge variant={if status == :active, do: :default, else: if(status == :inactive, do: :outline, else: :secondary)} class="text-xs">
                      {status |> to_string() |> String.capitalize()}
                    </.badge>
                  </.table_cell>
                  <.table_cell class="text-right text-muted-foreground text-sm">{joined}</.table_cell>
                </.table_row>
              <% end %>
            </.table_body>
          </.table>
        </.demo_section>

        <%!-- Pagination --%>
        <.demo_section title="Pagination" subtitle="Page navigation with prev/next and links">
          <.pagination>
            <.pagination_content>
              <.pagination_item>
                <.pagination_previous current_page={3} total_pages={8} on_change="noop" />
              </.pagination_item>
              <%= for p <- [1, 2, 3, 4, 5] do %>
                <.pagination_item>
                  <.pagination_link page={p} current_page={3} on_change="noop">{p}</.pagination_link>
                </.pagination_item>
              <% end %>
              <.pagination_item>
                <.pagination_next current_page={3} total_pages={8} on_change="noop" />
              </.pagination_item>
            </.pagination_content>
          </.pagination>
        </.demo_section>

        <%!-- Empty State --%>
        <.demo_section title="EmptyState" subtitle="Placeholder for empty collections">
          <.empty>
            <:icon>
              <div class="flex h-12 w-12 items-center justify-center rounded-full bg-primary/10">
                <.icon name="inbox" class="text-primary" />
              </div>
            </:icon>
            <:title>No results found</:title>
            <:description>Try adjusting your search or filter to find what you're looking for.</:description>
            <:action>
              <.button variant={:default} size={:sm}>Clear filters</.button>
            </:action>
          </.empty>
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
