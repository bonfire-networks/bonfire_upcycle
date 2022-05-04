defmodule Bonfire.UI.Upcycle.ResourceLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop resource, :any

  defp mounted(params, session, socket) do
    current_user = current_user(socket)

    {:ok, socket
    |> assign(
      user: current_user,
    )}
  end
end
