defmodule Tesla.Middleware.ConsulWatch do
  @moduledoc """
  Fills the request so it results in a Consul blocking query.

  ## Example usage

  ```
  defmodule Myclient do
    use Tesla
    plug Tesla.Middleware.ConsulWatch, wait: 60_000
  end
  ```
  """

  @behaviour Tesla.Middleware

  @default_wait 60_000
  @header_x_consul_index "x-consul-index"

  @impl Tesla.Middleware
  def call(env, next, opts) do
    env
    |> load_index(opts)
    |> Tesla.run(next)
    |> store_index()
  end

  # Look up the current index for this url
  # If we have none, then perform unblocking get to find initial index
  defp load_index(%{method: :get, url: url} = env, opts) do
    case Consul.IndexStore.get(url) do
      nil ->
        env

      index ->
        wait =
          Keyword.get(opts, :wait, @default_wait)
          |> format_time()

        env
        |> Map.update!(:query, &(&1 ++ [wait: wait, index: index]))
    end
  end

  # Do not perform a blocking wait if this isn't a get operation
  defp load_index(env, _opts), do: env

  defp format_time(duration), do: "#{duration}ms"

  # Save off the received index for next call
  def store_index({:ok, %{url: url} = env}) do
    case Tesla.get_header(env, @header_x_consul_index) do
      nil ->
        Consul.IndexStore.delete(url)

      index ->
        Consul.IndexStore.set(url, index)
    end

    {:ok, env}
  end

  def store_index({:error, reason}), do: {:error, reason}
end
