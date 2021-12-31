defmodule Consul.Api.V1.HealthTest do
  use ExUnit.Case

  alias Consul.Api.V1.Health

  @check_response [
    %{"Name" => "List Check Test"}
  ]

  @service_response [
    %{"Name" => "List Node Test"}
  ]

  setup do
    Tesla.Mock.mock(fn
      %{url: "http://example.com/v1/health/checks/tester"} -> Tesla.Mock.json(@check_response)
      %{url: "http://example.com/v1/health/service/tester"} -> Tesla.Mock.json(@service_response)
    end)

    :ok
  end

  test "list_checks" do
    connection = Consul.Connection.new("http://example.com")
    {:ok, result} = Health.list_checks(connection, "tester")
    assert result == @check_response
  end

  test "list_nodes" do
    connection = Consul.Connection.new("http://example.com")
    {:ok, result} = Health.list_nodes(connection, "tester")
    assert result == @service_response
  end
end
