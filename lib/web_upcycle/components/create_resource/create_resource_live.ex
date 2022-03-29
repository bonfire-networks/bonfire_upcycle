defmodule Bonfire.UI.Upcycle.CreateResourceLive do
  use Bonfire.Web, :stateless_component

  prop action, :string, default: "raise"
  prop input_of_id, :string
  prop output_of_id, :string
  prop changeset, :any

  def mount(socket) do
    {:ok, socket |> assign(
      form_error: "",
      changeset: ValueFlows.EconomicEvent.validate_changeset()
      )}
  end

end
