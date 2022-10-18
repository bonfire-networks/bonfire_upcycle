defmodule Bonfire.Upcycle.Web.EditResourceLive do
  use Bonfire.UI.Common.Web, :stateless_component
  import Bonfire.Upcycle.Integration

  # prop smart_input_opts, :any, default: nil
  # prop textarea_class, :css_class, required: false
  # # unused but workaround surface "invalid value for property" issue
  # prop textarea_container_class, :css_class
  # prop to_boundaries, :list, default: nil
  # prop open_boundaries, :boolean, default: false

  prop action, :any
  prop changeset, :any
  prop resource, :any
  prop edit_resource_value, :any

  prop input_of_id, :string, default: nil
  prop output_of_id, :string, default: nil
end