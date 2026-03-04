defmodule PhiaDemoWeb.DashboardLive.Components do
  @moduledoc """
  Component showcase page demonstrating new PhiaUI v0.1.3 components:
  Carousel, Drawer, Combobox, Popover, ContextMenu, Avatar Group, Badges, Alerts.
  """

  use PhiaDemoWeb, :live_view

  alias PhiaDemoWeb.DashboardLayout

  @fruit_options [
    %{value: "apple", label: "Maçã"},
    %{value: "banana", label: "Banana"},
    %{value: "cherry", label: "Cereja"},
    %{value: "grape", label: "Uva"},
    %{value: "kiwi", label: "Kiwi"},
    %{value: "mango", label: "Manga"},
    %{value: "orange", label: "Laranja"},
    %{value: "pear", label: "Pera"},
    %{value: "strawberry", label: "Morango"},
    %{value: "watermelon", label: "Melancia"}
  ]

  @carousel_slides [
    %{
      title: "Carousel Component",
      subtitle: "Toque, teclado e mouse",
      description: "Navegue com swipe, teclas de seta ou botões laterais. Suporta loop infinito.",
      color: "from-primary/20 to-secondary/60",
      icon: "chevrons-left-right"
    },
    %{
      title: "Drawer Component",
      subtitle: "Painel deslizante",
      description: "Abre a partir de qualquer borda da tela com animação suave e trap de foco.",
      color: "from-secondary/60 to-primary/10",
      icon: "panel-right"
    },
    %{
      title: "Popover Component",
      subtitle: "Painel flutuante",
      description: "Posicionamento inteligente com flip automático ao atingir a borda da viewport.",
      color: "from-muted/80 to-secondary/40",
      icon: "message-square"
    },
    %{
      title: "Combobox Component",
      subtitle: "Seleção com busca",
      description: "Filtragem em tempo real, acessível via teclado, integrado ao sistema de forms.",
      color: "from-primary/10 to-muted/60",
      icon: "search"
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Componentes")
     |> assign(:fruit, nil)
     |> assign(:fruit_open, false)
     |> assign(:fruit_search, "")
     |> assign(:fruit_options, @fruit_options)
     |> assign(:carousel_slides, @carousel_slides)
     |> assign(:ctx_menu_show_preview, false)}
  end

  @impl true
  def handle_event("fruit-toggle", _params, socket) do
    {:noreply, update(socket, :fruit_open, &(!&1))}
  end

  @impl true
  def handle_event("fruit-search", %{"query" => q}, socket) do
    {:noreply, assign(socket, :fruit_search, q)}
  end

  @impl true
  def handle_event("fruit-change", %{"value" => v}, socket) do
    {:noreply, assign(socket, fruit: v, fruit_open: false, fruit_search: "")}
  end

  @impl true
  def handle_event("toggle_preview", _params, socket) do
    {:noreply, update(socket, :ctx_menu_show_preview, &(!&1))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DashboardLayout.layout current_path="/components">
      <div class="p-6 space-y-8">
        <%!-- Breadcrumb --%>
        <.breadcrumb>
          <.breadcrumb_list>
            <.breadcrumb_item>
              <.breadcrumb_link href="/">Dashboard</.breadcrumb_link>
            </.breadcrumb_item>
            <.breadcrumb_separator />
            <.breadcrumb_item>
              <.breadcrumb_page>Componentes</.breadcrumb_page>
            </.breadcrumb_item>
          </.breadcrumb_list>
        </.breadcrumb>

        <%!-- Header --%>
        <div>
          <div class="flex items-center gap-2 mb-1">
            <h1 class="text-2xl font-bold text-foreground tracking-tight">Showcase de Componentes</h1>
            <.badge variant={:default}>v0.1.3</.badge>
          </div>
          <p class="text-sm text-muted-foreground">
            Demonstração interativa dos componentes da biblioteca PhiaUI — novos em v0.1.3 e componentes avançados.
          </p>
        </div>

        <%!-- ── CAROUSEL ───────────────────────────────────────────────── --%>
        <section class="space-y-3">
          <div>
            <h2 class="text-lg font-semibold text-foreground">Carousel</h2>
            <p class="text-sm text-muted-foreground">Swipe, teclado (← →) ou botões laterais. Loop habilitado.</p>
          </div>
          <.carousel id="showcase-carousel" loop={true}>
            <.carousel_content>
              <.carousel_item :for={slide <- @carousel_slides}>
                <div class="px-2">
                  <.card class={"border-0 bg-gradient-to-br #{slide.color}"}>
                    <.card_content class="p-8">
                      <div class="flex items-start gap-6">
                        <div class="flex h-14 w-14 shrink-0 items-center justify-center rounded-xl bg-primary/15 text-primary">
                          <.icon name={slide.icon} size={:lg} />
                        </div>
                        <div>
                          <p class="text-xs font-semibold text-muted-foreground uppercase tracking-wider">{slide.subtitle}</p>
                          <h3 class="text-xl font-bold text-foreground mt-1">{slide.title}</h3>
                          <p class="text-sm text-muted-foreground mt-2 max-w-lg">{slide.description}</p>
                        </div>
                      </div>
                    </.card_content>
                  </.card>
                </div>
              </.carousel_item>
            </.carousel_content>
            <.carousel_previous />
            <.carousel_next />
          </.carousel>
        </section>

        <%!-- ── COMBOBOX ──────────────────────────────────────────────── --%>
        <section class="space-y-3">
          <div>
            <h2 class="text-lg font-semibold text-foreground">Combobox</h2>
            <p class="text-sm text-muted-foreground">Seleção com filtragem em tempo real — estado gerenciado pelo servidor.</p>
          </div>
          <.card>
            <.card_content class="p-6">
              <div class="grid gap-6 sm:grid-cols-2 items-start">
                <div class="space-y-2">
                  <label class="text-sm font-medium text-foreground">Selecione uma fruta</label>
                  <.combobox
                    id="fruit-showcase-combobox"
                    options={@fruit_options}
                    value={@fruit}
                    open={@fruit_open}
                    search={@fruit_search}
                    placeholder="Escolher fruta..."
                    search_placeholder="Buscar fruta..."
                    on_change="fruit-change"
                    on_search="fruit-search"
                    on_toggle="fruit-toggle"
                  />
                  <p class="text-xs text-muted-foreground">{length(@fruit_options)} opções disponíveis</p>
                </div>
                <div class="flex items-center gap-3 rounded-lg border bg-muted/40 p-4">
                  <%= if @fruit do %>
                    <div class="flex h-10 w-10 items-center justify-center rounded-full bg-primary/15">
                      <.icon name="check-circle" size={:md} class="text-primary" />
                    </div>
                    <div>
                      <p class="text-sm font-semibold text-foreground">Selecionado</p>
                      <p class="text-sm text-muted-foreground capitalize">{@fruit}</p>
                    </div>
                  <% else %>
                    <div class="flex h-10 w-10 items-center justify-center rounded-full bg-muted">
                      <.icon name="help-circle" size={:md} class="text-muted-foreground" />
                    </div>
                    <p class="text-sm text-muted-foreground">Nenhuma opção selecionada ainda</p>
                  <% end %>
                </div>
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- ── POPOVER ───────────────────────────────────────────────── --%>
        <section class="space-y-3">
          <div>
            <h2 class="text-lg font-semibold text-foreground">Popover</h2>
            <p class="text-sm text-muted-foreground">Painel flutuante com posicionamento inteligente e focus trap.</p>
          </div>
          <.card>
            <.card_content class="p-6">
              <div class="flex flex-wrap gap-4">
                <.popover id="info-popover">
                  <.popover_trigger popover_id="info-popover">
                    <.button variant={:outline} size={:sm}>
                      <.icon name="info" size={:sm} class="mr-1.5" />
                      Informações
                    </.button>
                  </.popover_trigger>
                  <.popover_content popover_id="info-popover" position={:bottom} class="w-72">
                    <h4 class="font-semibold text-foreground mb-1">Sobre este Popover</h4>
                    <p class="text-sm text-muted-foreground">
                      Este é um exemplo do componente <code class="font-mono text-xs bg-muted px-1 rounded">Popover</code>.
                      Clique fora ou pressione Escape para fechar.
                    </p>
                  </.popover_content>
                </.popover>

                <.popover id="user-popover">
                  <.popover_trigger popover_id="user-popover">
                    <.button variant={:default} size={:sm}>
                      <.icon name="user" size={:sm} class="mr-1.5" />
                      Perfil Rápido
                    </.button>
                  </.popover_trigger>
                  <.popover_content popover_id="user-popover" position={:bottom} class="w-64">
                    <div class="flex items-center gap-3 mb-3">
                      <.avatar size="default" class="ring-2 ring-primary/20">
                        <.avatar_fallback name="Admin Costa" class="bg-primary/15 text-primary font-semibold" />
                      </.avatar>
                      <div>
                        <p class="font-semibold text-sm text-foreground">Admin Costa</p>
                        <p class="text-xs text-muted-foreground">admin@acme.com</p>
                      </div>
                    </div>
                    <div class="border-t pt-3 space-y-1">
                      <button class="w-full text-left text-sm px-2 py-1.5 rounded hover:bg-accent transition-colors text-foreground">Meu Perfil</button>
                      <button class="w-full text-left text-sm px-2 py-1.5 rounded hover:bg-accent transition-colors text-foreground">Configurações</button>
                      <button class="w-full text-left text-sm px-2 py-1.5 rounded hover:bg-destructive/10 text-destructive transition-colors">Sair</button>
                    </div>
                  </.popover_content>
                </.popover>

                <.popover id="settings-popover">
                  <.popover_trigger popover_id="settings-popover">
                    <.button variant={:secondary} size={:sm}>
                      <.icon name="settings" size={:sm} class="mr-1.5" />
                      Ajustes Rápidos
                    </.button>
                  </.popover_trigger>
                  <.popover_content popover_id="settings-popover" position={:bottom} class="w-60">
                    <div class="space-y-3">
                      <h4 class="font-semibold text-sm text-foreground">Preferências</h4>
                      <%= for {label, _key} <- [{"Notificações por e-mail", :email}, {"Alertas no navegador", :browser}, {"Resumo semanal", :weekly}] do %>
                        <label class="flex items-center justify-between cursor-pointer">
                          <span class="text-sm text-foreground">{label}</span>
                          <input type="checkbox" class="h-4 w-4 accent-primary" />
                        </label>
                      <% end %>
                      <button class="w-full text-sm font-medium bg-primary text-primary-foreground rounded-md px-3 py-1.5 hover:bg-primary/90 transition-colors">
                        Salvar
                      </button>
                    </div>
                  </.popover_content>
                </.popover>
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- ── CONTEXT MENU ─────────────────────────────────────────── --%>
        <section class="space-y-3">
          <div>
            <h2 class="text-lg font-semibold text-foreground">Context Menu</h2>
            <p class="text-sm text-muted-foreground">Botão direito na área abaixo para abrir o menu contextual.</p>
          </div>
          <.card>
            <.card_content class="p-6">
              <.context_menu id="demo-ctx-menu">
                <.context_menu_trigger context_menu_id="demo-ctx-menu">
                  <div class="flex items-center justify-center rounded-xl border-2 border-dashed border-primary/30 bg-primary/5 h-36 cursor-context-menu select-none transition-colors hover:bg-primary/10">
                    <div class="text-center">
                      <.icon name="mouse-pointer-2" size={:lg} class="text-primary/60 mx-auto mb-2" />
                      <p class="text-sm font-medium text-foreground">Clique com o botão direito</p>
                      <p class="text-xs text-muted-foreground mt-1">para abrir o menu contextual</p>
                    </div>
                  </div>
                </.context_menu_trigger>
                <.context_menu_content id="demo-ctx-menu-content">
                  <.context_menu_label>Arquivo</.context_menu_label>
                  <.context_menu_item>Abrir</.context_menu_item>
                  <.context_menu_item>Renomear</.context_menu_item>
                  <.context_menu_item>Duplicar</.context_menu_item>
                  <.context_menu_separator />
                  <.context_menu_checkbox_item
                    checked={@ctx_menu_show_preview}
                    phx-click="toggle_preview"
                  >
                    Mostrar Pré-visualização
                  </.context_menu_checkbox_item>
                  <.context_menu_separator />
                  <.context_menu_item class="text-destructive focus:text-destructive">
                    Excluir
                  </.context_menu_item>
                </.context_menu_content>
              </.context_menu>
              <%= if @ctx_menu_show_preview do %>
                <p class="text-xs text-muted-foreground mt-3 text-center">
                  ✓ Pré-visualização <strong class="text-foreground">ativada</strong> via Context Menu
                </p>
              <% end %>
            </.card_content>
          </.card>
        </section>

        <%!-- ── DRAWER ────────────────────────────────────────────────── --%>
        <section class="space-y-3">
          <div>
            <h2 class="text-lg font-semibold text-foreground">Drawer</h2>
            <p class="text-sm text-muted-foreground">Painel deslizante a partir de qualquer borda — com focus trap e Escape para fechar.</p>
          </div>
          <.card>
            <.card_content class="p-6">
              <div class="flex flex-wrap gap-3">
                <button
                  type="button"
                  data-drawer-trigger="showcase-drawer-right"
                  class="inline-flex items-center gap-2 h-9 px-4 rounded-md border border-input bg-background text-sm font-medium hover:bg-accent transition-colors"
                >
                  <.icon name="panel-right" size={:sm} />
                  Direita
                </button>
                <button
                  type="button"
                  data-drawer-trigger="showcase-drawer-left"
                  class="inline-flex items-center gap-2 h-9 px-4 rounded-md border border-input bg-background text-sm font-medium hover:bg-accent transition-colors"
                >
                  <.icon name="panel-left" size={:sm} />
                  Esquerda
                </button>
                <button
                  type="button"
                  data-drawer-trigger="showcase-drawer-bottom"
                  class="inline-flex items-center gap-2 h-9 px-4 rounded-md border border-input bg-background text-sm font-medium hover:bg-accent transition-colors"
                >
                  <.icon name="panel-bottom" size={:sm} />
                  Baixo
                </button>
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- ── AVATAR ────────────────────────────────────────────────── --%>
        <section class="space-y-3">
          <div>
            <h2 class="text-lg font-semibold text-foreground">Avatar & Avatar Group</h2>
            <p class="text-sm text-muted-foreground">Avatares individuais e em grupo sobrepostos.</p>
          </div>
          <.card>
            <.card_content class="p-6">
              <div class="flex flex-wrap gap-8 items-center">
                <div class="space-y-2">
                  <p class="text-xs font-medium text-muted-foreground uppercase tracking-wider">Tamanhos</p>
                  <div class="flex items-center gap-3">
                    <.avatar size="sm"><.avatar_fallback name="Ana Costa" class="bg-primary/15 text-primary font-semibold" /></.avatar>
                    <.avatar size="default"><.avatar_fallback name="Bruno Lima" class="bg-secondary text-secondary-foreground font-semibold" /></.avatar>
                    <.avatar size="lg"><.avatar_fallback name="Carla Souza" class="bg-primary/15 text-primary font-bold" /></.avatar>
                    <.avatar size="xl"><.avatar_fallback name="Diego Melo" class="bg-secondary text-secondary-foreground font-bold" /></.avatar>
                  </div>
                </div>
                <div class="space-y-2">
                  <p class="text-xs font-medium text-muted-foreground uppercase tracking-wider">Grupo</p>
                  <div class="flex items-center gap-4">
                    <.avatar_group>
                      <.avatar class="ring-2 ring-background"><.avatar_fallback name="Ana Costa" class="bg-primary/15 text-primary font-semibold" /></.avatar>
                      <.avatar class="ring-2 ring-background"><.avatar_fallback name="Bruno Lima" class="bg-secondary text-secondary-foreground font-semibold" /></.avatar>
                      <.avatar class="ring-2 ring-background"><.avatar_fallback name="Carla Souza" class="bg-primary/15 text-primary font-semibold" /></.avatar>
                      <.avatar class="ring-2 ring-background"><.avatar_fallback name="Diego Melo" class="bg-secondary text-secondary-foreground font-semibold" /></.avatar>
                    </.avatar_group>
                    <p class="text-sm text-muted-foreground">+12 participantes</p>
                  </div>
                </div>
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- ── BADGES ────────────────────────────────────────────────── --%>
        <section class="space-y-3">
          <div>
            <h2 class="text-lg font-semibold text-foreground">Badge</h2>
            <p class="text-sm text-muted-foreground">Todas as variantes disponíveis.</p>
          </div>
          <.card>
            <.card_content class="p-6">
              <div class="flex flex-wrap gap-2">
                <.badge variant={:default}>Default</.badge>
                <.badge variant={:secondary}>Secondary</.badge>
                <.badge variant={:outline}>Outline</.badge>
                <.badge variant={:destructive}>Destructive</.badge>
                <.badge variant={:secondary}>Secondary Alt</.badge>
                <.badge variant={:ghost}>Ghost</.badge>
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- ── ALERTS ────────────────────────────────────────────────── --%>
        <section class="space-y-3">
          <div>
            <h2 class="text-lg font-semibold text-foreground">Alert</h2>
            <p class="text-sm text-muted-foreground">Variantes para diferentes contextos de notificação.</p>
          </div>
          <div class="space-y-3">
            <.alert variant={:default}>
              <.alert_title>Informação</.alert_title>
              <.alert_description>Esta é uma mensagem informativa padrão do sistema.</.alert_description>
            </.alert>
            <.alert variant={:success}>
              <.alert_title>Sucesso</.alert_title>
              <.alert_description>Operação concluída com êxito. Dados salvos corretamente.</.alert_description>
            </.alert>
            <.alert variant={:warning}>
              <.alert_title>Atenção</.alert_title>
              <.alert_description>Esta ação pode ter consequências. Revise antes de prosseguir.</.alert_description>
            </.alert>
            <.alert variant={:destructive}>
              <.alert_title>Erro Crítico</.alert_title>
              <.alert_description>Falha na operação. Verifique os dados e tente novamente.</.alert_description>
            </.alert>
          </div>
        </section>

        <%!-- ── COLLAPSIBLE ──────────────────────────────────────────── --%>
        <section class="space-y-3">
          <div>
            <h2 class="text-lg font-semibold text-foreground">Collapsible</h2>
            <p class="text-sm text-muted-foreground">Seção expansível com conteúdo oculto por padrão.</p>
          </div>
          <.collapsible id="showcase-collapsible">
            <.collapsible_trigger
              collapsible_id="showcase-collapsible"
              class="flex w-full items-center justify-between rounded-lg border bg-card px-4 py-3 text-sm font-medium hover:bg-accent/50 transition-colors"
            >
              <span>Clique para expandir o conteúdo</span>
              <svg class="h-4 w-4 text-muted-foreground" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
              </svg>
            </.collapsible_trigger>
            <.collapsible_content id="showcase-collapsible-content">
              <div class="mt-2 rounded-lg border bg-card p-4 text-sm text-muted-foreground space-y-2">
                <p>Este conteúdo estava oculto e agora está visível. O componente <code class="font-mono text-xs bg-muted px-1 rounded">Collapsible</code> é ideal para FAQs, filtros e seções secundárias.</p>
                <p>Pode conter qualquer tipo de conteúdo — tabelas, formulários, listas, etc.</p>
              </div>
            </.collapsible_content>
          </.collapsible>
        </section>
      </div>

      <%!-- Drawers do showcase --%>
      <.drawer_content id="showcase-drawer-right" open={false} direction="right">
        <.drawer_header>
          <h2 id="showcase-drawer-right-title" class="text-lg font-semibold">Drawer — Direita</h2>
          <p class="text-sm text-muted-foreground mt-1">Desliza a partir da borda direita</p>
        </.drawer_header>
        <.drawer_close />
        <div class="px-6 pb-6 space-y-4">
          <p class="text-sm text-muted-foreground">
            O <code class="font-mono text-xs bg-muted px-1 rounded">drawer_content</code> pode ser ativado por qualquer botão com <code class="font-mono text-xs bg-muted px-1 rounded">data-drawer-trigger</code> no documento — não precisa estar dentro do componente <code class="font-mono text-xs bg-muted px-1 rounded">drawer</code>.
          </p>
          <div class="space-y-2">
            <%= for item <- ["Focus trap ativo", "Escape para fechar", "Clique fora fecha", "Foco retorna ao trigger", "Animação CSS suave"] do %>
              <div class="flex items-center gap-2 text-sm">
                <div class="h-2 w-2 rounded-full bg-primary" />
                <span class="text-foreground">{item}</span>
              </div>
            <% end %>
          </div>
        </div>
        <.drawer_footer>
          <.button variant={:outline} size={:sm}>Cancelar</.button>
          <.button variant={:default} size={:sm}>Confirmar</.button>
        </.drawer_footer>
      </.drawer_content>

      <.drawer_content id="showcase-drawer-left" open={false} direction="left">
        <.drawer_header>
          <h2 id="showcase-drawer-left-title" class="text-lg font-semibold">Drawer — Esquerda</h2>
          <p class="text-sm text-muted-foreground mt-1">Desliza a partir da borda esquerda</p>
        </.drawer_header>
        <.drawer_close />
        <div class="px-6 pb-6">
          <p class="text-sm text-muted-foreground">Conteúdo do drawer esquerdo. Útil para menus de navegação secundários.</p>
        </div>
      </.drawer_content>

      <.drawer_content id="showcase-drawer-bottom" open={false} direction="bottom">
        <.drawer_header>
          <h2 id="showcase-drawer-bottom-title" class="text-lg font-semibold">Drawer — Baixo</h2>
          <p class="text-sm text-muted-foreground mt-1">Desliza a partir da borda inferior (bottom sheet)</p>
        </.drawer_header>
        <.drawer_close />
        <div class="px-6 pb-6">
          <p class="text-sm text-muted-foreground">Drawer bottom — muito usado em mobile como bottom sheet alternativo a modais. Máximo de 85vh de altura com scroll automático.</p>
        </div>
        <.drawer_footer>
          <.button variant={:default} class="w-full">Fechar</.button>
        </.drawer_footer>
      </.drawer_content>
    </DashboardLayout.layout>
    """
  end
end
