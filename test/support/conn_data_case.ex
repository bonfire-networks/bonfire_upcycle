defmodule Bonfire.Upcycle.ConnDataCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require both setting up a connection
  and access to the database.

  See ConnCase and DataCase for more details.
  """

  use ExUnit.CaseTemplate

  import Bonfire.Upcycle.Integration

  using do
    quote do
      # import Bonfire.Upcycle.ConnDataCase
      import Bonfire.Upcycle.Test.ConnHelpers
      import Bonfire.Upcycle.Test.FakeHelpers
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Phoenix.ConnTest
      import Phoenix.LiveViewTest
      import Plug.Conn

      alias Bonfire.Me.Fake

      @endpoint Application.compile_env!(:bonfire, :endpoint_module)
    end
  end

  setup tags do
    import Bonfire.Upcycle.Integration

    Bonfire.Common.Test.Interactive.setup_test_repo(tags)

    {:ok, []}
  end

  @doc """
  See DataCase.errors_on for more details.
  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
