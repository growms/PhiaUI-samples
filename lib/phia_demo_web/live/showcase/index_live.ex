defmodule PhiaDemoWeb.Demo.Showcase.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Showcase.Layout

  @categories [
    %{name: "Inputs", href: "/showcase/inputs", icon: "keyboard", count: 9,
      description: "Input, Textarea, Select, Combobox, TagsInput, DateRangePicker, RichTextEditor and more"},
    %{name: "Display", href: "/showcase/display", icon: "eye", count: 8,
      description: "Badge, Avatar, Card, Skeleton, Accordion, Table, Pagination, EmptyState"},
    %{name: "Feedback", href: "/showcase/feedback", icon: "bell", count: 9,
      description: "Alert, Toast, Dialog, AlertDialog, Popover, Tooltip, Drawer, DropdownMenu, ContextMenu"},
    %{name: "Charts", href: "/showcase/charts", icon: "chart-bar", count: 5,
      description: "StatCard, MetricGrid, Area chart, Bar chart, Donut chart, Line chart, ChartShell"},
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Component Showcase")}
  end

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :categories, @categories)

    ~H"""
    <Layout.layout current_path="/showcase">
      <div class="p-6 space-y-8 max-w-screen-xl mx-auto">

        <%!-- Hero --%>
        <div class="text-center space-y-3 py-8">
          <div class="inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-primary/10 mb-2">
            <.icon name="puzzle" class="text-primary" />
          </div>
          <h1 class="text-3xl font-bold text-foreground tracking-tight">Component Showcase</h1>
          <p class="text-muted-foreground text-lg max-w-xl mx-auto">
            Every PhiaUI component — live demos, fully interactive, dark-mode ready.
          </p>
          <div class="flex items-center justify-center gap-2 text-sm text-muted-foreground">
            <.badge variant={:secondary}>v0.1.3</.badge>
            <span>·</span>
            <span>31 components</span>
            <span>·</span>
            <span>4 categories</span>
          </div>
        </div>

        <%!-- Category Cards --%>
        <div class="grid gap-6 sm:grid-cols-2">
          <%= for cat <- @categories do %>
            <a href={cat.href} class="group block rounded-xl border border-border/60 bg-card p-6 shadow-sm hover:shadow-md hover:border-primary/30 transition-all duration-200">
              <div class="flex items-start gap-4">
                <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-primary/10 group-hover:bg-primary/15 transition-colors">
                  <.icon name={cat.icon} class="text-primary" />
                </div>
                <div class="flex-1 min-w-0">
                  <div class="flex items-center gap-2">
                    <h2 class="text-lg font-semibold text-foreground group-hover:text-primary transition-colors">{cat.name}</h2>
                    <.badge variant={:outline} class="text-xs">{cat.count} components</.badge>
                  </div>
                  <p class="text-sm text-muted-foreground mt-1">{cat.description}</p>
                </div>
                <.icon name="arrow-right" size={:sm} class="shrink-0 text-muted-foreground/50 group-hover:text-primary group-hover:translate-x-1 transition-all mt-0.5" />
              </div>
            </a>
          <% end %>
        </div>

        <%!-- Quick info --%>
        <.card class="border-border/60 border-dashed">
          <.card_content class="p-6">
            <div class="flex items-start gap-4">
              <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-primary/10">
                <.icon name="info" size={:sm} class="text-primary" />
              </div>
              <div>
                <h3 class="font-semibold text-foreground mb-1">About PhiaUI</h3>
                <p class="text-sm text-muted-foreground">
                  PhiaUI is a Phoenix LiveView component library built on Tailwind CSS v4 and Lucide icons.
                  Components are fully server-rendered with minimal JavaScript — only progressive enhancement hooks.
                  Dark mode is handled via CSS custom properties and the <code class="font-mono bg-muted px-1 rounded text-xs">.dark</code> class.
                </p>
              </div>
            </div>
          </.card_content>
        </.card>

      </div>
    </Layout.layout>
    """
  end
end
