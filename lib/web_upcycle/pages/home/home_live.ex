defmodule Bonfire.Upcycle.Web.HomeLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  alias Bonfire.UI.ValueFlows.IntentCreateActivityLive
  alias Bonfire.UI.ValueFlows.CreateMilestoneLive
  alias Bonfire.UI.ValueFlows.FiltersLive

  alias Bonfire.UI.Me.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive
  alias Bonfire.UI.Me.LoggedDashboardLive

  prop selected_tab, :string, default: "discover"

  @icon """
  <svg stroke-miterlimit="10" version="1.1" viewBox="0 0 566.876 680.091" xml:space="preserve" xmlns="http://www.w3.org/2000/svg">
  <g id="g3">
  <path d="M218.002 495.855L218.002 430.652C220.342 429.757 222.625 428.689 224.817 427.395C255.904 409.068 259.172 357 232.11 311.107C205.051 265.212 157.914 242.867 126.828 261.195C95.741 279.524 92.474 331.589 119.531 377.483C123.897 384.886 128.789 391.665 134.048 397.77L134.048 446.209L67.046 407.865L67.046 167.711L43.561 152.208C22.167 191.187 10 235.949 10 283.551C10 431.455 127.359 551.868 274.08 556.728L274.105 528.55C274.105 528.55 218.002 495.855 218.002 495.855Z" fill="#0e9a48" fill-rule="nonzero" opacity="1" stroke="none"/>
  <path d="M140.184 114.246L181.136 138.516C180.329 145.245 180.303 152.653 180.329 155.2C180.704 191.285 229.574 218.717 282.849 218.165C336.124 217.613 374.068 185.338 373.799 153.585C373.495 117.501 338.795 89.2489 285.54 87.6609C267.511 87.1229 250.132 90.7229 242.218 92.2349L212.35 73.1289L283.387 32.5979L492.799 154.323L516.816 141.14C493.711 103.15 460.989 70.2729 419.735 46.5209C291.557-27.2761 128.646 14.3509 51.23 139.079L75.051 154.121C75.051 154.121 140.184 114.246 140.184 114.246Z" fill="#cb2026" fill-rule="nonzero" opacity="1" stroke="none"/>
  <path d="M499.865 246.552L455.333 269.829C453.719 269.559 443.834 260.307 441.61 259.065C410.084 241.502 363.672 264.724 337.743 311.266C311.813 357.806 314.024 411.019 345.548 428.586C377.075 446.148 424.018 425.077 449.951 378.537C454.133 371.029 459.718 353.599 462.329 345.978L500.267 324.046L500.042 407.319L291.191 529.289L291.292 556.77C335.74 555.537 380.515 543.416 421.593 519.364C549.223 444.628 593.83 282.509 523.887 153.443L499.865 166.634C499.865 166.634 499.865 246.552 499.865 246.552Z" fill="#35469d" fill-rule="nonzero" opacity="1" stroke="none"/>
  </g>
  </svg>
  """

  declare_extension("Upcycle", icon: @icon)

  declare_nav_link([
    {l("Discover"), href: "/upcycle", icon: "mdi:bulletin-board"},
    {l("My offers & needs"), href: "/upcycle/my-intents", icon: "mdi:offer"},
    {l("Settings"), href: path(:upcycle_settings), icon: "ph:sliders-bold"}
  ])

  def mount(params, session, socket) do
    live_plug(params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      Bonfire.UI.Common.LivePlugs.StaticChanged,
      Bonfire.UI.Common.LivePlugs.Csrf,
      Bonfire.UI.Common.LivePlugs.Locale,
      &mounted/3
    ])
  end

  defp mounted(params, session, socket) do
    {:ok,
     assign(
       socket,
       page_title: "Upcycle",
       page: "publish-offer",
       action_id: "work",
       intent_url: "/upcycle/intent/",
       resource_id: 0,
       resource_name: "",
       resource_quantity: 0,
       create_object_type: :upcycle_intent,
       smart_input_prompt: l("New offer or need"),
       sidebar_widgets: [
         users: [
           secondary: [
             {Bonfire.UI.ValueFlows.FilterIntentsLive, []}
           ]
         ],
         guests: [
           secondary: [
             {Bonfire.Tag.Web.WidgetTagsLive, []}
           ]
         ]
       ]
     )}
  end

  def do_handle_params(%{"tab" => "discover" = tab} = _params, _url, socket) do
    current_user = current_user(socket)
    intents = intents(socket)
    IO.inspect(intents)

    {:noreply,
     assign(socket,
       selected_tab: tab,
       intents: intents,
       page_title: l("Upcycle: offers & needs")
     )}
  end

  # def do_handle_params(%{"tab" => "my-needs" = tab} = _params, _url, socket) do
  #   current_user = current_user(socket)
  #   intents = intents(%{receiver: "me"}, socket)
  #   IO.inspect(intents)

  #   {:noreply,
  #    assign(socket,
  #      selected_tab: tab,
  #      intents: intents
  #    )}
  # end

  # def do_handle_params(%{"tab" => "my-offers" = tab} = _params, _url, socket) do
  #   current_user = current_user(socket)
  #   intents = intents(%{provider: "me"}, socket)
  #   IO.inspect(intents)

  #   {:noreply,
  #    assign(socket,
  #      selected_tab: tab,
  #      intents: intents
  #    )}
  # end

  def do_handle_params(%{"tab" => "my-intents" = tab} = _params, _url, socket) do
    current_user = current_user(socket)
    intents = intents(%{agent: "me"}, socket)

    {:noreply,
     assign(socket,
       selected_tab: tab,
       intents: intents,
       page_title: l("My offers & needs")
     )}
  end

  def do_handle_params(
        %{"tab" => "create-transfer" = tab} = _params,
        _url,
        socket
      ) do
    current_user = current_user(socket)
    my_agent = my_agent(socket)

    {:noreply,
     assign(socket,
       selected_tab: tab,
       intents: my_agent
     )}
  end

  def do_handle_params(params, url, socket) do
    do_handle_params(Map.merge(params, %{"tab" => "discover"}), url, socket)
  end

  def handle_params(params, uri, socket) do
    # poor man's hook I guess
    with {_, socket} <-
           Bonfire.UI.Common.LiveHandlers.handle_params(params, uri, socket) do
      undead_params(socket, fn ->
        do_handle_params(params, uri, socket)
      end)
    end
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
        image
        provider {
          name
          id
          display_username
        }
        resource_quantity {
          has_numerical_value
          has_unit {
            label
          }
        }
        receiver {
          name
          id
          display_username
        }
        resource_inventoried_as {
          image
        }
      }
  }
  """
  def intents(params \\ %{}, socket), do: liveql(socket, :intents, params)

  # defdelegate handle_params(params, attrs, socket), to: Bonfire.UI.Common.LiveHandlers

  def handle_event("my_agent", %{}, socket) do
    my_agent = my_agent(socket)
    {:noreply, assign(socket, intents: my_agent)}
  end

  @graphql """
  query {
    my_agent {
      id
      display_username
      primary_location {
        display_username
      }
      inventoried_economic_resources {
        id
        name
        onhand_quantity {
          has_numerical_value
          has_unit
        }
      }
    }
  }
  """
  def my_agent(params \\ %{}, socket), do: liveql(socket, :my_agent, params)

  @spec handle_event(any, any, any) ::
          {any, any} | {:ok, any, any} | {:reply, any, any}
  def handle_event(action, attrs, socket),
    do:
      Bonfire.UI.Common.LiveHandlers.handle_event(
        action,
        attrs,
        socket,
        __MODULE__
      )

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
