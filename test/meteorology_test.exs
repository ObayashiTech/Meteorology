defmodule MeteorologyTest do
  use ExUnit.Case
  doctest Meteorology

  test "greets the world" do
    assert Meteorology.hello() == :world
  end
end
