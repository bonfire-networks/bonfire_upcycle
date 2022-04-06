defmodule Bonfire.UI.Upcycle.CreateResourceLive do
  use Bonfire.Web, :stateless_component

  prop action, :string, default: "raise"
  prop input_of_id, :string
  prop output_of_id, :string
  prop changeset, :any
end
