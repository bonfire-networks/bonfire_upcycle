defmodule Bonfire.UI.Upcycle.CreateTransferLive do
  use Bonfire.UI.Common.Web, :stateless_component

  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  prop action, :string, default: "transfer"
  prop input_of_id, :string
  prop output_of_id, :string
  prop changeset, :any

  prop intents, :any

  prop receiver, :any, default: nil
  prop provider, :any, default: nil

  prop resource_id, :string
  prop resource_name, :string
  prop resource_quantity, :any

  prop users_autocomplete, :any, default: nil

end
