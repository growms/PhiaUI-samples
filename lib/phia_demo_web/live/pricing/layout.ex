defmodule PhiaDemoWeb.Demo.Pricing.Layout do
  @moduledoc "Pricing app shell layout with shared why/faq sections."

  use Phoenix.Component

  import PhiaUi.Components.Shell
  import PhiaUi.Components.Icon
  import PhiaDemoWeb.ProjectNav

  attr :current_path, :string, required: true
  slot :inner_block, required: true

  def layout(assigns) do
    ~H"""
    <.shell>
      <:topbar>
        <.mobile_sidebar_toggle />
        <.project_topbar current_project={:pricing} dark_mode_id="pricing-dm" />
      </:topbar>
      <:sidebar>
        <.sidebar>
          <:brand>
            <div class="flex items-center gap-2.5">
              <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground shadow-sm">
                <.icon name="tag" size={:sm} />
              </div>
              <div>
                <span class="text-sm font-bold text-foreground leading-none">Pricing</span>
                <p class="text-[10px] text-muted-foreground leading-none mt-0.5 font-medium">Plans</p>
              </div>
            </div>
          </:brand>
          <:nav_items>
            <.nav_section label="Layouts">
              <.nav_item current_path={@current_path} href="/pricing/column" icon="layout-grid" label="Column Pricing" />
              <.nav_item current_path={@current_path} href="/pricing/table"  icon="list"         label="Table Pricing" />
              <.nav_item current_path={@current_path} href="/pricing/single" icon="package"      label="Single Pricing" />
            </.nav_section>
          </:nav_items>
          <:footer_items>
            <div class="px-3 py-1">
              <p class="text-[10px] text-muted-foreground/60 font-medium">PhiaUI &copy; 2026</p>
            </div>
          </:footer_items>
        </.sidebar>
      </:sidebar>
      <%= render_slot(@inner_block) %>
    </.shell>
    """
  end

  # ── Shared sections ────────────────────────────────────────────────────────

  def pricing_why_section(assigns) do
    ~H"""
    <div class="space-y-5">
      <h2 class="text-xl font-bold text-foreground">Why Choose Our Platform?</h2>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div :for={f <- why_features()} class="rounded-xl border border-border bg-card p-6 shadow-sm">
          <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-primary/10 mb-4">
            <.icon name={f.icon} size={:sm} class="text-primary" />
          </div>
          <h3 class="text-base font-bold text-foreground mb-2">{f.title}</h3>
          <p class="text-sm text-muted-foreground leading-relaxed">{f.desc}</p>
        </div>
      </div>
    </div>
    """
  end

  attr :open_faq, :integer, default: nil

  def pricing_faq_section(assigns) do
    assigns = assign(assigns, :items, faqs())
    ~H"""
    <div class="space-y-5">
      <h2 class="text-xl font-bold text-foreground">Frequently Asked Questions</h2>
      <div class="rounded-xl border border-border bg-card shadow-sm overflow-hidden divide-y divide-border">
        <%= for {item, idx} <- Enum.with_index(@items) do %>
          <div>
            <button
              phx-click="toggle-faq"
              phx-value-index={idx}
              class="flex w-full items-center justify-between px-5 py-4 text-left text-sm font-medium text-foreground hover:bg-muted/40 transition-colors min-h-[52px]"
            >
              <span>{item.q}</span>
              <.icon
                name="chevron-down"
                size={:sm}
                class={"shrink-0 ml-4 text-muted-foreground transition-transform duration-200 #{if @open_faq == idx, do: "rotate-180", else: ""}"}
              />
            </button>
            <div :if={@open_faq == idx} class="px-5 pb-4 text-sm text-muted-foreground leading-relaxed">
              {item.a}
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  # ── Private data ────────────────────────────────────────────────────────────

  defp why_features do
    [
      %{icon: "layers", title: "Comprehensive Library",
        desc: "Access thousands of courses across various disciplines"},
      %{icon: "users",  title: "Expert Instructors",
        desc: "Learn from industry professionals and thought leaders"},
      %{icon: "zap",    title: "Flexible Learning",
        desc: "Study at your own pace, anytime and anywhere"}
    ]
  end

  defp faqs do
    [
      %{q: "What payment methods do you accept?",
        a: "We accept all major credit cards (Visa, Mastercard, American Express), PayPal, and bank transfers. All payments are processed securely through our certified payment provider."},
      %{q: "Can I cancel my subscription at any time?",
        a: "Yes, you can cancel your subscription at any time. If you cancel, you'll continue to have access to the platform until the end of your current billing period."},
      %{q: "Is there a limit to how many courses I can take?",
        a: "No, there is no limit. With our Pro and Enterprise plans, you get unlimited access to all courses in our library."},
      %{q: "Do you offer a free trial?",
        a: "Yes, we offer a 14-day free trial for all new users. No credit card required to get started."},
      %{q: "Are the courses downloadable for offline viewing?",
        a: "Yes, courses can be downloaded for offline viewing through our mobile app, available on iOS and Android."}
    ]
  end

  # ── Nav helpers ─────────────────────────────────────────────────────────────

  attr :label, :string, required: true
  slot :inner_block, required: true

  defp nav_section(assigns) do
    ~H"""
    <div class="mb-4">
      <p class="px-3 mb-1.5 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/50">
        {@label}
      </p>
      <div class="space-y-0.5">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  attr :current_path, :string, required: true
  attr :href, :string, required: true
  attr :icon, :string, required: true
  attr :label, :string, required: true

  defp nav_item(assigns) do
    active = assigns.current_path == assigns.href
    assigns = assign(assigns, :active, active)

    ~H"""
    <a
      href={@href}
      class={[
        "group relative flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm transition-all duration-150",
        if(@active,
          do: "bg-primary/10 text-primary font-semibold",
          else: "font-medium text-muted-foreground hover:bg-accent hover:text-foreground"
        )
      ]}
    >
      <span :if={@active} class="absolute left-0 top-1/2 -translate-y-1/2 h-5 w-0.5 rounded-r-full bg-primary" />
      <.icon
        name={@icon}
        size={:sm}
        class={if(@active, do: "shrink-0 text-primary", else: "shrink-0 text-muted-foreground/60 group-hover:text-foreground")}
      />
      <span class="flex-1">{@label}</span>
    </a>
    """
  end
end
