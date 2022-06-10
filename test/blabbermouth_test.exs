defmodule BlabbermouthTest do
  use ExUnit.Case
  doctest Blabbermouth

  test "greets the world" do
    assert Blabbermouth.hello() == :world
  end
end
