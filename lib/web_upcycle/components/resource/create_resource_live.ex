defmodule Bonfire.Upcycle.Web.CreateResourceLive do
  use Bonfire.UI.Common.Web, :stateless_component
  import Bonfire.Upcycle

  prop smart_input_opts, :map, default: %{}
  prop textarea_class, :css_class, required: false
  # unused but workaround surface "invalid value for property" issue
  prop textarea_container_class, :css_class
  prop to_boundaries, :any, default: nil
  prop open_boundaries, :boolean, default: false

  prop action, :string, default: "raise"
  prop input_of_id, :string, default: nil
  prop output_of_id, :string, default: nil
  prop changeset, :any, default: nil
  prop pick_event, :any, default: nil
  prop remove_event, :any, default: nil

  prop resource_specifications_autocomplete, :any, default: nil
  prop resource_specification_selected, :any, default: nil

  @behaviour Bonfire.UI.Common.SmartInputModule
  def smart_input_module, do: [:upcycle_resource]
end
