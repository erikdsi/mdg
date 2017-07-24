defmodule MdgTest do
  use ExUnit.Case
  doctest Mdg.Password
  doctest Mdg.Password.Tests
  doctest Mdg.Password.Helpers

  test "the truth" do
    assert 1 + 1 == 2
  end
end
