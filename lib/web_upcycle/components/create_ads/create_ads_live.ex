defmodule Bonfire.UI.Upcycle.CreateAdsLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop smart_input_opts, :any, default: nil
  prop textarea_class, :css_class, required: false
  # unused but workaround surface "invalid value for property" issue
  prop textarea_container_class, :css_class
  prop to_boundaries, :list, default: nil
  prop open_boundaries, :boolean, default: false
  
  prop intent_url, :string, required: false, default: ""
  prop action_id, :string, required: false, default: "work"
  prop output_of_id, :string, required: false
  prop title, :string, default: "Create a new Ad"
  prop intent_type, :string, default: "need"
end
