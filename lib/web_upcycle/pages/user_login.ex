defmodule Bonfire.Web.UserLogin do
  use Bonfire.UI.Common.Web, :live_view

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(_params, _session, socket) do
    title = "Login"

    {:ok,
     assign(
       socket,
       page_title: "Login",
       feed_title: title,
       without_sidebar: true
     )}
  end
end
