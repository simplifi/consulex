defmodule Consul.JsonCodec do
  @moduledoc """
  Interface to JSON library
  Defaults to using Jason
  """

  @type json_value :: nil | true | false | list | float | integer | String.t() | map

  # Expected behaviours
  @callback decode(iodata) :: {:ok, json_value} | {:error, term}

  def decode(iodata), do: json_codec().decode(iodata)

  defp json_codec, do: Application.get_env(:exconsulex, :json_codec, Jason)
end
