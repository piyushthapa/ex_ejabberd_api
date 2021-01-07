defmodule EjabberedApiTest do
  use ExUnit.Case
  doctest EjabberedApi

  test "greets the world" do
    assert EjabberedApi.hello() == :world
  end
end
