defmodule Bonfire.UI.Upcycle.IntentLive do
  use Bonfire.UI.Common.Web, :stateless_component
  import Bonfire.Upcycle.Integration

  prop resourceQuantity, :integer
  prop intent, :any


end
