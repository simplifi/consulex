defmodule Consul.IndexStore do
  @moduledoc """
  Wrapper around the ETS table used to store the consul index.
  GenServer is used to create the named table at startup
  """

  use GenServer

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    _tid = :ets.new(__MODULE__, [:named_table, :public])
    {:ok, []}
  end

  @doc """
  Insert a new key value pair in our ETS table
  """
  @spec set(any, any) :: true
  def set(key, value) do
    :ets.insert(__MODULE__, {key, value})
  end

  @doc """
  Return the value associated with the given key.
  If no match is found, returns nil
  """
  @spec get(any) :: any | nil
  def get(key) do
    case :ets.lookup(__MODULE__, key) do
      [] -> nil
      [{_, value}] -> value
    end
  end

  @doc """
  Remove the key
  """
  @spec delete(any) :: true
  def delete(key) do
    :ets.delete(__MODULE__, key)
  end
end
