defmodule Bonfire.UI.Upcycle.EditResourceLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop action, :any
  prop changeset, :any
  prop resource, :any
  prop edit_resource_value, :any
end
