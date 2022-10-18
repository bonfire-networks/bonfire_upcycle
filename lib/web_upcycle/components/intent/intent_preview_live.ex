defmodule Bonfire.Upcycle.Web.IntentPreviewLive do
  use Bonfire.UI.Common.Web, :stateless_component
  import Bonfire.Upcycle.Integration

  prop resource_quantity, :integer
  prop intent, :any
end
