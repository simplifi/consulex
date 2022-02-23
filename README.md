# ExConsulEx

A Consul Client written in Elixir using [`Tesla`](https://github.com/teamon/tesla).

This project was forked from ['Consulex'](https://github.com/team-telnyx/consulex)

At the time of writing, it doesn't support all APIs, just KV/Catalog/Health and
read-only APIs. On the other hand, it implements a
`Tesla.Middleware.ConsulWatch` to ease doing blocking queries to Consul.

## Installation

The package can be installed by adding `exconsulex` to your list of dependencies
in `mix.exs`:

```elixir
def deps do
  [
    {:exconsulex, "~> 0.2"}
  ]
end
```

The JSON interpreter used by default is `Jason`.

This can be overriden with another implementation, such as `Poison` with the following config.
then do:

```elixir
# config/config.exs
config :exconsulex, json_codec: Poison
```

## How to use

For simple polling requests, just create a Consul connection and pass it to a
`Consul.Api` module:

```elixir
connection = Consul.Connection.new("http://consul:8500")
Consul.Api.V1.Health.list_nodes(connection, "my_service", passing: true)
```

In order to make blocking queries, use the option `:wait`:

```elixir
connection = Consul.Connection.new("http://consul:8500", wait: 60_000)
Consul.Api.V1.Health.list_nodes(connection, "my_service", passing: true)
```

In this case, the first execution will return immediately, while the next ones
will wait up to 60 seconds to finalize. The time passed in the `:wait` argument
is in milliseconds.

