defmodule HV3D.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws}) when msg.author.bot == nil do

    Api.create_message(msg.channel_id, content: "Oi")

  end

  def handle_event(_event) do
    :noop
  end

end
