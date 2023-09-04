defmodule Bonfire.AI.Web.HomeLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  declare_extension(
    "ExtensionTemplate",
    icon: "bi:app",
    default_nav: [
      Bonfire.AI.Web.HomeLive,
      Bonfire.AI.Web.AboutLive
    ]
  )

  declare_nav_link(l("Home"), page: "home", icon: "ri:home-line")

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       text: "",
       serving: serving(),
       results: [],
       task: nil
     )}
  end

  def handle_event("predict", %{"text" => text}, socket) do
    task = Task.async(fn -> predict(socket.assigns.serving, text) end)
    {:noreply, assign(socket, text: text, task: task)}
  end

  @impl true
  def handle_info({ref, result}, socket) when socket.assigns.task.ref == ref do
    Process.demonitor(ref, [:flush])
    IO.inspect(result, label: "RESULT")
    {:noreply, assign(socket, results: result.predictions, task: nil)}
  end

  defp predict(serving, text) do
    Nx.Serving.run(serving, text) |> debug("ECCOOO")
  end

  defp serving do
    {:ok, model_info} =
      Bumblebee.load_model({:hf, "finiteautomata/bertweet-base-emotion-analysis"})

    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "vinai/bertweet-base"})

    Bumblebee.Text.text_classification(model_info, tokenizer,
      top_k: 4,
      compile: [batch_size: 10, sequence_length: 100],
      defn_options: [compiler: EXLA]
    )
  end

  # {:ok, _} =
  #   Supervisor.start_link(
  #     [
  #       {Nx.Serving, serving: serving, name: __MODULE__, batch_timeout: 100}
  #     ],
  #     strategy: :one_for_one
  #   )

  # Process.sleep(:infinity)

  def do_handle_event(
        "custom_event",
        _attrs,
        socket
      ) do
    # handle the event here
    {:noreply, socket}
  end

  def handle_params(params, uri, socket),
    do:
      Bonfire.UI.Common.LiveHandlers.handle_params(
        params,
        uri,
        socket,
        __MODULE__
      )

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)

  def handle_event(
        action,
        attrs,
        socket
      ),
      do:
        Bonfire.UI.Common.LiveHandlers.handle_event(
          action,
          attrs,
          socket,
          __MODULE__,
          &do_handle_event/3
        )
end
