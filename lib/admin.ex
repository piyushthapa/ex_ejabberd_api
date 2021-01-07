defmodule EjabberedApi.Admin do
  @moduledoc """
    Ejabbered Admin APis

  """
  alias EjabberedApi.Configs

  @doc """
    Add an item to a user's roster
    https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#add-rosteritem
  """
  @spec add_rosteritem(map()) :: {:ok, any()} | {:error, any()}
  def add_rosteritem(params) when is_map(params) do
    fetch(params, "api/add_rosteritem")
  end

  @doc """
    Register a user
    https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#register    

  """
  @spec register(map()) :: {:ok, any()} | {:error, any()}
  def register(params) when is_map(params) do
    params
    |> add_host_to_params()
    |> fetch("api/register")
  end

  @doc """
    Check if an account exists or not
    https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#check-account

  """
  @spec check_account(map()) :: {:ok, any()} | {:error, any()}
  def check_account(params) do
    params
    |> add_host_to_params()
    |> fetch("api/check_account")
  end

  @doc """
    Create a MUC room name@service in host
    https://docs.ejabberd.im/developer/ejabberd-api/admin-api/#create-room

  """
  @spec create_room(map()) :: {:ok, any()} | {:error, any()}
  def create_room(params) when is_map(params) do
    params
    |> add_host_to_params()
    |> add_service_to_params()
    |> fetch("api/create_room")
  end

  defp add_host_to_params(params) do
    config = Configs.get_config()
    Map.put_new(params, :host, config.host)
  end

  defp add_service_to_params(params) do
    %Configs{room_service: service_name} = Configs.get_config()
    Map.put_new(params, :service, service_name)
  end

  defp fetch(params, action) do
    configs = Configs.get_config()
    header = auth_header(configs)

    case HTTPoison.post(prepare_url(action, configs), Jason.encode!(params), header) do
      {:ok, %HTTPoison.Response{body: body}} ->
        {:ok, process_response(body)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, process_response(reason)}
    end
  end

  defp auth_header(%Configs{username: username, password: password}) do
    token = Base.encode64("#{username}:#{password}")

    [Authorization: "Basic #{token}"]
  end

  defp prepare_url(url, %Configs{host: host, port: port}) do
    "https://#{host}:#{port}/#{url}"
  end

  defp process_response(response) do
    case Jason.decode(response) do
      {:ok, data} -> data
      _ -> response
    end
  end
end
