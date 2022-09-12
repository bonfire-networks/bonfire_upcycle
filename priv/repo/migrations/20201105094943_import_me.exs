defmodule Bonfire.Upcycle.Repo.Migrations.ImportMe do
  use Ecto.Migration

  import Bonfire.Upcycle.Migration
  # accounts & users

  def change, do: migrate_me
end
