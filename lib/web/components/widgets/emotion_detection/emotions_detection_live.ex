defmodule Bonfire.AI.Web.EmotionsDetectionLive do
  use Bonfire.UI.Common.Web, :stateful_component

  prop text, :string, default: ""
  prop serving, :any, default: nil
  prop results, :list, default: []
  prop task, :any, default: nil


  def update(%{status: status} = assigns, socket) do
    IO.inspect(assigns.results, label: "RESULT")
    {:ok, assign(socket, results: assigns.results, task: nil)}
  end

  def update(assigns, socket) do
    IO.inspect(assigns, label: "UPDATE")
    {:ok, socket
      |> assign(assigns)
      |> assign(serving: serving())}
  end



  def handle_event("predict", _params, socket) do
    pid = self()
    Task.start(fn ->
      res = predict(socket.assigns.serving, socket.assigns.text)
      maybe_send_update(pid, __MODULE__, "test",
        results: res.predictions,
        status: "done",
        task: nil
      )
    end)
    {:noreply, socket}
  end


  defp predict(serving, text) do
    Nx.Serving.run(serving, text) |> debug("ECCOOO")
  end

  defp serving do
      {:ok, model_info} = Bumblebee.load_model({:hf, "finiteautomata/bertweet-base-emotion-analysis"})
      {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "vinai/bertweet-base"})
      Bumblebee.Text.text_classification(model_info, tokenizer,
        top_k: 4,
        compile: [batch_size: 10, sequence_length: 100],
        defn_options: [compiler: EXLA]
      )
  end
  # def do_handle_event(
  #       "custom_event",
  #       _attrs,
  #       socket
  #     ) do
  #   # handle the event here
  #   {:noreply, socket}
  # end

  # def handle_params(params, uri, socket),
  #   do:
  #     Bonfire.UI.Common.LiveHandlers.handle_params(
  #       params,
  #       uri,
  #       socket,
  #       __MODULE__
  #     )

  # def handle_info(info, socket),
  #   do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)

  # def handle_event(
  #       action,
  #       attrs,
  #       socket
  #     ),
  #     do:
  #       Bonfire.UI.Common.LiveHandlers.handle_event(
  #         action,
  #         attrs,
  #         socket,
  #         __MODULE__,
  #         &do_handle_event/3
  #       )
end
