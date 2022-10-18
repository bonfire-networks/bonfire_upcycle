defmodule Bonfire.Upcycle.Web.IntentLive do
  use Bonfire.UI.Common.Web, :stateless_component
  import Bonfire.Upcycle.Integration

  prop resource_quantity, :integer
  prop intent, :any
end
