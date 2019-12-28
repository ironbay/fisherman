defmodule FishermanTest do
  use ExUnit.Case
  doctest Fisherman

  test "greets the world" do
    assert Fisherman.hello() == :world
  end
end
