defmodule Bonfire.Upcycle.Web.StarredLive do
  use Bonfire.UI.Common.Web, :surface_live_view
  alias Bonfire.UI.Me.LivePlugs

  declare_nav_link(l("Starred"), icon: "bi:stars")

  def mount(params, session, socket) do
    live_plug(params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      LivePlugs.UserRequired,
      # LivePlugs.LoadCurrentAccountUsers,
      Bonfire.UI.Common.LivePlugs.StaticChanged,
      Bonfire.UI.Common.LivePlugs.Csrf,
      Bonfire.UI.Common.LivePlugs.Locale,
      &mounted/3
    ])
  end

  defp mounted(params, _session, socket) do
    {:ok,
     socket
     |> assign(
       feed: nil,
       page_info: nil,
       showing_within: :likes,
       loading: false,
       page: "likes",
       page_title: l("Starred"),
       create_object_type: :task,
       smart_input_opts: [prompt: l("New offer or need")]
     )}
  end

  def do_handle_params(_params, _url, socket) do
    current_user = current_user_required!(socket)

    %{edges: feed, page_info: page_info} =
      Bonfire.Social.Likes.list_my(
        current_user: current_user,
        object_type: [
          ValueFlows.Planning.Intent,
          ValueFlows.Proposal,
          ValueFlows.EconomicResource,
          ValueFlows.EconomicEvent
        ]
      )

    # |> debug()

    {:noreply,
     socket
     |> assign(
       feed: feed,
       page_info: page_info
     )}
  end

  def handle_params(params, uri, socket),
    do:
      Bonfire.UI.Common.LiveHandlers.handle_params(
        params,
        uri,
        socket,
        __MODULE__,
        &do_handle_params/3
      )

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)

  def handle_event(
        action,
        attrs,
        socket
      ),
      do:
        Bonfire.UI.Common.LiveHandlers.handle_event(
          action,
          attrs,
          socket,
          __MODULE__
          # &do_handle_event/3
        )
end
