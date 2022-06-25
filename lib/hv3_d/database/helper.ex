defmodule HV3D.Database do
  use GenServer

  def init(_arg) do
    %{}
  end

  def start_link(_args) do

    url = Application.get_env(:hv3d, :database_url)

    Mongo.start_link(
      name: :database,
      url: url,
      ssl: true
    )
  end

  defp higienize_name(name) do
    name
    |> String.trim(" ")
    |> String.downcase()
  end

  defp is_name_in_use(name) do

    case length(find("users", %{name: higienize_name(name)})) do
      0 -> false
      _ -> true
    end

  end

  defp is_discord_id_in_use(id) do

    case length(find("users", %{discord_id: id})) do
      0 -> false
      _ -> true
    end

  end

  def find(collection, query \\ %{}) do
    Mongo.find(:database, collection, query)
    |> Enum.to_list()
  end

  def findOne(collection, query \\ %{}) do
    find(collection, query)
    |> Enum.at(0)
  end

  @doc """
    Inserts a new user on database.
  """
  def create_user(name, discord_id) do

    cond do
      is_name_in_use(name) -> {:error, :name_in_use}

      is_discord_id_in_use(name) -> {:error, :discord_registred}

      true ->
        user = %{
          name: higienize_name(name),
          nickname: String.trim(name),
          discord_id: discord_id,
          auth: "",
          conn: "",
          status: %{}
        }
        Mongo.insert_one(:database, "users", user)

        {:ok, user}
    end

  end

end
