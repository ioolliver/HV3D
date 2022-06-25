import Config

config :nostrum,
  token: "", # Secret
  gateway_intents: :all


config :hv3d,
  database_url: "", # Secret
  roles_id: %{
    registred: 987152935534358588
  }


import_config("secret.exs")
