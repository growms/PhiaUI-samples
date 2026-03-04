defmodule PhiaDemoWeb.Demo.Chat.RoomLive do
  use PhiaDemoWeb, :live_view

  alias PhiaDemo.{FakeData, ChatStore}
  alias PhiaDemoWeb.Demo.Chat.Layout

  @current_user_id "admin"

  @impl true
  def mount(params, _session, socket) do
    rooms = FakeData.chat_rooms()
    users = FakeData.chat_users()
    room_id = Map.get(params, "room_id", "general")

    if connected?(socket) do
      Phoenix.PubSub.subscribe(PhiaDemo.PubSub, "chat:room:#{room_id}")
    end

    messages = ChatStore.get_messages(room_id)
    typing = ChatStore.get_typing(room_id)

    {:ok,
     socket
     |> assign(:page_title, "##{room_id}")
     |> assign(:rooms, rooms)
     |> assign(:users, users)
     |> assign(:room_id, room_id)
     |> assign(:messages, messages)
     |> assign(:typing, typing)
     |> assign(:input_text, "")
     |> assign(:poll_open, false)
     |> assign(:poll_question, "")
     |> assign(:poll_options, ["", ""])
     |> assign(:current_user_id, @current_user_id)
     |> assign(:current_user, Enum.find(users, &(&1.id == @current_user_id)))}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    room_id = Map.get(params, "room_id", "general")

    if connected?(socket) and room_id != socket.assigns[:room_id] do
      old_room = socket.assigns[:room_id]
      if old_room, do: Phoenix.PubSub.unsubscribe(PhiaDemo.PubSub, "chat:room:#{old_room}")
      Phoenix.PubSub.subscribe(PhiaDemo.PubSub, "chat:room:#{room_id}")
      ChatStore.set_typing(old_room || room_id, @current_user_id, false)
    end

    messages = ChatStore.get_messages(room_id)
    typing = ChatStore.get_typing(room_id)

    {:noreply,
     socket
     |> assign(:room_id, room_id)
     |> assign(:messages, messages)
     |> assign(:typing, typing)
     |> assign(:page_title, "##{room_id}")}
  end

  # ── Events ────────────────────────────────────────────────────────────────

  @impl true
  def handle_event("typing", %{"value" => text}, socket) do
    room_id = socket.assigns.room_id
    was_typing = socket.assigns.input_text != ""
    is_typing = text != ""

    if is_typing != was_typing do
      ChatStore.set_typing(room_id, @current_user_id, is_typing)
    end

    {:noreply, assign(socket, :input_text, text)}
  end

  def handle_event("send_message", %{"text" => text}, socket) do
    text = String.trim(text)

    if text != "" do
      msg = %{
        id: "msg_#{:erlang.unique_integer([:positive])}",
        user_id: @current_user_id,
        text: text,
        timestamp: format_time(),
        reactions: %{},
        type: :text,
        reply_to: nil
      }

      ChatStore.set_typing(socket.assigns.room_id, @current_user_id, false)
      ChatStore.add_message(socket.assigns.room_id, msg)
    end

    {:noreply, assign(socket, :input_text, "")}
  end

  def handle_event("react", %{"msg_id" => msg_id, "emoji" => emoji}, socket) do
    ChatStore.add_reaction(socket.assigns.room_id, msg_id, emoji, @current_user_id)
    {:noreply, socket}
  end

  def handle_event("vote_poll", %{"msg_id" => msg_id, "option_idx" => idx_str}, socket) do
    idx = String.to_integer(idx_str)
    ChatStore.vote_poll(socket.assigns.room_id, msg_id, idx, @current_user_id)
    {:noreply, socket}
  end

  def handle_event("toggle_poll_dialog", _, socket) do
    {:noreply, update(socket, :poll_open, &(!&1))}
  end

  def handle_event("poll_question_change", %{"value" => q}, socket) do
    {:noreply, assign(socket, :poll_question, q)}
  end

  def handle_event("poll_option_change", %{"index" => idx_str, "value" => v}, socket) do
    idx = String.to_integer(idx_str)
    options = List.replace_at(socket.assigns.poll_options, idx, v)
    {:noreply, assign(socket, :poll_options, options)}
  end

  def handle_event("poll_add_option", _, socket) do
    if length(socket.assigns.poll_options) < 4 do
      {:noreply, update(socket, :poll_options, &(&1 ++ [""]))}
    else
      {:noreply, socket}
    end
  end

  def handle_event("create_poll", _, socket) do
    question = String.trim(socket.assigns.poll_question)
    options = socket.assigns.poll_options |> Enum.map(&String.trim/1) |> Enum.reject(&(&1 == ""))

    if question != "" and length(options) >= 2 do
      poll = %{
        id: "poll_#{:erlang.unique_integer([:positive])}",
        question: question,
        options: Enum.map(options, &%{text: &1, votes: []}),
        created_by: @current_user_id,
        created_at: format_time()
      }

      ChatStore.add_poll(socket.assigns.room_id, poll)

      {:noreply,
       socket
       |> assign(:poll_open, false)
       |> assign(:poll_question, "")
       |> assign(:poll_options, ["", ""])}
    else
      {:noreply, socket}
    end
  end

  # ── PubSub handlers ────────────────────────────────────────────────────────

  @impl true
  def handle_info({:new_message, _msg}, socket) do
    messages = ChatStore.get_messages(socket.assigns.room_id)
    {:noreply, assign(socket, :messages, messages)}
  end

  def handle_info({:reaction_updated, _msg}, socket) do
    messages = ChatStore.get_messages(socket.assigns.room_id)
    {:noreply, assign(socket, :messages, messages)}
  end

  def handle_info({:typing_update, users}, socket) do
    {:noreply, assign(socket, :typing, users)}
  end

  def handle_info({:poll_updated, _msg}, socket) do
    messages = ChatStore.get_messages(socket.assigns.room_id)
    {:noreply, assign(socket, :messages, messages)}
  end

  # ── Render ─────────────────────────────────────────────────────────────────

  @impl true
  def render(assigns) do
    ~H"""
    <Layout.layout rooms={@rooms} current_room_id={@room_id} users={@users}>

      <%!-- Topbar --%>
      <div class="flex items-center gap-3 px-4 h-14 border-b border-border/60 bg-background shrink-0">
        <div class="flex items-center gap-2">
          <.icon name="hash" size={:sm} class="text-muted-foreground" />
          <span class="font-semibold text-foreground">{@room_id}</span>
        </div>
        <div class="ml-auto flex items-center gap-2">
          <.dark_mode_toggle id="chat-theme-toggle" />
          <div class="hidden sm:flex items-center gap-2 text-sm">
            <.avatar size="sm" class="ring-2 ring-primary/20">
              <.avatar_fallback name={@current_user.name} class="bg-primary/10 text-primary text-xs font-semibold" />
            </.avatar>
            <span class="font-medium text-foreground">{@current_user.name}</span>
          </div>
        </div>
      </div>

      <%!-- Messages area --%>
      <div id="chat-messages" class="flex-1 overflow-y-auto p-4 space-y-4" phx-update="replace">
        <%= for msg <- @messages do %>
          <% user = Enum.find(@users, &(&1.id == msg.user_id)) %>
          <% is_me = msg.user_id == @current_user_id %>
          <div id={"msg-#{msg.id}"} class={["flex gap-3 group", if(is_me, do: "flex-row-reverse", else: "")]}>
            <%!-- Avatar --%>
            <.avatar size="sm" class="shrink-0 mt-0.5">
              <.avatar_fallback name={if user, do: user.name, else: "?"} class="bg-primary/10 text-primary text-xs font-semibold" />
            </.avatar>

            <%!-- Bubble --%>
            <div class={["max-w-[70%] space-y-1", if(is_me, do: "items-end", else: "items-start"), "flex flex-col"]}>
              <div class={["flex items-baseline gap-2", if(is_me, do: "flex-row-reverse", else: "")]}>
                <span class="text-xs font-semibold text-foreground">{if user, do: user.name, else: msg.user_id}</span>
                <span class="text-[10px] text-muted-foreground">{msg.timestamp}</span>
              </div>

              <%= if msg.type == :poll and Map.has_key?(msg, :poll) do %>
                <%!-- Poll message --%>
                <div class="rounded-xl border border-border bg-card p-4 space-y-3 w-64">
                  <div class="flex items-center gap-2">
                    <.icon name="chart-bar" size={:xs} class="text-primary" />
                    <span class="text-xs font-semibold text-primary uppercase tracking-wide">Poll</span>
                  </div>
                  <p class="text-sm font-semibold text-foreground">{msg.poll.question}</p>
                  <% total_votes = Enum.sum(Enum.map(msg.poll.options, &length(&1.votes))) %>
                  <%= for {opt, idx} <- Enum.with_index(msg.poll.options) do %>
                    <% pct = if total_votes > 0, do: Float.round(length(opt.votes) / total_votes * 100, 0), else: 0 %>
                    <% voted = @current_user_id in opt.votes %>
                    <button type="button" phx-click="vote_poll" phx-value-msg_id={msg.id} phx-value-option_idx={idx}
                      class={["w-full text-left space-y-1 rounded-lg p-2 transition-colors", if(voted, do: "bg-primary/10", else: "hover:bg-muted/50")]}>
                      <div class="flex justify-between text-xs">
                        <span class={["font-medium", if(voted, do: "text-primary", else: "text-foreground")]}>{opt.text}</span>
                        <span class="text-muted-foreground">{trunc(pct)}%</span>
                      </div>
                      <div class="h-1.5 w-full rounded-full bg-muted overflow-hidden">
                        <div class={["h-1.5 rounded-full transition-all", if(voted, do: "bg-primary", else: "bg-muted-foreground")]}
                          style={"width: #{pct}%"} />
                      </div>
                    </button>
                  <% end %>
                  <p class="text-[10px] text-muted-foreground">{total_votes} vote(s) · click to vote</p>
                </div>
              <% else %>
                <%!-- Text message --%>
                <div class={[
                  "rounded-2xl px-3.5 py-2 text-sm leading-relaxed",
                  if(is_me,
                    do: "bg-primary text-primary-foreground rounded-tr-sm",
                    else: "bg-muted text-foreground rounded-tl-sm"
                  )
                ]}>
                  {msg.text}
                </div>
              <% end %>

              <%!-- Reactions --%>
              <%= if map_size(msg.reactions) > 0 do %>
                <div class="flex flex-wrap gap-1">
                  <%= for {emoji, user_ids} <- msg.reactions do %>
                    <button type="button" phx-click="react" phx-value-msg_id={msg.id} phx-value-emoji={emoji}
                      class={[
                        "inline-flex items-center gap-1 rounded-full border px-1.5 py-0.5 text-xs transition-colors",
                        if(@current_user_id in user_ids, do: "bg-primary/10 border-primary/30 text-primary", else: "bg-muted border-border text-muted-foreground hover:bg-accent")
                      ]}>
                      {emoji} <span class="font-medium">{length(user_ids)}</span>
                    </button>
                  <% end %>
                </div>
              <% end %>

              <%!-- Quick reaction buttons (show on hover) --%>
              <div class="hidden group-hover:flex items-center gap-1">
                <%= for emoji <- ["👍", "❤️", "😂", "🎉"] do %>
                  <button type="button" phx-click="react" phx-value-msg_id={msg.id} phx-value-emoji={emoji}
                    class="text-xs h-6 w-6 flex items-center justify-center rounded-full hover:bg-muted transition-colors">
                    {emoji}
                  </button>
                <% end %>
              </div>
            </div>
          </div>
        <% end %>

        <%!-- Typing indicator --%>
        <%= if @typing != [] and @typing != [@current_user_id] do %>
          <% typers = Enum.reject(@typing, &(&1 == @current_user_id)) %>
          <%= if typers != [] do %>
            <% names = typers |> Enum.map(fn id -> (Enum.find(@users, &(&1.id == id)) || %{name: id}).name end) |> Enum.join(", ") %>
            <div class="flex items-center gap-2 text-xs text-muted-foreground italic px-2">
              <div class="flex gap-0.5">
                <span class="h-1.5 w-1.5 rounded-full bg-muted-foreground animate-bounce" style="animation-delay: 0ms" />
                <span class="h-1.5 w-1.5 rounded-full bg-muted-foreground animate-bounce" style="animation-delay: 150ms" />
                <span class="h-1.5 w-1.5 rounded-full bg-muted-foreground animate-bounce" style="animation-delay: 300ms" />
              </div>
              {names} {if length(typers) == 1, do: "is", else: "are"} typing...
            </div>
          <% end %>
        <% end %>
      </div>

      <%!-- Input bar --%>
      <div class="shrink-0 border-t border-border/60 bg-background px-4 py-3">
        <div class="flex items-center gap-2">
          <%!-- Poll button --%>
          <button type="button" phx-click="toggle_poll_dialog"
            class="h-9 w-9 flex items-center justify-center rounded-full hover:bg-muted text-muted-foreground hover:text-foreground transition-colors">
            <.icon name="chart-bar" size={:sm} />
          </button>

          <%!-- Text input --%>
          <form phx-submit="send_message" class="flex-1 flex items-center gap-2">
            <input
              type="text"
              name="text"
              value={@input_text}
              placeholder={"Message ##{@room_id}"}
              phx-keyup="typing"
              phx-debounce="100"
              autocomplete="off"
              class="flex-1 h-9 rounded-xl border border-input bg-muted/40 px-4 text-sm placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring transition-shadow"
            />
            <button type="submit"
              class="h-9 w-9 flex items-center justify-center rounded-full bg-primary text-primary-foreground hover:bg-primary/90 transition-colors shrink-0">
              <.icon name="send" size={:xs} />
            </button>
          </form>
        </div>
      </div>

      <%!-- Poll creation dialog (simple inline dropdown-style) --%>
      <%= if @poll_open do %>
        <div class="fixed inset-0 bg-background/80 backdrop-blur-sm z-40" phx-click="toggle_poll_dialog" />
        <div class="fixed inset-x-4 bottom-20 md:inset-auto md:bottom-20 md:left-1/2 md:-translate-x-1/2 md:w-96 z-50 rounded-xl border border-border bg-card shadow-xl p-5 space-y-4">
          <div class="flex items-center justify-between">
            <h3 class="font-semibold text-foreground">Create a Poll</h3>
            <button type="button" phx-click="toggle_poll_dialog" class="h-7 w-7 flex items-center justify-center rounded-full hover:bg-muted text-muted-foreground">
              <.icon name="x" size={:xs} />
            </button>
          </div>

          <div class="space-y-1.5">
            <label class="text-xs font-medium text-foreground">Question</label>
            <input type="text" value={@poll_question} phx-keyup="poll_question_change" phx-value-value="" placeholder="Ask a question..."
              class="flex h-9 w-full rounded-md border border-input bg-background px-3 text-sm focus:outline-none focus:ring-2 focus:ring-ring" />
          </div>

          <div class="space-y-2">
            <label class="text-xs font-medium text-foreground">Options</label>
            <%= for {opt, idx} <- Enum.with_index(@poll_options) do %>
              <input type="text" value={opt} phx-keyup="poll_option_change" phx-value-index={idx} phx-value-value="" placeholder={"Option #{idx + 1}"}
                class="flex h-9 w-full rounded-md border border-input bg-background px-3 text-sm focus:outline-none focus:ring-2 focus:ring-ring" />
            <% end %>
            <%= if length(@poll_options) < 4 do %>
              <button type="button" phx-click="poll_add_option"
                class="flex items-center gap-1.5 text-xs text-primary hover:text-primary/80 font-medium transition-colors">
                <.icon name="plus" size={:xs} /> Add option
              </button>
            <% end %>
          </div>

          <div class="flex gap-2 pt-1">
            <button type="button" phx-click="toggle_poll_dialog"
              class="flex-1 h-9 rounded-md border border-input bg-background text-sm font-medium hover:bg-accent transition-colors">
              Cancel
            </button>
            <button type="button" phx-click="create_poll"
              class="flex-1 h-9 rounded-md bg-primary text-primary-foreground text-sm font-medium hover:bg-primary/90 transition-colors">
              Create Poll
            </button>
          </div>
        </div>
      <% end %>

    </Layout.layout>
    """
  end

  defp format_time do
    :calendar.local_time()
    |> elem(1)
    |> then(fn {h, m, _s} -> :io_lib.format("~2..0B:~2..0B", [h, m]) |> to_string() end)
  end
end
