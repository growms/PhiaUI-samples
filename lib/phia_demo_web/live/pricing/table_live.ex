defmodule PhiaDemoWeb.Demo.Pricing.TableLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Pricing.Layout

  @rows [
    %{label: "Users",        type: :text, basic: "1 user",               pro: "5 users",               enterprise: "Unlimited users"},
    %{label: "Storage",      type: :text, basic: "5GB storage",          pro: "50GB storage",          enterprise: "500GB storage"},
    %{label: "Support",      type: :text, basic: "Basic support",        pro: "Priority support",      enterprise: "24/7 premium support"},
    %{label: "Integrations", type: :text, basic: "Limited integrations", pro: "Advanced integrations", enterprise: "Custom integrations"},
    %{label: "Analytics",    type: :bool, basic: false, pro: true,  enterprise: true},
    %{label: "Api",          type: :bool, basic: false, pro: false, enterprise: true}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Table Pricing")
     |> assign(:billing, :monthly)
     |> assign(:rows, @rows)
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
    <Layout.layout current_path="/pricing/table">
      <div class="p-4 md:p-6 space-y-10 max-w-4xl mx-auto">

        <%!-- Header --%>
        <div class="flex flex-wrap items-center justify-between gap-4 phia-animate">
          <h1 class="text-2xl font-bold text-foreground tracking-tight">Choose Your Plan</h1>
          <.billing_toggle billing={@billing} />
        </div>

        <%!-- Comparison table --%>
        <.card class="border-border/60 shadow-sm phia-animate-d1">
          <.card_content class="p-0">
            <div class="overflow-x-auto">
              <table class="w-full text-sm min-w-[540px]">
                <%!-- Column headers --%>
                <thead>
                  <tr class="border-b border-border/60">
                    <th class="px-5 py-4 text-left text-sm font-semibold text-muted-foreground w-40">
                      Features
                    </th>
                    <th class="px-5 py-4 text-left font-semibold text-foreground">Basic</th>
                    <th class="px-5 py-4 text-left font-semibold text-foreground">Pro</th>
                    <th class="px-5 py-4 text-left font-semibold text-foreground">Enterprise</th>
                  </tr>
                </thead>
                <tbody>
                  <%!-- Price row (dynamic) --%>
                  <tr class="border-b border-border/40 bg-muted/20">
                    <td class="px-5 py-4 text-sm font-medium text-muted-foreground">Price</td>
                    <%= for {monthly, yearly} <- [{"9.99", "7.99"}, {"19.99", "15.99"}, {"49.99", "39.99"}] do %>
                      <td class="px-5 py-4">
                        <div class="flex items-baseline gap-0.5">
                          <span class="text-xl font-extrabold text-foreground tabular-nums">
                            ${if @billing == :monthly, do: monthly, else: yearly}
                          </span>
                          <span class="text-xs text-muted-foreground">/month</span>
                        </div>
                      </td>
                    <% end %>
                  </tr>

                  <%!-- Feature rows --%>
                  <%= for row <- @rows do %>
                    <tr class="border-b border-border/40 last:border-b-0 hover:bg-muted/20 transition-colors">
                      <td class="px-5 py-3.5 text-sm font-medium text-muted-foreground">{row.label}</td>
                      <%= for col <- [:basic, :pro, :enterprise] do %>
                        <td class="px-5 py-3.5">
                          <%= cond do %>
                            <% row.type == :bool and Map.get(row, col) -> %>
                              <.icon name="check" size={:sm} class="text-emerald-500" />
                            <% row.type == :bool -> %>
                              <.icon name="x" size={:sm} class="text-red-500" />
                            <% true -> %>
                              <span class="text-sm text-foreground">{Map.get(row, col)}</span>
                          <% end %>
                        </td>
                      <% end %>
                    </tr>
                  <% end %>

                  <%!-- CTA row --%>
                  <tr>
                    <td class="px-5 py-5" />
                    <%= for {label, _href} <- [{"Choose Basic", "#"}, {"Choose Pro", "#"}, {"Choose Enterprise", "#"}] do %>
                      <td class="px-5 py-5">
                        <button class="w-full rounded-lg border border-border py-2 text-sm font-semibold text-foreground hover:bg-accent transition-colors min-h-[40px]">
                          {label}
                        </button>
                      </td>
                    <% end %>
                  </tr>
                </tbody>
              </table>
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
