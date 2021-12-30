import Config

config :consulex, json_codec: Jason

# Configure tesla for testing purposes
config :tesla, adapter: Tesla.Mock