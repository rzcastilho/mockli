defmodule MockliTest do
  use ExUnit.Case
  doctest Mockli

  test "greets the world" do
    assert Mockli.hello() == :world
  end
end
