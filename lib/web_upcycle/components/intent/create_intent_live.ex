defmodule Bonfire.Upcycle.Web.CreateIntentLive do
  use Bonfire.UI.Common.Web, :stateless_component
  import Bonfire.Upcycle

  prop smart_input_opts, :map, default: %{}
  prop textarea_class, :css_class, required: false
  # unused but workaround surface "invalid value for property" issue
  prop textarea_container_class, :css_class
  prop to_boundaries, :any, default: nil
  prop open_boundaries, :boolean, default: false

  prop intent_url, :string, required: false, default: ""
  prop action_id, :string, required: false, default: "work"
  prop output_of_id, :string, required: false
  prop title, :string, default: nil
  prop intent_type, :string, default: :need

  @behaviour Bonfire.UI.Common.SmartInputModule
  def smart_input_module, do: [:upcycle_intent]
end
