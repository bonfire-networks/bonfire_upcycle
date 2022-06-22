defmodule Bonfire.UI.Upcycle.MainNavigationLive do
  use Bonfire.UI.Common.Web, :stateless_component
  alias Surface.Components.LivePatch

  prop page, :string
end
