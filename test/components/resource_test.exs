defmodule Bonfire.Upcycle.Web.ResourceLive.Test do
  use ExUnit.Case, async: true

  test "can show day of week" do
    assert Bonfire.Upcycle.Web.ResourceLive.get_last_activity(~D[2022-02-15]) == "Tue Feb 15 2022"
  end
end
