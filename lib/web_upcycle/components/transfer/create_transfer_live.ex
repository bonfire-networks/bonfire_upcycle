defmodule Bonfire.Upcycle.Web.CreateTransferLive do
  use Bonfire.UI.Common.Web, :stateless_component
  import Bonfire.Upcycle.Integration

  prop smart_input_opts, :map, default: %{}
  prop textarea_class, :css_class, required: false
  # unused but workaround surface "invalid value for property" issue
  prop textarea_container_class, :css_class
  prop to_boundaries, :any, default: nil
  prop open_boundaries, :boolean, default: false
  prop reply_to_id, :any, default: nil

  prop action, :string, default: "transfer"
  prop input_of_id, :string, default: nil
  prop output_of_id, :string, default: nil
  prop changeset, :any, default: nil

  prop resources, :list, default: nil

  prop receiver, :any, default: nil
  prop provider, :any, default: nil

  prop resource_id, :string, default: nil
  prop resource_name, :string, default: nil
  prop resource_quantity, :any, default: nil
  prop unit_id, :string, default: nil
  prop unit_name, :string, default: nil

  prop users_autocomplete, :any, default: nil

  @behaviour Bonfire.UI.Common.SmartInputModule
  def smart_input_module, do: [:upcycle_transfer]
end
