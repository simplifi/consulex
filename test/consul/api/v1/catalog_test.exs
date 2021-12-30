defmodule Consul.Api.V1.CatalogTest do
  use ExUnit.Case

  @services_response [
    %{"Name" => "List Services Test"}
  ]

  @service_response [
    %{"Name" => "List Node Test"}
  ]

  setup do
    Tesla.Mock.mock(fn
      %{url: "http://example.com/v1/catalog/services"} -> Tesla.Mock.json(@services_response)
      %{url: "http://example.com/v1/catalog/service/tester"} -> Tesla.Mock.json(@service_response)
    end)
    :ok
  end

  test "list_checks" do
    connection = Consul.Connection.new("http://example.com")
    {:ok, %{body: result}} = Consul.Api.V1.Catalog.list_services(connection)
    assert result == @services_response
  end

  test "list_nodes" do
    connection = Consul.Connection.new("http://example.com")
    {:ok, %{body: result}} = Consul.Api.V1.Catalog.list_nodes(connection, "tester")
    assert result == @service_response
  end
end