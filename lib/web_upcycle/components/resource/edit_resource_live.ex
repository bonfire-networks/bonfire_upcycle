defmodule Bonfire.Upcycle.Web.EditResourceLive do
  use Bonfire.UI.Common.Web, :stateless_component
  import Bonfire.Upcycle.Integration

  # prop smart_input_opts, :list, default: []
  # prop textarea_class, :css_class, required: false
  # # unused but workaround surface "invalid value for property" issue
  # prop textarea_container_class, :css_class
  # prop to_boundaries, :any, default: nil
  # prop open_boundaries, :boolean, default: false

  prop action, :any, default: "raise"
  prop changeset, :any
  prop resource, :any

  prop input_of_id, :string, default: nil
  prop output_of_id, :string, default: nil
end
