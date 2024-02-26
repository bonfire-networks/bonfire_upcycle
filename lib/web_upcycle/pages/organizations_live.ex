defmodule Bonfire.Web.OrganizationsLive do
  use Bonfire.UI.Common.Web, :live_view

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(_params, _session, socket) do
    title = "All Organizations"

    {:ok,
     assign(
       socket,
       page_title: "All Organizations",
       feed_title: title,
       without_sidebar: true
     )}
  end
end
