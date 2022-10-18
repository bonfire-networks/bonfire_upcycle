defmodule Bonfire.Upcycle.Web.MainNavigationLive do
  use Bonfire.UI.Common.Web, :stateless_component
  alias Surface.Components.LivePatch

  prop page, :string
end
