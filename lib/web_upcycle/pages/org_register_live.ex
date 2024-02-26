defmodule Bonfire.Web.OrgRegisterLive do
  use Bonfire.UI.Common.Web, :live_view

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(_params, _session, socket) do
    title = "Organization Registration"

    {:ok,
     assign(
       socket,
       page_title: "Organization Registration",
       feed_title: title,
       without_sidebar: true
     )}
  end
end
