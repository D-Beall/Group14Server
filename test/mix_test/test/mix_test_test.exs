defmodule MixTestTest do
  use ExUnit.Case
  doctest MixTest

  test "greets the world" do
    assert MixTest.hello() == :world
  end
end
