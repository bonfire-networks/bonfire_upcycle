defmodule Bonfire.Upcycle.Web.ResourcePreviewLive do
  use Bonfire.UI.Common.Web, :stateless_component
  import Bonfire.Upcycle.Integration

  prop resource, :any
  prop action, :any, default: "raise"
  prop editable, :any, default: true
end
