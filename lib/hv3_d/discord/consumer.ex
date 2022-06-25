defmodule HV3D.Discord.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias HV3D.Database

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  defp get_name_input(interaction) do
    name = interaction.data.components |> Enum.at(0)
    name = name.components |> Enum.at(0)
    name.value
  end

  defp user_registred(guild_id, discord_id) do

    user = Database.findOne("users", %{discord_id: discord_id})

    roles_id = Application.get_env(:hv3d, :roles_id)

    Api.modify_guild_member(guild_id, discord_id, %{
      nick: user["nickname"],
      roles: [roles_id.registred]
    })
  end

  def handle_event({:GUILD_MEMBER_ADD, {guild_id, member}, _ws}) do
    user_registred(guild_id, member.user.id)
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws}) when interaction.data.custom_id == "create_account" do

    input = %Nostrum.Struct.Component{
      custom_id: "input_name",
      type: 4,
      min_length: 3,
      max_length: 25,
      label: "Digite seu nome utilizado no Haxball",
      placeholder: "Nome",
      required: true,
      style: 1
    }

    Api.create_interaction_response(interaction,
      %{
        type: 9,
        data: %{
          title: "Criação de conta",
          custom_id: "submit_account",
          components: [
            %Nostrum.Struct.Component{
              type: 1,
              components: [input]
            }
          ]
        }
      }
    )

  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws}) when interaction.data.custom_id == "submit_account" do

    name = get_name_input(interaction)
    discord_id = interaction.user.id

    case Database.create_user(name, discord_id) do

      {:ok, _user} ->
        user_registred(interaction.guild_id, interaction.user.id)
        Api.create_interaction_response(interaction, %{
          type: 6
        })

      {:error, :discord_registred} ->
        user_registred(interaction.guild_id, interaction.user.id)
        Api.create_interaction_response(interaction, %{
          type: 6
        })

      {:error, _error} -> :error

    end

  end

  def handle_event(_event) do
    :noop
  end

end
