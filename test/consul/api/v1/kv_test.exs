defmodule Consul.Api.V1.KvTest do
  use ExUnit.Case

  @value %{"key" => "value"}
  @value_string @value |> Jason.encode!() |> Base.encode64()
  @response [
    %{
      "Key" => "tester",
      "Value" => @value_string,
    }
  ]

  setup do
    Tesla.Mock.mock(fn
      %{url: "http://example.com/v1/kv/tester"} -> Tesla.Mock.json(@response)
    end)
    :ok
  end

  test "kv get" do
    connection = Consul.Connection.new("http://example.com")
    {:ok, result} = Consul.Api.V1.Kv.get(connection, "tester")
    %{body: [%{"Value" => @value}]} = result
  end
end