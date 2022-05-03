defmodule Bonfire.Upcycle.Web.HomeLive do
  use Bonfire.Web, {:surface_view, [layout: {Bonfire.UI.Social.Web.LayoutView, "without_sidebar.html"}]}

  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.ValueFlows.{IntentCreateActivityLive, CreateMilestoneLive, ProposalFeedLive, FiltersLive}
  alias Bonfire.Web.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.Me.Web.{CreateUserLive, LoggedDashboardLive}

  prop selected_tab, :string, default: "discover"

  def mount(params, session, socket) do
    LivePlugs.live_plug params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      LivePlugs.StaticChanged,
      LivePlugs.Csrf, LivePlugs.Locale,
      &mounted/3,
    ]
  end

  defp mounted(params, session, socket) do
    {:ok, socket
    |> assign(
      page_title: "Upcycle",
      page: "publish-offer",
      action_id: "work",
      intent_type: "offer",
      intent_url: "/upcycle/intent/",
      resource_id: 0,
      resource_name: "",
      resource_quantity: 0
    )}
  end

  def do_handle_params(%{"tab" => "discover" = tab} = _params, _url, socket) do
    current_user = current_user(socket)
    intents = intents(socket)
    IO.inspect(intents)

    {:noreply,
     assign(socket,
        selected_tab: tab,
        intents: intents
     )}
  end

  def do_handle_params(%{"tab" => "my-needs" = tab} = _params, _url, socket) do
    current_user = current_user(socket)
    intents = intents(%{receiver: "me"}, socket)
    IO.inspect(intents)

    {:noreply,
     assign(socket,
       selected_tab: tab,
       intents: intents
     )}
  end

  def do_handle_params(%{"tab" => "my-offers" = tab} = _params, _url, socket) do
    current_user = current_user(socket)
    intents = intents(%{provider: "me"}, socket)
    IO.inspect(intents)
    {:noreply,
     assign(socket,
       selected_tab: tab,
       intents: intents
     )}
  end

  def do_handle_params(%{"tab" => "publish-offer" = tab} = _params, _url, socket) do
    current_user = current_user(socket)
    my_agent = my_agent(socket)

    {:noreply,
     assign(socket,
       selected_tab: tab,
       intents: my_agent
     )}
  end

  def do_handle_params(%{"tab" => "publish-need" = tab} = _params, _url, socket) do
    current_user = current_user(socket)

    {:noreply,
     assign(socket,
       selected_tab: tab
     )}
  end

  def do_handle_params(%{"tab" => "create-resource" = tab} = _params, _url, socket) do
    current_user = current_user(socket)

    {:noreply,
     assign(socket,
       selected_tab: tab,
     )}
  end


  def do_handle_params(%{"tab" => "create-transfer" = tab} = _params, _url, socket) do
    current_user = current_user(socket)
    my_agent = my_agent(socket)

    {:noreply,
     assign(socket,
       selected_tab: tab,
       intents: my_agent
     )}
  end

  def do_handle_params(%{"tab" => tab} = _params, _url, socket) do
    current_user = current_user(socket)
    intents = intents(socket)
    IO.inspect(intents)

    {:noreply,
     assign(socket,
        selected_tab: "discover",
        intents: intents
     )}
  end

  def do_handle_params(%{} = _params, _url, socket) do
    current_user = current_user(socket)
    intents = intents(socket)
    IO.inspect(intents)

    {:noreply,
     assign(socket,
        selected_tab: "discover",
        intents: intents
     )}
  end

  def handle_params(params, uri, socket) do
    undead_params(socket, fn ->
      do_handle_params(params, uri, socket)
    end)
  end

  @graphql """
  query($provider: ID, $receiver: ID) {
    intents(
      filter:{
        provider: $provider,
        receiver: $receiver,
        status: "open"
      },
      limit: 100
    ) {
        id
        name
        has_beginning
        has_point_in_time
        note
        provider {
          name
          id
          display_username
        }
        resourceQuantity {
          hasNumericalValue
        }
        receiver {
          name
          id
          display_username
        }
      }
  }
  """
  def intents(params \\ %{}, socket), do: liveql(socket, :intents, params)

  # defdelegate handle_params(params, attrs, socket), to: Bonfire.Common.LiveHandlers

  def handle_event("my_agent", %{}, socket) do
    my_agent = my_agent(socket)
    {:noreply, socket |> assign(intents: my_agent)}
  end

  @graphql """
  query {
    myAgent {
      id
      displayUsername
      primaryLocation {
        displayUsername
      }
      inventoriedEconomicResources {
        id
        name
        onhandQuantity {
          hasNumericalValue
          hasUnit
        }
      }
    }
  }
  """
  def my_agent(params \\ %{}, socket), do: liveql(socket, :my_agent, params)

  def handle_event("resource_click", %{"id" => id, "name" => name, "quantity" => quantity}, socket) do
    IO.puts("lolXD")
    IO.inspect(socket)
    {:noreply,
      socket |> assign(resource_id: id, resource_name: name, resource_quantity: quantity)}
  end

  @spec handle_event(any, any, any) :: {any, any} | {:ok, any, any} | {:reply, any, any}
  def handle_event(action, attrs, socket), do: Bonfire.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
  def handle_info(info, socket), do: Bonfire.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
