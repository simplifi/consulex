defmodule Consul.Api.V1.KvTest do
  use ExUnit.Case

  alias Consul.Api.V1.Kv

  @value "test"
  @response [
    %{
      "Key" => "tester",
      "Value" => Base.encode64(@value)
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
    {:ok, result} = Kv.get(connection, "tester")
    assert result == @response
  end
end
