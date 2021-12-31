defmodule Consul.Api.V1.Kv do
  @moduledoc """
  Higher level abstraction on top of Consul's Key Value API.
  """

  alias Consul.{Connection, Request, Response}

  @doc """
  Get the value and metadata for a given key from the KV Store.
  """
  def get(connection, key, optional_params \\ []) do
    optional_params_config = %{
      :dc => :query,
      :recurse => :query,
      :raw => :query,
      :keys => :query,
      :separator => :query,
      :ns => :query,
      :index => :query,
      :wait => :query
    }

    request =
      Request.new()
      |> Request.method(:get)
      |> Request.url("/v1/kv/#{key}")
      |> Request.add_optional_params(optional_params_config, optional_params)

    connection
    |> Connection.execute(request)
    |> Response.decode()
  end
end
