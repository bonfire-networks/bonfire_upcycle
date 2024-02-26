defmodule Bonfire.Web.InventoryLive do
  use Bonfire.UI.Common.Web, :live_view

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(_params, _session, socket) do
    title = "View Inventory"

    {:ok,
     assign(
       socket,
       page_title: "View Inventory",
       feed_title: title,
       without_sidebar: true
     )}
  end
end
