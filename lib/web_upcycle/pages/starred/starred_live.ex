defmodule Bonfire.Upcycle.Web.StarredLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  declare_nav_link(l("Starred"), icon: "bi:stars")

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.UserRequired]}

  def mount(params, _session, socket) do
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
       smart_input_opts: %{prompt: l("New offer or need")}
     )}
  end

  def handle_params(_params, _url, socket) do
    current_user = current_user_required!(socket)

    %{edges: feed, page_info: page_info} =
      Bonfire.Social.Likes.list_my(
        current_user: current_user,
        object_types: [
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
end
