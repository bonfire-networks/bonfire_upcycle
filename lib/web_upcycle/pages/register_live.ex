defmodule Bonfire.Web.RegisterLive do
  use Bonfire.UI.Common.Web, :live_view

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(_params, _session, socket) do
    title = "Register User"

    {:ok,
     assign(
       socket,
       page_title: "Register User",
       feed_title: title,
       without_sidebar: true
     )}
  end
end
