defmodule DreamspellTest do
  use ExUnit.Case
  doctest Dreamspell

  test "greets the world" do
    assert Dreamspell.hello() == :world
  end
end
