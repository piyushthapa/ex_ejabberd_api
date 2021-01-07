defmodule EjabberedApi.Configs do
  @moduledoc """
    fetch ejabbered configuration
  """

  defstruct [:host, :port, :room_service, :username, :password, :mode]

  @type t() :: %__MODULE__{
          host: String.t(),
          port: integer(),
          room_service: String.t(),
          username: String.t(),
          password: String.t(),
          mode: String.t()
        }

  @spec get_config() :: Configs.t()
  def get_config do
    struct(Configs, Application.get_all_env(:ex_ejabbered_api))
  end
end
