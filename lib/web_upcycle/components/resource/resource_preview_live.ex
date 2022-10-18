defmodule Bonfire.Upcycle.Web.ResourcePreviewLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop resource, :any
  prop action, :any
  prop edit_resource_value, :any
  prop editable, :any, default: true
end
