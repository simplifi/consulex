defmodule Consul.Response do
  @moduledoc """
  This module helps decode Tesla responses
  """

  alias Consul.JsonCodec

  @doc """
  Handle the response for a Tesla request

  ## Parameters

    * `response` (*type:* `{:ok, Tesla.Env.t} | {:error, reason}`) - The response object
    * `opts` (*type:* `keyword()`) - [optional] Optional parameters
      *   `:as` (*type:* `module()`) - If present, decode as struct or list.

  ## Returns

    * `{:ok, struct()}` on success
    * `{:error, Tesla.Env.t}` on failure
  """
  @spec decode({:ok, Tesla.Env.t()}) :: {:ok, map | binary} | {:error, Tesla.Env.t()}
  def decode(env)

  def decode({:error, reason}), do: {:error, reason}

  def decode({:ok, %Tesla.Env{status: status} = env})
      when status < 200 or status >= 300 do
    {:error, env}
  end

  def decode({:ok, %Tesla.Env{body: body} = env}) do
    case Tesla.get_header(env, "content-type") do
      "application/json" ->
        case do_decode(body) do
          {:ok, json} -> {:ok, json}
          {:error, _reason} -> {:error, env}
        end

      _ ->
        {:ok, body}
    end
  end

  defp do_decode(nil), do: {:ok, nil}
  defp do_decode(body), do: JsonCodec.decode(body)
end
