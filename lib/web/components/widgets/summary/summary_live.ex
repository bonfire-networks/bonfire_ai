defmodule Bonfire.AI.Web.SummaryLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop text, :string, default: nil
end
