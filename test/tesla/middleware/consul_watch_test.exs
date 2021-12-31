defmodule Tesla.Middleware.ConsulWatchTest do
  use ExUnit.Case

  def new_client do
    middleware = [
      {Tesla.Middleware.ConsulWatch, wait: 100}
    ]

    Tesla.client(middleware)
  end

  setup do
    Tesla.Mock.mock(fn
      # subsequent calls to this mock will increment the index
      %{query: [wait: _w, index: i]} ->
        index = String.to_integer(i) + 1

        %Tesla.Env{
          status: 200,
          url: "http://example.com",
          headers: [{"x-consul-index", to_string(index)}]
        }

      # initial calls will start at one
      _ ->
        %Tesla.Env{status: 200, url: "http://example.com", headers: [{"x-consul-index", "1"}]}
    end)

    :ok
  end

  test "setting index" do
    # assert that index has not yet been set
    assert nil == Consul.IndexStore.get("http://example.com")
    # assert that index is now set correctly
    _response = Tesla.get!(new_client(), "http://example.com")
    assert "1" == Consul.IndexStore.get("http://example.com")
    # assert that the index is passed in the url if set
    _response = Tesla.get!(new_client(), "http://example.com")
    assert "2" == Consul.IndexStore.get("http://example.com")
  end
end
