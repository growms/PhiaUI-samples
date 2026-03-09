defmodule PhiaDemoWeb.Demo.Pricing.SingleLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Pricing.Layout

  @features [
    "Unlimited access to all courses",
    "Personalized learning paths",
    "Progress tracking and analytics",
    "Offline viewing on mobile app",
    "Certificate of completion",
    "24/7 customer support"
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Single Pricing")
     |> assign(:billing, :monthly)
     |> assign(:features, @features)
     |> assign(:open_faq, 1)}
  end

  @impl true
  def handle_event("toggle-billing", _, socket) do
    new = if socket.assigns.billing == :monthly, do: :annual, else: :monthly
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
    <Layout.layout current_path="/pricing/single">
      <div class="p-4 md:p-6 space-y-10 max-w-3xl mx-auto">

        <%!-- Page header --%>
        <div class="phia-animate">
          <h1 class="text-2xl font-bold text-foreground tracking-tight">Choose Your Learning Journey</h1>
          <p class="mt-1.5 text-sm text-muted-foreground">
            Unlock a world of knowledge with our comprehensive e-learning platform
          </p>
        </div>

        <%!-- Single plan card --%>
        <.card class="border-border/60 shadow-sm phia-animate-d1">
          <.card_content class="p-6 md:p-8">
            <div class="grid grid-cols-1 lg:grid-cols-[1fr_220px] gap-8">

              <%!-- Left: plan details --%>
              <div class="space-y-6">
                <div>
                  <h2 class="text-xl font-bold text-foreground">Pro Plan</h2>
                  <p class="text-sm text-muted-foreground mt-1">Everything you need to master new skills</p>
                </div>

                <ul class="space-y-3">
                  <li :for={feat <- @features} class="flex items-center gap-2.5 text-sm text-foreground">
                    <.icon name="check" size={:xs} class="shrink-0 text-emerald-500" />
                    {feat}
                  </li>
                </ul>

                <p class="text-xs text-muted-foreground border-t border-border/60 pt-4">
                  All subscriptions come with a 30-day money-back guarantee. Cancel anytime.
                </p>
              </div>

              <%!-- Right: price + toggle + CTA --%>
              <div class="flex flex-col items-center lg:items-end justify-between gap-6 lg:border-l lg:border-border/60 lg:pl-8">
                <div class="text-center lg:text-right">
                  <div class="flex items-baseline gap-1 justify-center lg:justify-end">
                    <span class="text-5xl font-extrabold text-foreground tabular-nums">
                      ${if @billing == :monthly, do: "14.99", else: "11.99"}
                    </span>
                  </div>
                  <span class="text-sm text-muted-foreground">/month</span>
                </div>

                <%!-- Monthly/Annual toggle --%>
                <div class="flex items-center gap-2.5 text-sm select-none">
                  <span class={if @billing == :monthly, do: "font-semibold text-foreground", else: "text-muted-foreground"}>
                    Monthly
                  </span>
                  <button
                    phx-click="toggle-billing"
                    role="switch"
                    aria-checked={to_string(@billing == :annual)}
                    class={[
                      "relative inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full transition-colors duration-200",
                      if(@billing == :annual, do: "bg-primary", else: "bg-muted")
                    ]}
                  >
                    <span class={[
                      "block h-4 w-4 rounded-full bg-white shadow-sm transition-transform duration-200",
                      if(@billing == :annual, do: "translate-x-6", else: "translate-x-1")
                    ]} />
                  </button>
                  <span class={if @billing == :annual, do: "font-semibold text-foreground", else: "text-muted-foreground"}>
                    Annual
                  </span>
                </div>

                <button class="w-full rounded-lg bg-primary px-6 py-3 text-sm font-bold text-primary-foreground hover:bg-primary/90 transition-colors min-h-[44px]">
                  Start Plan
                </button>
              </div>

            </div>
          </.card_content>
        </.card>

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
end
