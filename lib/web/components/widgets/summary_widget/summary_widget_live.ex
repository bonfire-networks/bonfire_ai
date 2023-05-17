defmodule Bonfire.AI.Web.SummaryWidgetLive do
  use Bonfire.UI.Common.Web, :stateful_component

  prop text, :string, default: ""
  prop results, :list, default: []
  prop task, :any, default: nil


  def update(%{status: status} = assigns, socket) do
    IO.inspect(assigns.results, label: "RESULT")
    {:ok, assign(socket, results: assigns.results, task: nil)}
  end

  # def update(assigns, socket) do
  #   IO.inspect(assigns, label: "UPDATE")
  #   {:ok, socket
  #     |> assign(assigns)
  #     |> assign(serving: serving())}
  # end



  def handle_event("predict", _params, socket) do
    pid = self()
    Task.start(fn ->
      res = predict(socket.assigns.text)
      maybe_send_update(pid, __MODULE__, "test",
        results: res.predictions,
        status: "done",
        task: nil
      )
    end)
    {:noreply, socket}
  end


  model_name = "facebook/bart-large-cnn"
  {:ok, model_info} = Bumblebee.load_model({:hf, model_name})
  {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, model_name})

  serving = Bumblebee.Text.Generation.generation(model_info, tokenizer, min_length: 10, max_length: 20)

  defp predict(text) do
    Nx.Serving.run(serving, text) |> debug("ECCOOO")
  end


end
