defmodule Bonfire.Upcycle.Web.ResourceActionsLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop resource, :any
  prop action, :any, default: "raise"
  prop editable, :any, default: true
end
