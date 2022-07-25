defmodule Bonfire.UI.Upcycle.CreateResourceLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop action, :string, default: "raise"
  prop input_of_id, :string
  prop output_of_id, :string
  prop changeset, :any
  prop pick_event, :any, default: nil
  prop remove_event, :any, default: nil

  prop resource_specifications_autocomplete, :any, default: nil
  prop resource_specification_selected, :any, default: nil
end
