defmodule PhiaDemoWeb.Demo.Pricing.ColumnLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Pricing.Layout

  @plans [
    %{
      name: "Basic",
      desc: "Essential features for individuals",
      monthly: "9.99", yearly: "7.99",
      features: ["1 user", "5GB storage", "Basic support", "Limited integrations"],
      cta: "Choose Basic",
      popular: false
    },
    %{
      name: "Pro",
      desc: "Advanced features for professionals",
      monthly: "19.99", yearly: "15.99",
      features: ["5 users", "50GB storage", "Priority support", "Advanced integrations", "Analytics"],
      cta: "Choose Pro",
      popular: true
    },
    %{
      name: "Enterprise",
      desc: "Comprehensive solution for teams",
      monthly: "49.99", yearly: "39.99",
      features: ["Unlimited users", "500GB storage", "24/7 premium support", "Custom integrations", "Advanced analytics", "API access"],
      cta: "Choose Enterprise",
      popular: false
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Column Pricing")
     |> assign(:billing, :monthly)
     |> assign(:plans, @plans)
     |> assign(:open_faq, nil)}
  end

  @impl true
  def handle_event("toggle-billing", _, socket) do
    new = if socket.assigns.billing == :monthly, do: :yearly, else: :monthly
    {:noreply, assign(socket, :billing, new)}
  end

  def handle_event("toggle-faq", %{"index" => idx}, socket) do
    idx = String.to_integer(idx)
    open = if socket.assigns.open_faq == idx, do: nil, else: idx
    {:noreply, assign(socket, :open_faq, open)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/pricing/column">
      <div class="p-4 md:p-6 space-y-10 max-w-4xl mx-auto">

        <%!-- Header --%>
        <div class="flex flex-wrap items-center justify-between gap-4 phia-animate">
          <h1 class="text-2xl font-bold text-foreground tracking-tight">Choose Your Plan</h1>
          <.billing_toggle billing={@billing} />
        </div>

        <%!-- Plan cards --%>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 phia-animate-d1">
          <div
            :for={plan <- @plans}
            class={[
              "relative flex flex-col rounded-xl border p-6 shadow-sm transition-all duration-200 hover:shadow-md",
              if(plan.popular,
                do: "border-primary bg-card ring-1 ring-primary/40",
                else: "border-border bg-card")
            ]}
          >
            <%!-- Popular badge --%>
            <div
              :if={plan.popular}
              class="absolute -top-3 left-1/2 -translate-x-1/2 inline-flex items-center rounded-full bg-primary px-3 py-1 text-[11px] font-bold text-primary-foreground shadow"
            >
              Most Popular
            </div>

            <%!-- Plan name + desc --%>
            <div class="mb-5">
              <h2 class="text-base font-bold text-foreground">{plan.name}</h2>
              <p class="text-sm text-muted-foreground mt-0.5">{plan.desc}</p>
            </div>

            <%!-- Price --%>
            <div class="mb-6 flex items-baseline gap-1">
              <span class="text-4xl font-extrabold text-foreground tabular-nums">
                ${if @billing == :monthly, do: plan.monthly, else: plan.yearly}
              </span>
              <span class="text-sm text-muted-foreground">/month</span>
            </div>

            <%!-- Features --%>
            <ul class="flex-1 space-y-3 mb-8">
              <li :for={feat <- plan.features} class="flex items-center gap-2.5 text-sm text-foreground">
                <.icon name="check" size={:xs} class="shrink-0 text-emerald-500" />
                {feat}
              </li>
            </ul>

            <%!-- CTA --%>
            <button class={[
              "w-full rounded-lg border py-2.5 text-sm font-semibold transition-colors min-h-[44px]",
              if(plan.popular,
                do: "bg-primary border-primary text-primary-foreground hover:bg-primary/90",
                else: "border-border text-foreground hover:bg-accent")
            ]}>
              {plan.cta}
            </button>
          </div>
        </div>

        <%!-- Why section --%>
        <div class="phia-animate-d2">
          <Layout.pricing_why_section />
        </div>

        <%!-- FAQ --%>
        <div class="phia-animate-d3">
          <Layout.pricing_faq_section open_faq={@open_faq} />
        </div>

      </div>
    </Layout.layout>
    """
  end

  # Shared billing toggle component
  attr :billing, :atom, required: true

  defp billing_toggle(assigns) do
    ~H"""
    <div class="flex items-center gap-2.5 text-sm select-none">
      <span class={if @billing == :monthly, do: "font-semibold text-foreground", else: "text-muted-foreground"}>
        Monthly
      </span>
      <button
        phx-click="toggle-billing"
        role="switch"
        aria-checked={to_string(@billing == :yearly)}
        class={[
          "relative inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full transition-colors duration-200",
          if(@billing == :yearly, do: "bg-primary", else: "bg-muted")
        ]}
      >
        <span class={[
          "block h-4 w-4 rounded-full bg-white shadow-sm transition-transform duration-200",
          if(@billing == :yearly, do: "translate-x-6", else: "translate-x-1")
        ]} />
      </button>
      <span class={if @billing == :yearly, do: "font-semibold text-foreground", else: "text-muted-foreground"}>
        Yearly
        <span class="ml-1 inline-flex items-center rounded-full bg-emerald-500/10 px-1.5 py-0.5 text-[10px] font-bold text-emerald-600 dark:text-emerald-400">
          -20%
        </span>
      </span>
    </div>
    """
  end
end
