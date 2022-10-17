defmodule Bonfire.UI.Upcycle.CreateResourceLive do
  use Bonfire.UI.Common.Web, :stateless_component


  prop smart_input_opts, :any, default: nil
  prop textarea_class, :css_class, required: false
  # unused but workaround surface "invalid value for property" issue
  prop textarea_container_class, :css_class
  prop to_boundaries, :list, default: nil
  prop open_boundaries, :boolean, default: false
  
  prop action, :string, default: "raise"
  prop input_of_id, :string
  prop output_of_id, :string
  prop changeset, :any
  prop pick_event, :any, default: nil
  prop remove_event, :any, default: nil

  prop resource_specifications_autocomplete, :any, default: nil
  prop resource_specification_selected, :any, default: nil
end
