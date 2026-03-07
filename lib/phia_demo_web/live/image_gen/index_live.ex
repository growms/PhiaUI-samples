defmodule PhiaDemoWeb.Demo.ImageGenerator.IndexLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.ImageGenerator.Layout

  @styles [
    %{id: "photorealistic", label: "Photorealistic", desc: "True-to-life", icon: "eye"},
    %{id: "illustration", label: "Illustration", desc: "Artistic style", icon: "pencil"},
    %{id: "3d-render", label: "3D Render", desc: "CGI quality", icon: "layers"},
    %{id: "pixel-art", label: "Pixel Art", desc: "Retro gaming", icon: "layout-grid"},
    %{id: "watercolor", label: "Watercolor", desc: "Painterly", icon: "image"},
    %{id: "cinematic", label: "Cinematic", desc: "Film quality", icon: "circle-arrow-up"}
  ]

  @sample_images [
    %{id: 1, prompt: "A serene mountain lake at golden hour", style: "Photorealistic", width: 1024, height: 1024, color: "from-amber-400 to-orange-500"},
    %{id: 2, prompt: "Futuristic cityscape with neon lights", style: "3D Render", width: 1024, height: 768, color: "from-purple-500 to-blue-600"},
    %{id: 3, prompt: "Cozy coffee shop interior illustration", style: "Illustration", width: 768, height: 1024, color: "from-amber-600 to-red-500"},
    %{id: 4, prompt: "Ancient forest with magical creatures", style: "Cinematic", width: 1024, height: 576, color: "from-green-500 to-teal-600"},
    %{id: 5, prompt: "Abstract geometric patterns in blue", style: "3D Render", width: 1024, height: 1024, color: "from-blue-400 to-cyan-500"},
    %{id: 6, prompt: "Portrait of a robot in watercolor", style: "Watercolor", width: 768, height: 1024, color: "from-rose-400 to-pink-600"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Image Generator")
     |> assign(:prompt, "")
     |> assign(:style, "photorealistic")
     |> assign(:width, 1024)
     |> assign(:height, 1024)
     |> assign(:steps, 30)
     |> assign(:guidance, 7.5)
     |> assign(:generating, false)
     |> assign(:images, @sample_images)
     |> assign(:styles, @styles)
     |> assign(:selected_image, nil)}
  end

  @impl true
  def handle_event("update-prompt", %{"value" => val}, socket) do
    {:noreply, assign(socket, :prompt, val)}
  end

  def handle_event("set-style", %{"style" => s}, socket) do
    {:noreply, assign(socket, :style, s)}
  end

  def handle_event("set-steps", %{"value" => val}, socket) do
    {steps, _} = Integer.parse(val)
    {:noreply, assign(socket, :steps, steps)}
  end

  def handle_event("set-guidance", %{"value" => val}, socket) do
    {g, _} = Float.parse(val)
    {:noreply, assign(socket, :guidance, Float.round(g, 1))}
  end

  def handle_event("generate", _params, socket) do
    prompt = String.trim(socket.assigns.prompt)
    if prompt == "" do
      {:noreply, socket}
    else
      socket = assign(socket, :generating, true)
      Process.send_after(self(), :generation_done, 2000)
      {:noreply, socket}
    end
  end

  def handle_event("select-image", %{"id" => id}, socket) do
    image = Enum.find(socket.assigns.images, &(&1.id == String.to_integer(id)))
    {:noreply, assign(socket, :selected_image, image)}
  end

  def handle_event("close-preview", _params, socket) do
    {:noreply, assign(socket, :selected_image, nil)}
  end

  @impl true
  def handle_info(:generation_done, socket) do
    colors = ["from-primary/40 to-primary/80", "from-amber-400 to-orange-500", "from-purple-500 to-blue-600", "from-green-500 to-teal-600"]
    new_image = %{
      id: System.unique_integer([:positive]),
      prompt: socket.assigns.prompt,
      style: String.capitalize(socket.assigns.style),
      width: socket.assigns.width,
      height: socket.assigns.height,
      color: Enum.random(colors)
    }
    {:noreply,
     socket
     |> update(:images, &[new_image | &1])
     |> assign(:generating, false)
     |> assign(:prompt, "")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/image-generator">
      <div class="flex h-full">

        <%!-- Controls panel --%>
        <div class="w-80 shrink-0 border-r border-border/60 bg-card/50 flex flex-col overflow-y-auto">
          <div class="p-5 space-y-5">
            <div>
              <h2 class="text-sm font-semibold text-foreground mb-3">Generate Image</h2>

              <%!-- Prompt --%>
              <div class="space-y-1.5 mb-4">
                <label class="text-xs font-medium text-muted-foreground">Prompt</label>
                <textarea
                  phx-keyup="update-prompt"
                  rows={4}
                  placeholder="Describe the image you want to generate..."
                  class="w-full rounded-lg border border-border bg-background px-3 py-2.5 text-sm resize-none focus:outline-none focus:ring-1 focus:ring-primary/40 transition-all"
                >{@prompt}</textarea>
              </div>

              <%!-- Style selector --%>
              <div class="space-y-1.5 mb-4">
                <label class="text-xs font-medium text-muted-foreground">Style</label>
                <div class="grid grid-cols-2 gap-1.5">
                  <%= for s <- @styles do %>
                    <button
                      phx-click="set-style"
                      phx-value-style={s.id}
                      class={[
                        "flex items-center gap-2 rounded-lg border px-3 py-2 text-left transition-all",
                        if(@style == s.id,
                          do: "border-primary bg-primary/5 text-primary",
                          else: "border-border text-muted-foreground hover:border-primary/40 hover:bg-accent"
                        )
                      ]}
                    >
                      <.icon name={s.icon} size={:xs} class="shrink-0" />
                      <div>
                        <p class="text-xs font-medium leading-none">{s.label}</p>
                        <p class="text-[10px] text-muted-foreground mt-0.5">{s.desc}</p>
                      </div>
                    </button>
                  <% end %>
                </div>
              </div>

              <.separator class="my-4" />

              <%!-- Parameters --%>
              <div class="space-y-4">
                <div>
                  <div class="flex justify-between mb-1.5">
                    <label class="text-xs font-medium text-muted-foreground">Steps</label>
                    <span class="text-xs font-semibold text-foreground">{@steps}</span>
                  </div>
                  <input type="range" min="10" max="50" step="5" value={@steps} phx-change="set-steps" name="value" class="w-full h-1.5 accent-primary" />
                </div>
                <div>
                  <div class="flex justify-between mb-1.5">
                    <label class="text-xs font-medium text-muted-foreground">Guidance Scale</label>
                    <span class="text-xs font-semibold text-foreground">{@guidance}</span>
                  </div>
                  <input type="range" min="1" max="15" step="0.5" value={@guidance} phx-change="set-guidance" name="value" class="w-full h-1.5 accent-primary" />
                </div>
                <div>
                  <label class="text-xs font-medium text-muted-foreground mb-1.5 block">Dimensions</label>
                  <div class="flex gap-2">
                    <%= for {label, w, h} <- [{"Square", 1024, 1024}, {"Portrait", 768, 1024}, {"Landscape", 1024, 768}] do %>
                      <button
                        class={[
                          "flex-1 rounded-md border px-2 py-1.5 text-xs font-medium transition-all",
                          if(@width == w and @height == h,
                            do: "border-primary bg-primary/5 text-primary",
                            else: "border-border text-muted-foreground hover:border-primary/40"
                          )
                        ]}
                      >
                        {label}
                      </button>
                    <% end %>
                  </div>
                </div>
              </div>

              <.button
                class="w-full mt-5"
                phx-click="generate"
                disabled={@generating or @prompt == ""}
              >
                <%= if @generating do %>
                  <.spinner size={:sm} class="mr-2" />
                  Generating...
                <% else %>
                  <.icon name="zap" size={:xs} class="mr-1.5" />
                  Generate
                <% end %>
              </.button>
            </div>
          </div>
        </div>

        <%!-- Gallery --%>
        <div class="flex-1 overflow-auto p-5">
          <div class="flex items-center justify-between mb-4">
            <h2 class="text-sm font-semibold text-foreground">{length(@images)} generated images</h2>
          </div>

          <%= if @generating do %>
            <div class="aspect-square max-w-xs rounded-xl border-2 border-dashed border-primary/40 bg-primary/5 flex items-center justify-center mb-4">
              <div class="text-center">
                <.spinner class="mx-auto mb-2" />
                <p class="text-sm text-muted-foreground">Generating your image...</p>
              </div>
            </div>
          <% end %>

          <div class="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
            <%= for image <- @images do %>
              <button
                phx-click="select-image"
                phx-value-id={image.id}
                class="group relative aspect-square rounded-xl overflow-hidden border border-border/60 hover:border-primary/40 hover:shadow-md transition-all"
              >
                <div class={"w-full h-full bg-gradient-to-br " <> image.color <> " flex items-center justify-center"}>
                  <.icon name="image" class="text-white/30 w-12 h-12" />
                </div>
                <div class="absolute inset-0 bg-black/0 group-hover:bg-black/30 transition-all flex items-end">
                  <div class="p-2 translate-y-full group-hover:translate-y-0 transition-transform">
                    <p class="text-[10px] text-white font-medium line-clamp-2">{image.prompt}</p>
                  </div>
                </div>
              </button>
            <% end %>
          </div>
        </div>

      </div>

      <%!-- Image preview dialog --%>
      <.alert_dialog :if={@selected_image} id="image-preview" open={@selected_image != nil}>
        <.alert_dialog_header>
          <.alert_dialog_title>Image Preview</.alert_dialog_title>
          <.alert_dialog_description>{@selected_image && @selected_image.prompt}</.alert_dialog_description>
        </.alert_dialog_header>
        <div class={"aspect-video w-full rounded-xl bg-gradient-to-br " <> (@selected_image && @selected_image.color || "") <> " flex items-center justify-center"}>
          <.icon name="image" class="text-white/30 w-20 h-20" />
        </div>
        <div :if={@selected_image} class="flex items-center gap-3 text-xs text-muted-foreground">
          <.badge variant={:outline}>{@selected_image.style}</.badge>
          <span>{@selected_image.width}×{@selected_image.height}px</span>
        </div>
        <.alert_dialog_footer>
          <.alert_dialog_cancel phx-click="close-preview">Close</.alert_dialog_cancel>
          <.alert_dialog_action>
            <.icon name="cloud-upload" size={:xs} class="mr-1.5" />
            Download
          </.alert_dialog_action>
        </.alert_dialog_footer>
      </.alert_dialog>
    </Layout.layout>
    """
  end
end
