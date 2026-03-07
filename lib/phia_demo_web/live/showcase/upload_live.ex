defmodule PhiaDemoWeb.Demo.Showcase.UploadLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.Demo.Showcase.Layout

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Upload Showcase")
     |> allow_upload(:showcase_image,
       accept: ~w(.jpg .jpeg .png .webp .gif),
       max_entries: 3,
       max_file_size: 5_242_880
     )
     |> allow_upload(:showcase_file,
       accept: ~w(.pdf .doc .docx .txt .csv),
       max_entries: 5,
       max_file_size: 10_485_760
     )}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel_upload", %{"ref" => ref, "name" => name}, socket) do
    upload_name = String.to_existing_atom(name)
    {:noreply, cancel_upload(socket, upload_name, ref)}
  end

  def handle_event("noop", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout current_path="/showcase/upload">
      <div class="p-6 space-y-10 max-w-screen-xl mx-auto phia-animate">

        <div>
          <h1 class="text-2xl font-bold text-foreground tracking-tight">Upload</h1>
          <p class="text-muted-foreground mt-1">File upload, image upload, avatar upload, and drop zones.</p>
        </div>

        <%!-- ImageUpload --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">ImageUpload</h2>
          <div class="max-w-md">
            <.form for={%{}} phx-change="validate" phx-submit="noop">
              <.image_upload upload={@uploads.showcase_image} label="Click or drag & drop images here (JPG, PNG, WEBP)" />
            </.form>
          </div>
        </section>

        <%!-- FileUpload --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">FileUpload</h2>
          <div class="max-w-md">
            <.form for={%{}} phx-change="validate" phx-submit="noop">
              <.file_upload upload={@uploads.showcase_file} label="Upload Documents" accept=".pdf,.doc,.docx">
                <:empty>
                  <p class="text-sm text-muted-foreground">Drag &amp; drop files here or <span class="text-primary font-medium">click to browse</span></p>
                  <p class="text-[11px] text-muted-foreground/60 mt-1">PDF, DOC, DOCX up to 10MB</p>
                </:empty>
                <:file :let={entry}>
                  <.file_upload_entry entry={entry} on_cancel="cancel_upload" />
                </:file>
              </.file_upload>
            </.form>
          </div>
        </section>

        <%!-- Drop zone pattern --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Drop Zone Pattern</h2>
          <div class="rounded-xl border-2 border-dashed border-border p-12 text-center hover:border-primary/50 hover:bg-primary/5 transition-all cursor-pointer group">
            <div class="flex h-14 w-14 mx-auto items-center justify-center rounded-xl bg-muted group-hover:bg-primary/10 transition-colors mb-4">
              <.icon name="cloud-upload" size={:sm} class="text-muted-foreground group-hover:text-primary transition-colors" />
            </div>
            <p class="text-sm font-semibold text-foreground">Drop files here to upload</p>
            <p class="text-xs text-muted-foreground mt-1">or <span class="text-primary font-medium">click to browse</span></p>
            <p class="text-[10px] text-muted-foreground mt-3">PNG, JPG, PDF up to 50MB</p>
          </div>
        </section>

        <%!-- Upload progress mock --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Upload Progress</h2>
          <.card class="border-border/60 shadow-sm max-w-md">
            <.card_content class="p-5 space-y-4">
              <%= for {name, pct, icon_name} <- [{"hero-banner.png", 100, "image"}, {"Q1-Report.pdf", 73, "file-text"}, {"assets.zip", 28, "package"}] do %>
                <div class="space-y-1.5">
                  <div class="flex items-center justify-between text-sm">
                    <div class="flex items-center gap-2">
                      <.icon name={icon_name} size={:xs} class="text-primary" />
                      <span class="font-medium text-foreground">{name}</span>
                    </div>
                    <div class="flex items-center gap-2">
                      <span class="text-xs text-muted-foreground">{pct}%</span>
                      <%= if pct == 100 do %>
                        <.icon name="circle-check" size={:xs} class="text-green-500" />
                      <% else %>
                        <.icon name="x" size={:xs} class="text-muted-foreground hover:text-destructive cursor-pointer" />
                      <% end %>
                    </div>
                  </div>
                  <.progress value={pct} class={"h-1.5 " <> if(pct == 100, do: "[&>div]:bg-green-500", else: "")} />
                </div>
              <% end %>
            </.card_content>
          </.card>
        </section>

        <%!-- Avatar upload --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">Avatar Upload Pattern</h2>
          <div class="flex items-center gap-6">
            <div class="relative">
              <.avatar size="xl">
                <.avatar_fallback name="John Doe" class="bg-primary/10 text-primary text-lg font-semibold" />
              </.avatar>
              <button class="absolute bottom-0 right-0 flex h-7 w-7 items-center justify-center rounded-full border-2 border-background bg-primary text-primary-foreground shadow-sm hover:bg-primary/90 transition-colors">
                <.icon name="pencil" size={:xs} />
              </button>
            </div>
            <div>
              <p class="text-sm font-semibold text-foreground">John Doe</p>
              <p class="text-xs text-muted-foreground mb-2">john@acme.com</p>
              <.button variant={:outline} size={:sm}>
                <.icon name="upload" size={:xs} class="mr-1.5" />
                Upload photo
              </.button>
            </div>
          </div>
        </section>

        <%!-- CopyButton --%>
        <section class="space-y-4">
          <h2 class="text-base font-semibold text-foreground border-b border-border/60 pb-2">CopyButton</h2>
          <div class="space-y-3 max-w-md">
            <div class="flex items-center gap-2 rounded-lg border border-border bg-muted/30 px-3 py-2">
              <code class="flex-1 font-mono text-sm text-foreground">npm install phia_ui</code>
              <.copy_button id="copy-npm" value="npm install phia_ui" label="Copy install command" />
            </div>
            <div class="flex items-center gap-2 rounded-lg border border-border bg-muted/30 px-3 py-2">
              <code class="flex-1 font-mono text-sm text-foreground">phia_prod_k1x8m2n4p6q9...</code>
              <.copy_button id="copy-key" value="phia_prod_k1x8m2n4p6q9r3s5t7u0v2w4y6z8a1b3" label="Copy API key" />
            </div>
            <div class="flex items-center gap-2 rounded-lg border border-border bg-muted/30 px-3 py-2">
              <code class="flex-1 font-mono text-sm text-foreground">mix phia.install Button Card Badge</code>
              <.copy_button id="copy-mix" value="mix phia.install Button Card Badge" label="Copy mix command" />
            </div>
          </div>
        </section>

      </div>
    </Layout.layout>
    """
  end
end
